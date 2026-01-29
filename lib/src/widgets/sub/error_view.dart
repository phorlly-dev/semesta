import 'package:flutter/material.dart';
import 'package:semesta/src/widgets/sub/direction_y.dart';

class ErrorView extends StatelessWidget {
  final VoidCallback? onRetry;
  final String? message;
  const ErrorView({super.key, this.onRetry, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DirectionY(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            message ?? 'Something when wrong!',
            style: TextStyle(color: Colors.redAccent),
          ),
          TextButton.icon(onPressed: onRetry, label: Text('Retry')),
        ],
      ),
    );
  }
}
