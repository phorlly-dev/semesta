import 'package:flutter/material.dart';

class CommentConnector extends CustomPainter {
  final Offset startPoint;
  final Offset endPoint;
  final Color lineColor;

  CommentConnector({
    required this.startPoint,
    required this.endPoint,
    required this.lineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(startPoint.dx, startPoint.dy);

    // Create a smooth curve between the points
    // Adjust control points for the desired "elbow" curvature
    final controlPoint1 = Offset(startPoint.dx, endPoint.dy);

    path.quadraticBezierTo(
      controlPoint1.dx,
      controlPoint1.dy,
      endPoint.dx,
      endPoint.dy,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
