import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final VoidCallback? onPressed, onLongPress;
  final Color? bgColor, textColor, fgColor;
  final String label;
  final BorderSide border;
  final double width, height;

  const CustomTextButton({
    super.key,
    this.onPressed,
    this.onLongPress,
    this.bgColor,
    required this.label,
    this.textColor,
    this.fgColor,
    this.border = BorderSide.none,
    this.width = 10,
    this.height = 4,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      child: FilledButton.tonal(
        onPressed: onPressed,
        onLongPress: onLongPress,
        style: TextButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          minimumSize: Size(46, 12),
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: width, vertical: height),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: border,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
