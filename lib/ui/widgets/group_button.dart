import 'package:flutter/material.dart';

class GroupButton extends StatelessWidget {
  final List<Widget>? actions;
  final VoidCallback? onView, onClose;
  const GroupButton({super.key, this.actions, this.onView, this.onClose});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onView,
          icon: Icon(Icons.more_horiz),
          iconSize: 26,
        ),
        IconButton(
          onPressed: onClose,
          icon: Icon(Icons.close_rounded),
          iconSize: 28,
        ),
        ...?actions,
      ],
    );
  }
}
