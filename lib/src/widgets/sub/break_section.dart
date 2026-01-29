import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/extension.dart';

class BreakSection extends StatelessWidget {
  final double height, bold;
  final double opacity;
  final Color? color;
  const BreakSection({
    super.key,
    this.height = 8,
    this.bold = .8,
    this.opacity = .32,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height,
      thickness: bold,
      color: color ?? context.dividerColor.withValues(alpha: opacity),
    );
  }
}
