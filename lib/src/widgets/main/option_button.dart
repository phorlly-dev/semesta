import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/public/extensions/context_extension.dart';
import 'package:semesta/public/extensions/string_extension.dart';

class OptionButton extends StatelessWidget {
  final dynamic icon;
  final String _label;
  final Color? color;
  final double sizeIcon;
  final bool canPop;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final TextStyle? style;
  final Widget? status;
  const OptionButton(
    this._label, {
    super.key,
    this.icon,
    this.color,
    this.sizeIcon = 20,
    this.onTap,
    this.status,
    this.padding,
    this.style,
    this.canPop = true,
  });

  @override
  Widget build(BuildContext context) {
    final iconWidget = icon is IconData
        ? Icon(icon, size: sizeIcon, color: color)
        : Image.asset(
            '$icon'.toIcon(true),
            width: sizeIcon,
            height: sizeIcon,
            color: color,
          );

    return ListTile(
      contentPadding: padding,
      leading: iconWidget,
      title: Text(_label, style: style ?? context.text.bodyLarge),
      trailing: status,
      onTap: onTap != null
          ? () {
              if (canPop) context.pop();
              onTap?.call();
            }
          : null,
    );
  }
}
