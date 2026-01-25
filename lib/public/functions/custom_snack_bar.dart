import 'package:flutter/material.dart';

enum MessageType { info, error, success }

class CustomSnackBar {
  final BuildContext _context;
  final String message;
  final MessageType type;
  final int timer;
  final double textSize;

  CustomSnackBar(
    this._context, {
    required this.message,
    this.type = MessageType.info,
    this.timer = 3,
    this.textSize = 16,
  }) {
    ScaffoldMessenger.of(_context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: textSize, fontWeight: FontWeight.bold),
        ),
        backgroundColor: _getColor(type),
        duration: Duration(seconds: timer),
      ),
    );
  }

  Color? _getColor(MessageType type) {
    var color = Colors.blueAccent[400];
    switch (type) {
      case MessageType.success:
        color = Colors.lightGreen[800];
        break;
      case MessageType.error:
        color = Colors.redAccent[400];
        break;
      default:
        color;
    }

    return color;
  }
}
