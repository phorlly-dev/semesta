import 'package:flutter/material.dart';

class AnimatedButton extends StatelessWidget {
  final VoidCallback? onPressed, onLongPress;
  final Color? bgColor, textColor, fgColor;
  final String label;
  final BorderSide border;
  final double px, py;
  const AnimatedButton({
    super.key,
    this.onPressed,
    this.onLongPress,
    this.bgColor,
    required this.label,
    this.textColor,
    this.fgColor,
    this.border = BorderSide.none,
    this.px = 10,
    this.py = 4,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeInOut,
      child: FilledButton.tonal(
        onPressed: onPressed,
        onLongPress: onLongPress,
        style: TextButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          minimumSize: Size(46, 16),
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: px, vertical: py),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: border,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w600, color: textColor),
        ),
      ),
    );
  }
}
