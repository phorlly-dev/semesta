import 'package:flutter/material.dart';
import 'package:semesta/app/utils/format.dart';

class ActionButton extends StatelessWidget {
  final dynamic icon;
  final String label;
  final double sizeIcon;
  final Color? color;
  final VoidCallback? onPressed, onLongPress;
  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    this.onPressed,
    this.onLongPress,
    this.sizeIcon = 20,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      onLongPress: onLongPress,
      icon: icon is IconData
          ? Icon(icon, size: sizeIcon)
          : Image(
              image: AssetImage(setImage(icon, true)),
              width: sizeIcon,
              height: sizeIcon,
            ),
      label: Text(label),
      style: TextButton.styleFrom(
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 28),
      ),
    );
  }
}
