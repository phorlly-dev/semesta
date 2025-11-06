import 'dart:async';
import 'package:semesta/app/utils/logger.dart';

class HandleError {
  final void Function() callback;
  final void Function(Object error, StackTrace stack)? onError;

  HandleError({required this.callback, this.onError}) {
    runZonedGuarded(
      callback,
      onError ??
          (error, stack) {
            HandleLogger(
              '⚠️ Caught error in guarded zone',
              error: error,
              stack: stack,
            );
          },
    );
  }
}
