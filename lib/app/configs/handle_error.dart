import 'dart:async';
import 'package:semesta/app/functions/logger.dart';

class HandleError {
  final void Function() callback;
  final void Function(Object error, StackTrace stack)? onError;

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
