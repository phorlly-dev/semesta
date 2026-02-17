import 'package:flutter/material.dart';
import 'package:semesta/src/widgets/sub/direction_y.dart';

class OccurredError extends StatelessWidget {
  final VoidCallback? onRetry;
  final String? message;
  const OccurredError({super.key, this.onRetry, this.message});

  @override
  Widget build(BuildContext context) {
    return DirectionY(
      spacing: 12,
      alignment: Alignment.center,
      mainAlignment: MainAxisAlignment.center,
      crossAlignment: CrossAxisAlignment.center,
      padding: EdgeInsets.symmetric(horizontal: 12),
      children: [
        Text(
          message ?? 'Something when wrong!',
          style: TextStyle(color: Colors.redAccent),
        ),
        TextButton.icon(onPressed: onRetry, label: Text('Retry')),
      ],
    );
  }
}
