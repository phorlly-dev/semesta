import 'package:flutter/material.dart';
import 'package:semesta/app/models/author.dart';
import 'package:semesta/public/extensions/extension.dart';

class FollowButton extends StatelessWidget {
  final Follow _state;
  final VoidCallback onPressed;
  const FollowButton(this._state, {super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    String label = "Follow";
    Color bg = Colors.blueAccent;
    Color text = Colors.white;

    switch (_state) {
      case Follow.following:
        label = "Following";
        bg = Colors.transparent;
        text = context.primaryColor;
        break;

      case Follow.followBack:
        label = "Follow back";
        bg = context.primaryColor;
        text = context.colors.onPrimary;
        break;

      default:
        label = "Follow";
        bg = context.primaryColor;
        text = context.colors.onPrimary;
        break;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: FilledButton.tonal(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: bg,
          minimumSize: Size(46, 12),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: _state == Follow.following
                ? BorderSide(color: context.colors.primaryContainer)
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
