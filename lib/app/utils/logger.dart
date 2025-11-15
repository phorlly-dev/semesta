import 'package:logger/logger.dart';
import 'package:semesta/app/utils/format.dart';

enum LogType { error, warning, track, info, debug }

class HandleLogger {
  Logger get _logger => Logger(
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

  final String message;
  final LogType type;
  final Object? error;
  final StackTrace? stack;

  HandleLogger(
    this.message, {
    this.type = LogType.error,
    this.error,
    this.stack,
  }) {
    _log();
  }

  void _log() {
    final tag = '[${type.name.toUpperCase()}]';
    final time = syncDate(); // assuming your custom formatter
    final formattedMsg = '$tag [$time] $message';

    switch (type) {
      case LogType.error:
        _logger.e(formattedMsg, error: error, stackTrace: stack);
        break;
      case LogType.warning:
        _logger.w(formattedMsg, error: error, stackTrace: stack);
        break;
      case LogType.track:
        _logger.t(formattedMsg, error: error, stackTrace: stack);
        break;
      case LogType.info:
        _logger.i(formattedMsg, error: error, stackTrace: stack);
        break;
      case LogType.debug:
        _logger.d(formattedMsg, error: error, stackTrace: stack);
        break;
    }
  }

  // --- Static shortcuts for easy use anywhere ---
  static void err(String message, {Object? error, StackTrace? stack}) =>
      HandleLogger(message, type: LogType.error, error: error, stack: stack);

  static void warn(String message, {Object? error, StackTrace? stack}) =>
      HandleLogger(message, type: LogType.warning, error: error, stack: stack);

  static void info(String message, {Object? error, StackTrace? stack}) =>
      HandleLogger(message, type: LogType.info, error: error, stack: stack);

  static void debug(String message, {Object? error, StackTrace? stack}) =>
      HandleLogger(message, type: LogType.debug, error: error, stack: stack);

  static void track(String message, {Object? error, StackTrace? stack}) =>
      HandleLogger(message, type: LogType.track, error: error, stack: stack);
}
