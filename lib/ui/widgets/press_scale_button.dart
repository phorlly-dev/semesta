import 'package:flutter/material.dart';

class PressScaleButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color color;

  const PressScaleButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.color = Colors.deepPurple,
  });

  @override
  State<PressScaleButton> createState() => _PressScaleButtonState();
}

class _PressScaleButtonState extends State<PressScaleButton> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails _) {
    setState(() => _scale = 0.95); // Slight shrink on tap
  }

  void _onTapUp(TapUpDetails _) {
    setState(() => _scale = 1.0);
    widget.onPressed();
  }

  void _onTapCancel() {
    setState(() => _scale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: Container(
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
