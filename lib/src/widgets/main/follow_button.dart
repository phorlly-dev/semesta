import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/context_extension.dart';
import 'package:semesta/public/helpers/params_helper.dart';

class FollowButton extends StatelessWidget {
  final Follow _state;
  final VoidCallback onPressed;
  const FollowButton(this._state, {super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final follow = context.state(_state);
    return AnimatedContainer(
      duration: Durations.short4,
      child: FilledButton.tonal(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: follow.background,
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
          follow.label,
          style: TextStyle(
            color: follow.foreground,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
