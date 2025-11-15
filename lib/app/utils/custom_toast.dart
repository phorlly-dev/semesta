import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

enum ToastType { success, info, warning, error }

class CustomToast {
  static void _show({
    required String message,
    String? title,
    ToastType type = ToastType.success,
    int autoCloseSeconds = 3,
  }) {
    // Map ToastType to toastification’s type
    final toastType = {
      ToastType.success: ToastificationType.success,
      ToastType.info: ToastificationType.info,
      ToastType.warning: ToastificationType.warning,
      ToastType.error: ToastificationType.error,
    }[type]!;

    final defaultTitle = {
      ToastType.success: 'Success',
      ToastType.info: 'Info',
      ToastType.warning: 'Warning',
      ToastType.error: 'Error',
    }[type]!;

    toastification.show(
      title: Center(
        child: Column(
          children: [
            Text(
              title ?? defaultTitle,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(message, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
      type: toastType,
      style: ToastificationStyle.fillColored,
      alignment: Alignment.topCenter,
      autoCloseDuration: Duration(seconds: autoCloseSeconds),
      showProgressBar: true,
      showIcon: true,
    );
  }

  // Convenience shortcuts
  static void success(String msg, {String? title, int duration = 3}) => _show(
    message: msg,
    title: title,
    type: ToastType.success,
    autoCloseSeconds: duration,
  );

  static void info(String msg, {String? title, int duration = 4}) => _show(
    message: msg,
    title: title,
    type: ToastType.info,
    autoCloseSeconds: duration,
  );

  static void warning(String msg, {String? title, int duration = 4}) => _show(
    message: msg,
    title: title,
    type: ToastType.warning,
    autoCloseSeconds: duration,
  );

  static void error(String msg, {String? title, int duration = 6}) => _show(
    message: msg,
    title: title,
    type: ToastType.error,
    autoCloseSeconds: duration,
  );
}
