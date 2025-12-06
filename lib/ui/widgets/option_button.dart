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
    final iconWidget = icon is IconData
        ? Icon(icon, size: sizeIcon, color: color)
        : Image.asset(
            setImage(icon, true),
            width: sizeIcon,
            height: sizeIcon,
            color: color,
          );

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: iconWidget,
      title: Text(label, style: TextStyle(fontSize: 16, color: color)),
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
