import 'package:flutter/material.dart';

class BreakSection extends StatelessWidget {
  final double height, bold;
  final double opacity;
  const BreakSection({
    super.key,
    this.height = 8,
    this.bold = .8,
    this.opacity = .32,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height,
      thickness: bold,
      color: Theme.of(context).dividerColor.withValues(alpha: opacity),
    );
  }
}
