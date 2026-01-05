import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final VoidCallback? onRetry;
  final String? message;
  const ErrorView({super.key, this.onRetry, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        spacing: 12,
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
