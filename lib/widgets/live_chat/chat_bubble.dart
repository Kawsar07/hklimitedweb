import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../core/app_theme.dart';

/// A single message bubble. Shared by the visitor-facing widget and the
/// /admin reply page so both sides render an identical, standard chat
/// thread rather than two one-off layouts.
class ChatBubble extends StatelessWidget {
  final String text;
  final bool isMine;
  final Timestamp? createdAt;

  const ChatBubble({
    super.key,
    required this.text,
    required this.isMine,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isMine ? AppColors.navy : Colors.white;
    final fg = isMine ? Colors.white : AppColors.ink;
    final radius = BorderRadius.only(
      topLeft: const Radius.circular(14),
      topRight: const Radius.circular(14),
      bottomLeft: Radius.circular(isMine ? 14 : 4),
      bottomRight: Radius.circular(isMine ? 4 : 14),
    );

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 260),
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: radius,
          border: isMine ? null : Border.all(color: AppColors.line),
          boxShadow: [
            BoxShadow(
              color: AppColors.navy.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: TextStyle(color: fg, fontSize: 13.5, height: 1.4),
            ),
            if (createdAt != null) ...[
              const SizedBox(height: 4),
              Text(
                _formatTime(createdAt!.toDate()),
                style: TextStyle(
                  color: isMine ? Colors.white.withOpacity(0.65) : AppColors.inkMuted,
                  fontSize: 10.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static String _formatTime(DateTime dt) {
    final h24 = dt.hour;
    final h12 = h24 % 12 == 0 ? 12 : h24 % 12;
    final period = h24 < 12 ? 'AM' : 'PM';
    final min = dt.minute.toString().padLeft(2, '0');
    return '$h12:$min $period';
  }
}
