import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimatedLoader extends StatelessWidget {
  final double? bold;
  final Color? color;
  final bool cupertino;
  const AnimatedLoader({
    super.key,
    this.bold,
    this.color,
    this.cupertino = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: cupertino
          ? CupertinoActivityIndicator(
              radius: bold ?? 16.0,
              color: color ?? CupertinoColors.activeBlue,
            )
          : CircularProgressIndicator(strokeWidth: bold, color: color),
    );
  }
}
