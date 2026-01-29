import 'package:flutter/material.dart';

class CommentConnector extends CustomPainter {
  final Offset startPoint;
  final Offset endPoint;
  final Color lineColor;
  const CommentConnector({
    required this.startPoint,
    required this.endPoint,
    required this.lineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    canvas.drawLine(startPoint, endPoint, paint);
  }

  @override
  bool shouldRepaint(covariant CommentConnector old) {
    return startPoint != old.startPoint ||
        endPoint != old.endPoint ||
        lineColor != old.lineColor;
  }
}
