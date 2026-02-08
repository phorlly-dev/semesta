import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

enum ToastType { success, info, warning, error }

class CustomToast {
  final String _message;
  final String? _title;
  final ToastType _type;
  final int _autoClose;

  CustomToast._(this._message, this._title, this._type, this._autoClose) {
    // Map ToastType to toastification’s type
    final toastType = {
      ToastType.success: ToastificationType.success,
      ToastType.info: ToastificationType.info,
      ToastType.warning: ToastificationType.warning,
      ToastType.error: ToastificationType.error,
    }[_type]!;

    final defaultTitle = {
      ToastType.success: 'Success',
      ToastType.info: 'Info',
      ToastType.warning: 'Warning',
      ToastType.error: 'Error',
    }[_type]!;

    toastification.show(
      title: Center(
        child: Text(
          _title ?? defaultTitle,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      description: Center(
        child: Text(
          _message,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      showIcon: true,
      type: toastType,
      showProgressBar: true,
      alignment: Alignment.topCenter,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: Duration(seconds: _autoClose),
    );
  }

  factory CustomToast.render(
    String message, {
    String? title,
    int autoClose = 2,
    ToastType type = ToastType.success,
  }) => switch (type) {
    ToastType.success => CustomToast.success(
      message,
      title: title,
      autoClose: autoClose,
    ),
    ToastType.info => CustomToast.info(
      message,
      title: title,
      autoClose: autoClose,
    ),
    ToastType.warning => CustomToast.warning(
      message,
      title: title,
      autoClose: autoClose,
    ),
    ToastType.error => CustomToast.error(
      message,
      title: title,
      autoClose: autoClose,
    ),
  };

  factory CustomToast.success(
    String message, {
    String? title,
    int autoClose = 2,
  }) => CustomToast._(message, title, ToastType.success, autoClose);

  factory CustomToast.info(
    String message, {
    String? title,
    int autoClose = 2,
  }) => CustomToast._(message, title, ToastType.info, autoClose);

  factory CustomToast.warning(
    String message, {
    String? title,
    int autoClose = 2,
  }) => CustomToast._(message, title, ToastType.warning, autoClose);

  factory CustomToast.error(
    String message, {
    String? title,
    int autoClose = 3,
  }) => CustomToast._(message, title, ToastType.error, autoClose);
}
