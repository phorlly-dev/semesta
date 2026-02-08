import 'package:flutter/material.dart';

class Animated extends StatefulWidget {
  final VoidCallback? onTap, onLongPress;
  final Widget child;
  const Animated({
    super.key,
    this.onTap,
    required this.child,
    this.onLongPress,
  });

  @override
  State<Animated> createState() => _AnimatedState();
}

class _AnimatedState extends State<Animated> {
  double _opacity = 1.0;
  double _scale = 1.0;

  void _animateTap() async {
    setState(() {
      _opacity = .6;
      _scale = .96;
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
      onTap: widget.onTap != null ? _animateTap : null,
      onLongPress: widget.onLongPress,
      behavior: HitTestBehavior.translucent,
      child: AnimatedOpacity(
        duration: Durations.short4,
        opacity: _opacity,
        child: AnimatedScale(
          scale: _scale,
          duration: Durations.short4,
          curve: Curves.easeOut,
          child: widget.child,
        ),
      ),
    );
  }
}
