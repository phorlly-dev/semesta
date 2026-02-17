import 'package:flutter/material.dart';

class Connector extends CustomPainter {
  final Offset _start;
  final Offset _end;
  final Color _color;
  const Connector(this._start, this._end, this._color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    canvas.drawLine(_start, _end, paint);
  }

  @override
  bool shouldRepaint(covariant Connector old) {
    return _start != old._start || _end != old._end || _color != old._color;
  }
}
