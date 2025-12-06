import 'package:flutter/material.dart';

class LayoutCard extends StatelessWidget {
  final Widget header;
  final Widget? content, top, footer;
  final bool isCompact;

  const LayoutCard({
    super.key,
    required this.header,
    this.content,
    this.top,
    this.footer,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        vertical: isCompact ? 4 : 8,
        horizontal: isCompact ? 6 : 12,
      ),
      elevation: isCompact ? 0.2 : 1,
      child: Column(
        spacing: 3.2,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ?top,
          header,
          ?content,
          if (footer != null) ...[
            const Divider(),
            footer!,
            SizedBox(height: 6),
          ],
        ],
      ),
    );
  }
}
