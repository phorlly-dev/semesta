import 'package:flutter/material.dart';

class BreakSection extends StatelessWidget {
  final double height, bold;
  const BreakSection({super.key, this.height = 16, this.bold = 1.8});

  @override
  Widget build(BuildContext context) {
    return Divider(height: height, thickness: bold);
  }
}
