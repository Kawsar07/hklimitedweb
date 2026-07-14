import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/app_theme.dart';
import '../core/content.dart';
import '../core/responsive.dart';
import '../providers/contact_form_provider.dart';
import '../widgets/cta_button.dart';
import '../widgets/page_scaffold.dart';
import '../widgets/section.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PageScaffold(
      sections: [
        _PageHeader(),
        _ContactBody(),
      ],
    );
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.navy,
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.pagePadding(context),
        vertical: 48,
      ),
      child: MaxWidthBox(
        maxWidth: 1240,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Us',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 12),
            const Text(
              'We aim to respond to every enquiry within 24 hours.',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactBody extends StatelessWidget {
  const _ContactBody();

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    const info = _ContactInfoCard();
    const form = _ContactForm();

    return Section(
      background: Colors.white,
      child: isMobile
          ? const Column(children: [info, SizedBox(height: 32), form])
          : const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: info),
                SizedBox(width: 40),
                Expanded(flex: 3, child: form),
              ],
            ),
    );
  }
}

class _ContactInfoCard extends StatelessWidget {
  const _ContactInfoCard();

  Future<void> _call() async {
    final uri = Uri(scheme: 'tel', path: Company.phone);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _email() async {
    final uri = Uri(scheme: 'mailto', path: Company.email);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Get in touch', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            'For general enquiries, partnership opportunities and service requests.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          _InfoRow(
            icon: Icons.call_rounded,
            label: 'Phone',
            value: Company.phone,
            onTap: _call,
          ),
          _InfoRow(
            icon: Icons.email_rounded,
            label: 'Email',
            value: Company.email,
            onTap: _email,
          ),
          const _InfoRow(
            icon: Icons.location_on_rounded,
            label: 'Headquarters',
            value: Company.hq,
          ),
          const _InfoRow(
            icon: Icons.language_rounded,
            label: 'Website',
            value: Company.website,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;
  const _InfoRow({required this.icon, required this.label, required this.value, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(color: AppColors.navy, shape: BoxShape.circle),
              child: Icon(icon, color: AppColors.amber, size: 19),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: AppColors.inkMuted, fontSize: 12.5)),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.w700, fontSize: 15),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// The submit/http/mailto-fallback logic now lives entirely in
/// [ContactFormController] (see providers/contact_form_provider.dart).
/// This widget's only jobs are: hold the text controllers, read the
/// current [ContactFormState], and react to it (snackbar + reset).
class _ContactForm extends ConsumerStatefulWidget {
  const _ContactForm();

  @override
  ConsumerState<_ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends ConsumerState<_ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _message = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _message.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    ref.read(contactFormProvider.notifier).submit(
          name: _name.text.trim(),
          email: _email.text.trim(),
          message: _message.text.trim(),
        );
  }

  void _resetFields() {
    _formKey.currentState!.reset();
    _name.clear();
    _email.clear();
    _message.clear();
  }

  InputDecoration _decoration(String label) => InputDecoration(
        labelText: label,
        filled: true,
        fillColor: AppColors.paper,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: const BorderSide(color: AppColors.amber, width: 1.6),
        ),
      );

  @override
  Widget build(BuildContext context) {
    // Whenever the controller's state changes, show the result and, on a
    // successful/mailto outcome, clear the form — then hand the provider
    // back to idle so this doesn't fire again on rebuild.
    ref.listen<ContactFormState>(contactFormProvider, (previous, next) {
      if (next.status == SubmitStatus.idle || next.status == SubmitStatus.sending) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(next.message ?? ''),
          backgroundColor: next.status == SubmitStatus.error
              ? Colors.red.shade700
              : AppColors.navy,
        ),
      );
      if (next.shouldResetForm) _resetFields();
      ref.read(contactFormProvider.notifier).acknowledge();
    });

    final isSending = ref.watch(contactFormProvider).isSending;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Send a message', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 20),
          TextFormField(
            controller: _name,
            decoration: _decoration('Full name'),
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter your name' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _email,
            decoration: _decoration('Email address'),
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Please enter your email';
              if (!v.contains('@')) return 'Please enter a valid email';
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _message,
            decoration: _decoration('How can we help?'),
            maxLines: 5,
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Please add a short message' : null,
          ),
          const SizedBox(height: 22),
          CtaButton(
            label: isSending ? 'Sending...' : 'Send Message',
            icon: isSending ? null : Icons.send_rounded,
            onPressed: isSending ? () {} : _submit,
          ),
          const SizedBox(height: 10),
          const Text(
            'Your message goes straight to our team \u2014 we usually reply '
            'within 24 hours.',
            style: TextStyle(color: AppColors.inkMuted, fontSize: 12.5),
          ),
        ],
      ),
    );
  }
}
