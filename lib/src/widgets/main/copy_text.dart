import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:semesta/public/functions/logger.dart';
import 'package:semesta/public/functions/custom_snack_bar.dart';
import 'package:semesta/src/widgets/sub/direction_x.dart';

class CopyText extends StatelessWidget {
  final String _data;
  final String? message;
  const CopyText(this._data, {super.key, this.message});

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
      child: DirectionX(
        spacing: 8,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(_data),
          Icon(Icons.copy, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}
