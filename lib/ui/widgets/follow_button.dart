import 'package:flutter/material.dart';
import 'package:semesta/core/models/author.dart';

class FollowButton extends StatefulWidget {
  final Follow state;
  final VoidCallback onPressed;
  const FollowButton({super.key, required this.state, required this.onPressed});

  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  String label = "Follow";
  Color bg = Colors.blueAccent;
  Color text = Colors.white;

  void initStatus(ColorScheme colors) {
    switch (widget.state) {
      case Follow.following:
        label = "Following";
        bg = Colors.transparent;
        text = colors.primary;
        break;

      case Follow.followBack:
        label = "Follow back";
        bg = colors.primary;
        text = colors.onPrimary;
        break;

      default:
        label = "Follow";
        bg = colors.primary;
        text = colors.onPrimary;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    initStatus(colors);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: FilledButton.tonal(
        onPressed: widget.onPressed,
        style: TextButton.styleFrom(
          backgroundColor: bg,
          minimumSize: Size(46, 12),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: widget.state == Follow.following
                ? BorderSide(color: colors.primaryContainer)
                : BorderSide.none,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(color: text, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

Follow resolveState(bool iFollow, bool theyFollow) {
  if (!iFollow && theyFollow) return Follow.followBack;
  if (iFollow) return Follow.following;
  return Follow.follow;
}
