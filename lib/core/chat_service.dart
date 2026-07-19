import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// The only Firebase Auth email allowed to read every conversation and
/// reply as "Solar PV HK Limited" from the /admin page. Matched against
/// `firestore.rules` (`isAdmin()`) — change both together if you ever need
/// a different admin login.
const String kAdminEmail = 'kawsar@scube.com.bd';

/// One place for every Firestore/Auth call the live chat feature makes.
///
/// Data shape:
///   chats/{uid}                    -> { name?, email?, lastMessage,
///                                        lastMessageAt, lastSender,
///                                        unreadForAdmin, createdAt }
///   chats/{uid}/messages/{msgId}   -> { text, sender: 'visitor'|'admin',
///                                        createdAt }
///   contact_messages/{msgId}       -> { name, email, message, createdAt,
///                                        unreadForAdmin }
/// `{uid}` is the visitor's Firebase Auth uid (anonymous sign-in), so the
/// same browser/visitor always lands back on the same thread. The chat no
/// longer asks for a name/email up front — a visitor can start typing
/// straight away; the Contact page form is the place that collects those.
class ChatService {
  ChatService._();
  static final ChatService instance = ChatService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Signs the visitor in anonymously if nobody is signed in yet. Safe to
  /// call repeatedly. Returns the signed-in user's uid.
  Future<String> ensureSignedIn() async {
    final existing = _auth.currentUser;
    if (existing != null) return existing.uid;
    final cred = await _auth.signInAnonymously();
    return cred.user!.uid;
  }

  String? get currentUid => _auth.currentUser?.uid;

  bool get isAdmin =>
      _auth.currentUser != null && _auth.currentUser!.email == kAdminEmail;

  Stream<User?> authState() => _auth.authStateChanges();

  Future<UserCredential> adminSignIn(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() => _auth.signOut();

  DocumentReference<Map<String, dynamic>> _threadRef(String uid) =>
      _db.collection('chats').doc(uid);

  Stream<DocumentSnapshot<Map<String, dynamic>>> threadStream(String uid) =>
      _threadRef(uid).snapshots();

  /// All visitor threads, most recently active first — used by /admin.
  Stream<QuerySnapshot<Map<String, dynamic>>> allThreads() {
    return _db
        .collection('chats')
        .orderBy('lastMessageAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> messages(String uid) {
    return _threadRef(uid)
        .collection('messages')
        .orderBy('createdAt', descending: false)
        .snapshots();
  }

  Future<void> sendVisitorMessage(String uid, String text) async {
    await _threadRef(uid).collection('messages').add({
      'text': text,
      'sender': 'visitor',
      'createdAt': FieldValue.serverTimestamp(),
    });
    await _threadRef(uid).set({
      'lastMessage': text,
      'lastMessageAt': FieldValue.serverTimestamp(),
      'lastSender': 'visitor',
      'unreadForAdmin': true,
    }, SetOptions(merge: true));
  }

  /// Contact-page form submission. Writes to a separate top-level
  /// `contact_messages` collection (not tied to the chat threads) so the
  /// admin app can show "Contact Messages" as its own inbox tab.
  Future<void> sendContactMessage({
    required String name,
    required String email,
    required String message,
  }) async {
    // The Contact form is reachable without opening the chat bubble first,
    // so make sure we have an anonymous auth session (firestore.rules only
    // allows a signed-in request to create a contact message).
    await ensureSignedIn();
    await _db.collection('contact_messages').add({
      'name': name,
      'email': email,
      'message': message,
      'createdAt': FieldValue.serverTimestamp(),
      'unreadForAdmin': true,
    });
  }

  Future<void> sendAdminReply(String uid, String text) async {
    await _threadRef(uid).collection('messages').add({
      'text': text,
      'sender': 'admin',
      'createdAt': FieldValue.serverTimestamp(),
    });
    await _threadRef(uid).set({
      'lastMessage': text,
      'lastMessageAt': FieldValue.serverTimestamp(),
      'lastSender': 'admin',
      'unreadForAdmin': false,
    }, SetOptions(merge: true));
  }

  Future<void> markReadByAdmin(String uid) {
    return _threadRef(uid).set({'unreadForAdmin': false}, SetOptions(merge: true));
  }
}
