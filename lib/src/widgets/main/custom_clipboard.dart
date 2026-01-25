import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:semesta/public/functions/logger.dart';
import 'package:semesta/public/functions/custom_snack_bar.dart';

class CustomClipboard extends StatelessWidget {
  final String _data;
  final String? message;
  const CustomClipboard(this._data, {super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (_data.isNotEmpty) {
          await Clipboard.setData(ClipboardData(text: _data));

          if (!context.mounted) return;
          CustomSnackBar(
            context,
            message: 'Copied $message to clipboard',
            type: MessageType.success,
          );

          HandleLogger.info('Copied $message to clipboard', message: _data);
        }
      },
      child: Row(
        spacing: 8,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_data),
          Icon(Icons.copy, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}
