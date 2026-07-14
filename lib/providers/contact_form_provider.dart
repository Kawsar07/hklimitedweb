import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../core/content.dart';

enum SubmitStatus { idle, sending, success, mailtoOpened, error }

/// Immutable snapshot of where the contact form submission stands.
/// The widget only ever reads this — it never touches http or url_launcher
/// directly anymore.
class ContactFormState {
  final SubmitStatus status;
  final String? message;

  const ContactFormState({this.status = SubmitStatus.idle, this.message});

  bool get isSending => status == SubmitStatus.sending;

  /// True once a terminal state is reached that should clear the form
  /// (successful delivery, or the user's email app was opened for them).
  bool get shouldResetForm =>
      status == SubmitStatus.success || status == SubmitStatus.mailtoOpened;
}

/// Owns all the "how do we actually deliver this enquiry" logic that used
/// to live inside `_ContactFormState.dispose/_submit/_sendViaMailto`.
///
/// Built on Riverpod's `Notifier` (the API that replaced `StateNotifier`
/// as of Riverpod 3.0 — `StateNotifier`/`StateNotifierProvider` were moved
/// to `package:flutter_riverpod/legacy.dart` and are discouraged for new
/// code, so this uses the current recommended API instead).
class ContactFormController extends Notifier<ContactFormState> {
  @override
  ContactFormState build() => const ContactFormState();

  bool get _web3FormsConfigured =>
      Company.web3FormsAccessKey.trim().isNotEmpty &&
      Company.web3FormsAccessKey != 'YOUR_WEB3FORMS_ACCESS_KEY';

  Future<void> submit({
    required String name,
    required String email,
    required String message,
  }) async {
    // No backend configured yet — go straight to the mailto: fallback
    // instead of pretending we tried to deliver it silently.
    if (!_web3FormsConfigured) {
      await _fallbackToMailto(name: name, email: email, message: message);
      return;
    }

    state = const ContactFormState(status: SubmitStatus.sending);
    try {
      final response = await http.post(
        Uri.parse('https://api.web3forms.com/submit'),
        headers: {'Accept': 'application/json'},
        body: {
          'access_key': Company.web3FormsAccessKey,
          'subject': 'New enquiry from ${Company.name} website',
          'from_name': name,
          'email': email,
          'message': message,
        },
      );
      final ok = response.statusCode == 200 &&
          (jsonDecode(response.body)['success'] == true);

      if (ok) {
        state = const ContactFormState(
          status: SubmitStatus.success,
          message: 'Thanks — your message is on its way to our team. '
              "We'll be in touch shortly.",
        );
      } else {
        await _fallbackToMailto(name: name, email: email, message: message);
      }
    } catch (_) {
      await _fallbackToMailto(name: name, email: email, message: message);
    }
  }

  Future<void> _fallbackToMailto({
    required String name,
    required String email,
    required String message,
  }) async {
    final uri = Uri(
      scheme: 'mailto',
      path: Company.contactRecipient,
      query: Uri(queryParameters: {
        'subject': 'New enquiry from ${Company.name} website',
        'body': 'Name: $name\nEmail: $email\n\n$message',
      }).query,
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      state = const ContactFormState(
        status: SubmitStatus.mailtoOpened,
        message: 'Opening your email app so you can send this to our team '
            '— just hit send.',
      );
    } else {
      state = const ContactFormState(
        status: SubmitStatus.error,
        message: "Couldn't open an email app automatically. Please try "
            'again or reach us by phone instead.',
      );
    }
  }

  /// Lets the widget go back to a neutral state once it has shown the
  /// result to the user and cleared the fields.
  void acknowledge() => state = const ContactFormState();
}

/// `.autoDispose` so the controller (and any pending http call reference)
/// is thrown away once the Contact page is no longer in the tree, instead
/// of quietly living for the rest of the app session.
final contactFormProvider =
    NotifierProvider.autoDispose<ContactFormController, ContactFormState>(
  ContactFormController.new,
);
