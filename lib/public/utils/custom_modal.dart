import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/public/extensions/extension.dart';
import 'package:semesta/src/widgets/sub/direction_y.dart';

class CustomModal<T> {
  final BuildContext _context;
  final bool isHide, isFull;
  final MainAxisSize size;
  final String title, label;
  final VoidCallback? onConfirm;
  final IconData icon;
  final Color? color;
  final List<Widget> children;

  CustomModal(
    this._context, {
    this.isHide = false,
    this.isFull = false,
    this.size = MainAxisSize.min,
    this.children = const [],
    required this.title,
    this.onConfirm,
    this.icon = Icons.delete,
    this.color,
    this.label = 'Yes',
  }) {
    showDialog<T>(
      context: _context,
      fullscreenDialog: isFull,
      barrierDismissible: isHide,
      builder: (context) => AlertDialog(
        title: Text(title, textAlign: TextAlign.center),
        content: SingleChildScrollView(
          child: Form(
            key: GlobalKey<FormState>(),
            child: DirectionY(mainAxisSize: size, children: children),
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => context.pop(),
            icon: Icon(Icons.close, color: context.hintColor),
            label: Text('Cancel', style: TextStyle(color: context.hintColor)),
          ),
          TextButton.icon(
            onPressed: onConfirm,
            icon: Icon(icon, color: color),
            label: Text(label, style: TextStyle(color: color)),
          ),
        ],
        alignment: Alignment.center,
        actionsAlignment: MainAxisAlignment.center,
      ),
    );
  }
}
