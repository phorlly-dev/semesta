import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/public/extensions/extension.dart';
import 'package:semesta/src/widgets/sub/direction_y.dart';

class CustomModal<T> {
  final BuildContext _context;
  final bool hidable, full, hasAction;
  final MainAxisSize size;
  final String? title, label;
  final VoidCallback? onConfirm;
  final IconData icon;
  final Color? color;
  final List<Widget> children;

  CustomModal(
    this._context, {
    this.hidable = false,
    this.full = false,
    this.size = MainAxisSize.min,
    this.children = const [],
    this.title,
    this.onConfirm,
    this.icon = Icons.delete,
    this.color,
    this.label,
    this.hasAction = true,
  }) {
    showDialog<T>(
      context: _context,
      fullscreenDialog: full,
      barrierDismissible: hidable,
      builder: (context) => AlertDialog(
        title: title != null ? Text(title!, textAlign: TextAlign.center) : null,
        content: SingleChildScrollView(
          child: Form(
            key: GlobalKey<FormState>(),
            child: DirectionY(mainAxisSize: size, children: children),
          ),
        ),
        actions: hasAction
            ? [
                TextButton.icon(
                  onPressed: () => context.pop(),
                  icon: Icon(Icons.close, color: context.hintColor),
                  label: Text(
                    'Cancel',
                    style: TextStyle(color: context.hintColor),
                  ),
                ),
                TextButton.icon(
                  onPressed: onConfirm,
                  icon: Icon(icon, color: color),
                  label: Text(label ?? 'Yes', style: TextStyle(color: color)),
                ),
              ]
            : null,
        alignment: Alignment.center,
        actionsAlignment: MainAxisAlignment.center,
      ),
    );
  }
}
