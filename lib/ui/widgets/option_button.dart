import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/functions/format.dart';

class OptionButton extends StatelessWidget {
  final dynamic icon;
  final String label;
  final Color? color;
  final double sizeIcon;
  final VoidCallback? onTap;
  final Widget? status;

  const OptionButton({
    super.key,
    this.icon,
    required this.label,
    this.color,
    this.sizeIcon = 24,
    this.onTap,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    final theColor = color ?? Theme.of(context).colorScheme.secondary;
    final iconWidget = icon is IconData
        ? Icon(icon, size: sizeIcon, color: theColor)
        : Image.asset(
            setImage(icon, true),
            width: sizeIcon,
            height: sizeIcon,
            color: theColor,
          );

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: iconWidget,
      title: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          color: theColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: status,
      onTap: onTap != null
          ? () {
              context.pop();
              onTap?.call();
            }
          : null,
    );
  }
}
