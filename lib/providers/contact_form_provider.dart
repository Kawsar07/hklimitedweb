import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/chat_service.dart';

enum SubmitStatus { idle, sending, success, error }

/// Immutable snapshot of where the contact form submission stands.
class ContactFormState {
  final SubmitStatus status;
  final String? message;

  const ContactFormState({this.status = SubmitStatus.idle, this.message});

  bool get isSending => status == SubmitStatus.sending;

  /// True once a terminal state is reached that should clear the form.
  bool get shouldResetForm => status == SubmitStatus.success;
}

/// Delivers a contact-page enquiry straight into Firebase (the
/// `contact_messages` collection), so it lands in the admin app's
/// "Contact Messages" inbox alongside live chat — no email service or
/// mailto fallback needed anymore.
class ContactFormController extends Notifier<ContactFormState> {
  @override
  ContactFormState build() => const ContactFormState();

  Future<void> submit({
    required String name,
    required String email,
    required String message,
  }) async {
    state = const ContactFormState(status: SubmitStatus.sending);
    try {
      await ChatService.instance.sendContactMessage(
        name: name,
        email: email,
        message: message,
      );
      state = const ContactFormState(
        status: SubmitStatus.success,
        message: 'Thanks — your message has reached our team. '
            "We'll be in touch shortly.",
      );
    } catch (e) {
      state = ContactFormState(
        status: SubmitStatus.error,
        message: "Couldn't send your message just now. Please try again, "
            'or reach us by phone or email instead.',
      );
    }
  }

  /// Lets the widget go back to a neutral state once it has shown the
  /// result to the user and cleared the fields.
  void acknowledge() => state = const ContactFormState();
}

final contactFormProvider =
    NotifierProvider.autoDispose<ContactFormController, ContactFormState>(
  ContactFormController.new,
);
