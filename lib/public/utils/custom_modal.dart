import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    final formKey = GlobalKey<FormState>();
    final col = Theme.of(_context).hintColor;

    showDialog<T>(
      context: _context,
      fullscreenDialog: isFull,
      barrierDismissible: isHide,
      builder: (context) {
        return AlertDialog(
          title: Text(title, textAlign: TextAlign.center),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: size,
                children: children,
              ),
            ),
          ),
          actions: [
            TextButton.icon(
              onPressed: () => context.pop(),
              icon: Icon(Icons.close, color: col),
              label: Text('Cancel', style: TextStyle(color: col)),
            ),
            TextButton.icon(
              onPressed: onConfirm,
              icon: Icon(icon, color: color),
              label: Text(label, style: TextStyle(color: color)),
            ),
          ],
          actionsAlignment: MainAxisAlignment.center,
          alignment: Alignment.center,
        );
      },
    );
  }
}
