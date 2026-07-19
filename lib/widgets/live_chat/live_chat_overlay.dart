import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show debugPrint, kDebugMode;
import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../core/chat_service.dart';
import 'chat_bubble.dart';

/// The floating "Chat with us" bubble + panel, shown on every page (wired
/// in via MaterialApp.builder in main.dart so it sits above all routes).
///
/// No name/email step — a visitor can start typing straight away. Fails
/// quietly in production if Firebase isn't set up yet; shows a small red
/// debug chip (debug builds only) explaining why, so it's easy to catch
/// while developing.
class LiveChatOverlay extends StatefulWidget {
  final bool firebaseReady;
  const LiveChatOverlay({super.key, required this.firebaseReady});

  @override
  State<LiveChatOverlay> createState() => _LiveChatOverlayState();
}

class _LiveChatOverlayState extends State<LiveChatOverlay> {
  bool _open = false;
  String? _uid;
  DateTime? _lastSeenAt;
  String? _bootError;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.firebaseReady) {
      _boot();
    } else {
      const msg = 'Firebase.initializeApp() itself failed in main.dart — '
          'check firebase_options.dart / your Firebase project config.';
      debugPrint('[live-chat] firebaseReady is false — $msg');
      _bootError = msg;
    }
  }

  @override
  void didUpdateWidget(covariant LiveChatOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Firebase now initialises in the background (see main.dart), so this
    // widget may be rebuilt with firebaseReady flipping false -> true after
    // first paint. Boot the chat session the moment that happens.
    if (widget.firebaseReady && !oldWidget.firebaseReady && _uid == null) {
      _bootError = null;
      _boot();
    }
  }

  Future<void> _boot() async {
    try {
      final uid = await ChatService.instance.ensureSignedIn();
      if (mounted) setState(() => _uid = uid);
    } catch (e) {
      const msg = 'Anonymous sign-in failed — in Firebase Console, check '
          'Authentication > Sign-in method > Anonymous is enabled, and that '
          'a Firestore Database has been created.';
      debugPrint('[live-chat] $msg ($e)');
      if (mounted) setState(() => _bootError = msg);
    }
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) _lastSeenAt = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final size = media.size;
    final isMobile = size.width < 600;

    if (!widget.firebaseReady || _uid == null) {
      if (kDebugMode) {
        return Positioned(
          right: isMobile ? 16 : 24,
          bottom: isMobile ? 16 : 24,
          child:
              _DebugUnavailableChip(reason: _bootError ?? 'Still connecting…'),
        );
      }
      return const SizedBox.shrink();
    }

    // On a phone, an open panel fills almost the whole screen (like every
    // production chat widget). On tablet/desktop it's a fixed-width card
    // anchored bottom-right.
    if (_open) {
      if (isMobile) {
        // A floating, rounded panel over a dimmed backdrop — the look every
        // production mobile chat widget uses, instead of a raw full-screen
        // page. Tapping the backdrop closes it, and the panel lifts above
        // the keyboard when the input is focused.
        // Cap the panel height so it doesn't swallow the whole screen —
        // a shorter, bottom-anchored card (like Intercom / Crisp on mobile)
        // that still fits above the keyboard.
        final available =
            size.height - media.padding.top - media.viewInsets.bottom - 24;
        final desired = (size.height * 0.62).clamp(360.0, 560.0);
        final panelH = desired < available ? desired : available;
        // Cap the width too, so on wider phones it doesn't stretch edge to
        // edge — a right-anchored card, like production chat widgets.
        final panelW = (size.width - 24).clamp(0.0, 400.0);

        return Positioned.fill(
          child: Stack(
            children: [
              GestureDetector(
                onTap: _toggle,
                child: Container(color: Colors.black.withOpacity(0.4)),
              ),
              Positioned(
                right: 12,
                bottom: media.viewInsets.bottom + 12,
                child: SizedBox(
                  width: panelW,
                  height: panelH,
                  child: _ChatPanel(
                    uid: _uid!,
                    scrollController: _scrollController,
                    fullScreen: false,
                    onClose: _toggle,
                  ),
                ),
              ),
            ],
          ),
        );
      }
      final panelHeight = (size.height - 140).clamp(360.0, 560.0);
      return Positioned(
        right: 24,
        bottom: 24,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 384,
              height: panelHeight,
              child: _ChatPanel(
                uid: _uid!,
                scrollController: _scrollController,
                fullScreen: false,
                onClose: _toggle,
              ),
            ),
            const SizedBox(height: 14),
            _LauncherButton(
                open: true,
                uid: _uid!,
                lastSeenAt: _lastSeenAt,
                onTap: _toggle),
          ],
        ),
      );
    }

    return Positioned(
      right: isMobile ? 16 : 24,
      bottom: isMobile ? 16 : 24,
      child: _LauncherButton(
          open: false, uid: _uid!, lastSeenAt: _lastSeenAt, onTap: _toggle),
    );
  }
}

