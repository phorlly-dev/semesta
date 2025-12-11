import 'package:flutter/material.dart';
import 'package:semesta/core/models/user_model.dart';

class FollowButton extends StatelessWidget {
  final UserModel user;
  final FollowState state;
  final VoidCallback onPressed;

  const FollowButton({
    super.key,
    required this.user,
    required this.state,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    late String label;
    late Color bg;
    late Color text;

    switch (state) {
      case FollowState.following:
        label = "Following";
        bg = Colors.transparent;
        text = colors.primary;
        break;

      case FollowState.followBack:
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

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: FilledButton.tonal(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: bg,
          minimumSize: Size(46, 12),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: state == FollowState.following
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

FollowState resolveState(bool iFollow, bool theyFollow) {
  if (!iFollow && theyFollow) return FollowState.followBack;
  if (iFollow) return FollowState.following;
  return FollowState.follow;
}
