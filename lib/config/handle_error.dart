import 'dart:async';
import 'dart:ui';
import 'package:semesta/public/functions/logger.dart';
import 'package:semesta/public/utils/type_def.dart';

class HandleError {
  final VoidCallback callback;
  final FnP2<Object, StackTrace, void>? onError;
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