/// Debug-build-only diagnostic. Never shown in a release build, so real
/// visitors never see it. Not a Tooltip (that needs an Overlay ancestor,
/// which this Stack-based widget sits outside of) — a plain tap-to-expand.
class _DebugUnavailableChip extends StatefulWidget {
  final String reason;
  const _DebugUnavailableChip({required this.reason});

  @override
  State<_DebugUnavailableChip> createState() => _DebugUnavailableChipState();
}

class _DebugUnavailableChipState extends State<_DebugUnavailableChip> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 260),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.warning_amber_rounded,
                    color: Colors.red.shade700, size: 18),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'Live chat hidden (debug only) — tap for why',
                    style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            if (_expanded) ...[
              const SizedBox(height: 6),
              Text(widget.reason,
                  style: TextStyle(color: Colors.red.shade900, fontSize: 11)),
            ],
          ],
        ),
      ),
    );
  }
}

class _LauncherButton extends StatelessWidget {
  final bool open;
  final String uid;
  final DateTime? lastSeenAt;
  final VoidCallback onTap;

  const _LauncherButton({
    required this.open,
    required this.uid,
    required this.lastSeenAt,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    // A labelled pill reads clearest when closed on desktop; on mobile, or
    // once the panel is open, it collapses to a compact circular button.
    final pill = !open && !isMobile;

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: ChatService.instance.threadStream(uid),
      builder: (context, snap) {
        final data = snap.data?.data();
        final lastSender = data?['lastSender'] as String?;
        final lastMessageAt = data?['lastMessageAt'] as Timestamp?;
        final hasUnread = !open &&
            lastSender == 'admin' &&
            lastMessageAt != null &&
            (lastSeenAt == null || lastMessageAt.toDate().isAfter(lastSeenAt!));

        // Chat icon (or close) with a small "online" dot tucked into its
        // corner — kept inside the button bounds so nothing gets clipped.
        final iconWithDot = Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              transitionBuilder: (child, anim) =>
                  ScaleTransition(scale: anim, child: child),
              child: Icon(
                open ? Icons.close_rounded : Icons.forum_rounded,
                key: ValueKey(open),
                color: Colors.white,
                size: 26,
              ),
            ),
            if (!open)
              Positioned(
                right: -3,
                bottom: -3,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF31C971),
                    border: Border.all(color: AppColors.navy, width: 2),
                  ),
                ),
              ),
          ],
        );

        final button = Material(
          color: AppColors.navy,
          elevation: 6,
          shadowColor: AppColors.navy.withOpacity(0.5),
          clipBehavior: Clip.antiAlias,
          shape: pill
              ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
              : const CircleBorder(),
          child: InkWell(
            onTap: onTap,
            child: Container(
              height: 60,
              width: pill ? null : 60,
              alignment: Alignment.center,
              padding: pill
                  ? const EdgeInsets.fromLTRB(20, 0, 24, 0)
                  : EdgeInsets.zero,
              child: pill
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        iconWithDot,
                        const SizedBox(width: 11),
                        const Text(
                          'Chat with us',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    )
                  : iconWithDot,
            ),
          ),
        );

        // Unread badge sits at the outer top-right corner, outside the
        // clipped button so it isn't cut off.
        return Stack(
          clipBehavior: Clip.none,
          children: [
            button,
            if (hasUnread)
              Positioned(
                top: -3,
                right: -3,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.shade500,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ChatPanel extends StatefulWidget {
  final String uid;
  final ScrollController scrollController;
  final bool fullScreen;
  final VoidCallback onClose;

  const _ChatPanel({
    required this.uid,
    required this.scrollController,
    required this.fullScreen,
    required this.onClose,
  });

  @override
  State<_ChatPanel> createState() => _ChatPanelState();
}

class _ChatPanelState extends State<_ChatPanel> {
  final _messageController = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    _messageController.clear();
    try {
      await ChatService.instance.sendVisitorMessage(widget.uid, text);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!widget.scrollController.hasClients) return;
      widget.scrollController.animateTo(
        widget.scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.fullScreen ? 0.0 : AppRadius.lg;

    return Material(
      // Clean, neutral chat background — a soft grey so the white incoming
      // bubbles and navy outgoing bubbles both read clearly.
      color: const Color(0xFFEEF1F6),
      borderRadius: BorderRadius.circular(radius),
      clipBehavior: Clip.antiAlias,
      elevation: widget.fullScreen ? 0 : 12,
      shadowColor: AppColors.navy.withOpacity(0.3),
      child: SafeArea(
        top: widget.fullScreen,
        bottom: widget.fullScreen,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            _Header(onClose: widget.onClose),
            Expanded(
              child: _MessageList(
                uid: widget.uid,
                scrollController: widget.scrollController,
                onFirstLoad: _scrollToBottom,
              ),
            ),
            _InputBar(
                controller: _messageController,
                sending: _sending,
                onSend: _send),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onClose;
  const _Header({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 12, 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.navy, AppColors.navyDeep],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.support_agent_rounded,
                    color: AppColors.amber, size: 21),
              ),
              Positioned(
                right: -1,
                bottom: -1,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF31C971),
                    border: Border.all(color: AppColors.navy, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Solar PV HK Limited',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15),
                ),
                SizedBox(height: 2),
                Text(
                  'Online — usually replies within a few hours',
                  style: TextStyle(color: Colors.white70, fontSize: 11.5),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close_rounded, color: Colors.white70),
            splashRadius: 20,
            tooltip: 'Close',
          ),
        ],
      ),
    );
  }
}

