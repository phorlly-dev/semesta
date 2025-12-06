import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  final double? bold;
  final Color? color;
  const Loader({super.key, this.bold, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(strokeWidth: bold, color: color),
    );
  }
}
