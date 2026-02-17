import 'package:logger/logger.dart';
import 'package:semesta/public/functions/format_helper.dart';

enum HandleStyle { error, warning, track, info, debug }

class HandleLogger {
  final String _message;
  final HandleStyle _style;
  final Object? _error;
  final StackTrace? _stack;

  HandleLogger._(this._message, this._style, this._error, this._stack) {
    final log = Logger(
      printer: PrettyPrinter(
        methodCount: 2, // number of stacktrace lines
        errorMethodCount: 6,
        lineLength: 80,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.dateAndTime,
      ),
      level: Level.all,
    );

    final tag = '[${_style.name.toUpperCase()}]';
    final time = syncDate(); // assuming your custom formatter
    final formattedMsg = '$tag $_message';

    switch (_style) {
      case HandleStyle.error:
        log.e(formattedMsg, error: _error, stackTrace: _stack, time: time);
        break;

      case HandleStyle.warning:
        log.w(formattedMsg, error: _error, stackTrace: _stack, time: time);
        break;

      case HandleStyle.track:
        log.t(formattedMsg, error: _error, stackTrace: _stack, time: time);
        break;

      case HandleStyle.info:
        log.i(formattedMsg, error: _error, stackTrace: _stack, time: time);
        break;

      case HandleStyle.debug:
        log.d(formattedMsg, error: _error, stackTrace: _stack, time: time);
        break;
    }
  }

  // --- Static shortcuts for easy use anywhere ---
  factory HandleLogger.render(
    String message, {
    Object? error,
    StackTrace? stack,
    HandleStyle style = HandleStyle.error,
  }) => switch (style) {
    HandleStyle.error => HandleLogger.error(
      message,
      error: error,
      stack: stack,
    ),
    HandleStyle.warning => HandleLogger.warning(
      message,
      error: error,
      stack: stack,
    ),
    HandleStyle.track => HandleLogger.track(
      message,
      error: error,
      stack: stack,
    ),
    HandleStyle.info => HandleLogger.info(message, error: error, stack: stack),
    HandleStyle.debug => HandleLogger.debug(
      message,
      error: error,
      stack: stack,
    ),
  };

  factory HandleLogger.error(
    String message, {
    Object? error,
    StackTrace? stack,
  }) => HandleLogger._(message, HandleStyle.error, error, stack);

  factory HandleLogger.info(
    String message, {
    Object? error,
    StackTrace? stack,
  }) => HandleLogger._(message, HandleStyle.info, error, stack);

  factory HandleLogger.warning(
    String message, {
    Object? error,
    StackTrace? stack,
  }) => HandleLogger._(message, HandleStyle.warning, error, stack);

  factory HandleLogger.track(
    String message, {
    Object? error,
    StackTrace? stack,
  }) => HandleLogger._(message, HandleStyle.track, error, stack);

  factory HandleLogger.debug(
    String message, {
    Object? error,
    StackTrace? stack,
  }) => HandleLogger._(message, HandleStyle.debug, error, stack);
}