class _MessageList extends StatelessWidget {
  final String uid;
  final ScrollController scrollController;
  final VoidCallback onFirstLoad;

  const _MessageList({
    required this.uid,
    required this.scrollController,
    required this.onFirstLoad,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: ChatService.instance.messages(uid),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        }
        final docs = snap.data!.docs;
        if (docs.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.reed.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.waving_hand_rounded,
                        color: AppColors.reed, size: 26),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Hi there! 👋',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontSize: 17),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Send us a message and we’ll get right back to you.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          );
        }
        onFirstLoad();
        return ListView.builder(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
          itemCount: docs.length,
          itemBuilder: (context, i) {
            final data = docs[i].data();
            return ChatBubble(
              text: data['text'] as String? ?? '',
              isMine: data['sender'] == 'visitor',
              createdAt: data['createdAt'] as Timestamp?,
            );
          },
        );
      },
    );
  }
}

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final bool sending;
  final VoidCallback onSend;

  const _InputBar(
      {required this.controller, required this.sending, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              minLines: 1,
              maxLines: 4,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
              decoration: InputDecoration(
                hintText: 'Type a message…',
                isDense: true,
                filled: true,
                fillColor: AppColors.paper,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: AppColors.amber,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: sending ? null : onSend,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: sending
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2.2, color: AppColors.navy),
                      )
                    : const Icon(Icons.send_rounded,
                        color: AppColors.navy, size: 21),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
