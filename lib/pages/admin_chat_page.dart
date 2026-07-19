import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../core/chat_service.dart';
import '../widgets/live_chat/chat_bubble.dart';

/// Not linked from the nav bar — reachable only by visiting /admin directly.
/// Lets Solar PV HK reply to visitor live-chat threads from the browser.
///
/// Security note: the UI gate below is just for convenience. The real
/// protection is firestore.rules, which only lets a request read every
/// thread or write sender:'admin' messages when Firebase Auth's current
/// user email matches kAdminEmail — so even someone who guesses this URL
/// can't read other visitors' conversations without that login.
class AdminChatPage extends StatelessWidget {
  const AdminChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      body: StreamBuilder<User?>(
        stream: ChatService.instance.authState(),
        builder: (context, snap) {
          final signedInAsAdmin = ChatService.instance.isAdmin;
          if (!signedInAsAdmin) return const _AdminLogin();
          return const _AdminDashboard();
        },
      ),
    );
  }
}

class _AdminLogin extends StatefulWidget {
  const _AdminLogin();

  @override
  State<_AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<_AdminLogin> {
  final _email = TextEditingController(text: kAdminEmail);
  final _password = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _signIn() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ChatService.instance.adminSignIn(_email.text.trim(), _password.text);
    } catch (e) {
      setState(() => _error = 'Sign-in failed. Check the email/password.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(Icons.lock_outline_rounded, size: 36, color: AppColors.navy),
              const SizedBox(height: 12),
              Text(
                'Live chat admin',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 22),
              ),
              const SizedBox(height: 6),
              Text(
                'Sign in with the admin account set up in Firebase Authentication.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _email,
                decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _password,
                obscureText: true,
                onSubmitted: (_) => _signIn(),
                decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
              ),
              if (_error != null) ...[
                const SizedBox(height: 10),
                Text(_error!, style: const TextStyle(color: Colors.redAccent, fontSize: 12.5)),
              ],
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loading ? null : _signIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.navy,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(_loading ? 'Signing in…' : 'Sign in'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdminDashboard extends StatefulWidget {
  const _AdminDashboard();

  @override
  State<_AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<_AdminDashboard> {
  String? _selectedUid;
  String? _selectedName;
  String? _selectedEmail;

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.of(context).size.width < 800;

    final list = _ThreadList(
      selectedUid: _selectedUid,
      onSelect: (uid, name, email) {
        setState(() {
          _selectedUid = uid;
          _selectedName = name;
          _selectedEmail = email;
        });
        ChatService.instance.markReadByAdmin(uid);
      },
    );

    final detail = _selectedUid == null
        ? const Center(child: Text('Select a conversation'))
        : _ThreadDetail(
            uid: _selectedUid!,
            name: _selectedName ?? 'Visitor',
            email: _selectedEmail ?? '',
          );

    return SafeArea(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(color: AppColors.navy),
            child: Row(
              children: [
                const Icon(Icons.support_agent_rounded, color: AppColors.amber),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text('Live chat — admin', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                ),
                TextButton.icon(
                  onPressed: () => ChatService.instance.signOut(),
                  icon: const Icon(Icons.logout_rounded, size: 16, color: Colors.white70),
                  label: const Text('Sign out', style: TextStyle(color: Colors.white70)),
                ),
              ],
            ),
          ),
          Expanded(
            child: isNarrow
                ? (_selectedUid == null
                    ? list
                    : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton.icon(
                                onPressed: () => setState(() => _selectedUid = null),
                                icon: const Icon(Icons.arrow_back_rounded, size: 18),
                                label: const Text('All conversations'),
                              ),
                            ),
                          ),
                          Expanded(child: detail),
                        ],
                      ))
                : Row(
                    children: [
                      SizedBox(width: 300, child: list),
                      const VerticalDivider(width: 1),
                      Expanded(child: detail),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _ThreadList extends StatelessWidget {
  final String? selectedUid;
  final void Function(String uid, String name, String email) onSelect;

  const _ThreadList({required this.selectedUid, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: ChatService.instance.allThreads(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        }
        final docs = snap.data!.docs;
        if (docs.isEmpty) {
          return const Center(child: Text('No conversations yet'));
        }
        return ListView.separated(
          itemCount: docs.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, i) {
            final d = docs[i];
            final data = d.data();
            final name = (data['name'] as String?)?.trim();
            final email = (data['email'] as String?)?.trim();
            final unread = data['unreadForAdmin'] == true;
            return ListTile(
              selected: d.id == selectedUid,
              selectedTileColor: AppColors.amber.withOpacity(0.12),
              title: Text(
                (name == null || name.isEmpty) ? 'Visitor' : name,
                style: TextStyle(fontWeight: unread ? FontWeight.w700 : FontWeight.w500),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (email != null && email.isNotEmpty)
                    Text(
                      email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11.5, color: AppColors.inkMuted),
                    ),
                  Text(
                    (data['lastMessage'] as String?) ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              trailing: unread
                  ? Container(
                      width: 9,
                      height: 9,
                      decoration: const BoxDecoration(color: AppColors.reed, shape: BoxShape.circle),
                    )
                  : null,
              onTap: () => onSelect(
                d.id,
                (name == null || name.isEmpty) ? 'Visitor' : name,
                email ?? '',
              ),
            );
          },
        );
      },
    );
  }
}

class _ThreadDetail extends StatefulWidget {
  final String uid;
  final String name;
  final String email;
  const _ThreadDetail({required this.uid, required this.name, required this.email});

  @override
  State<_ThreadDetail> createState() => _ThreadDetailState();
}

class _ThreadDetailState extends State<_ThreadDetail> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  bool _sending = false;

  @override
  void didUpdateWidget(covariant _ThreadDetail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.uid != widget.uid) _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    _controller.clear();
    await ChatService.instance.sendAdminReply(widget.uid, text);
    if (mounted) setState(() => _sending = false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: AppColors.line))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.name, style: Theme.of(context).textTheme.titleMedium),
              if (widget.email.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  widget.email,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12.5),
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: ChatService.instance.messages(widget.uid),
            builder: (context, snap) {
              if (!snap.hasData) {
                return const Center(child: CircularProgressIndicator(strokeWidth: 2));
              }
              final docs = snap.data!.docs;
              return ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: docs.length,
                itemBuilder: (context, i) {
                  final data = docs[i].data();
                  return ChatBubble(
                    text: data['text'] as String? ?? '',
                    isMine: data['sender'] == 'admin',
                    createdAt: data['createdAt'] as Timestamp?,
                  );
                },
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: AppColors.line))),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  minLines: 1,
                  maxLines: 4,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _send(),
                  decoration: InputDecoration(
                    hintText: 'Reply…',
                    isDense: true,
                    filled: true,
                    fillColor: AppColors.paper,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: _sending ? null : _send,
                style: IconButton.styleFrom(backgroundColor: AppColors.navy),
                icon: const Icon(Icons.send_rounded),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
