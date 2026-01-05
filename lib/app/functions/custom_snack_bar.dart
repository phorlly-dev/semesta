import 'package:flutter/material.dart';

enum MessageType { info, error, success }

class CustomSnackBar {
  final BuildContext context;
  final String message;
  final MessageType type;
  final int timer;
  final double textSize;

  CustomSnackBar(
    this.context, {
    required this.message,
    this.type = MessageType.info,
    this.timer = 3,
    this.textSize = 16,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: textSize, fontWeight: FontWeight.bold),
        ),
        backgroundColor: getColor(type),
        duration: Duration(seconds: timer),
      ),
    );
  }

  Color? getColor(MessageType type) {
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
