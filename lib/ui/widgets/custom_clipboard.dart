import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:semesta/app/functions/logger.dart';
import 'package:semesta/app/functions/custom_snack_bar.dart';

class CustomClipboard extends StatelessWidget {
  final String data;
  final String? message;
  const CustomClipboard({super.key, required this.data, this.message});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (data.isNotEmpty) {
          await Clipboard.setData(ClipboardData(text: data));
          if (!context.mounted) return;
          CustomSnackBar(
            context,
            message: 'Copied $message to clipboard',
            type: MessageType.success,
          );

          HandleLogger.info('Copied $message to clipboard', message: data);
        }
      },
      child: Row(
        spacing: 8,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(data),
          Icon(Icons.copy, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}
