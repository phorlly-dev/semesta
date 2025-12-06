import 'package:flutter/material.dart';

class ReplyConnector extends StatelessWidget {
  final Widget parent;
  final Widget child;

  const ReplyConnector({super.key, required this.parent, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Draw line between avatars
        Positioned(
          left: 36, // align with avatars
          top: 24, // start below parent avatar
          bottom: 8, // end above current avatar
          child: Container(
            width: 2,
            color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
          ),
        ),

        // Actual content
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [parent, SizedBox(height: 12), child],
        ),
      ],
    );
  }
}
