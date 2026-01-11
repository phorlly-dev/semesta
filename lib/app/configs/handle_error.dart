import 'dart:async';
import 'dart:ui';
import 'package:semesta/app/functions/logger.dart';
import 'package:semesta/app/utils/type_def.dart';

class HandleError {
  final VoidCallback callback;
  final ErrorsCallback<void>? onError;

  HandleError({required this.callback, this.onError}) {
    runZonedGuarded(
      callback,
      onError ??
          (error, stack) {
            HandleLogger.debug(
              '⚠️ Caught error in guarded zone',
              message: error,
              stack: stack,
            );
          },
    );
  }
}
