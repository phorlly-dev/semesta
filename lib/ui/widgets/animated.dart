import 'package:flutter/material.dart';

class Animated extends StatefulWidget {
  final VoidCallback? onTap;
  final Widget? child;
  const Animated({super.key, this.onTap, this.child});

  @override
  State<Animated> createState() => _AnimatedState();
}

class _AnimatedState extends State<Animated> {
  double _opacity = 1.0;
  double _scale = 1.0;

  void _animateTap() async {
    setState(() {
      _opacity = 0.7;
      _scale = 0.92;
    });

    await Future.delayed(const Duration(milliseconds: 120));

    setState(() {
      _opacity = 1.0;
      _scale = 1.0;
    });

    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _animateTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 160),
        opacity: _opacity,
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          child: widget.child,
        ),
      ),
    );
  }
}
