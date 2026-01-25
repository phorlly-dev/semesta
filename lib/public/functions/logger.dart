import 'package:logger/logger.dart';
import 'package:semesta/public/functions/format_helper.dart';

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
  final Object? err;
  final StackTrace? stack;

  HandleLogger(
    this.message, {
    this.type = LogType.error,
    this.err,
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
        _logger.e(formattedMsg, error: err, stackTrace: stack);
        break;
      case LogType.warning:
        _logger.w(formattedMsg, error: err, stackTrace: stack);
        break;
      case LogType.track:
        _logger.t(formattedMsg, error: err, stackTrace: stack);
        break;
      case LogType.info:
        _logger.i(formattedMsg, error: err, stackTrace: stack);
        break;
      case LogType.debug:
        _logger.d(formattedMsg, error: err, stackTrace: stack);
        break;
    }
  }

  // --- Static shortcuts for easy use anywhere ---
  static void error(String title, {Object? message, StackTrace? stack}) =>
      HandleLogger(title, type: LogType.error, err: message, stack: stack);

  static void warn(String title, {Object? message, StackTrace? stack}) =>
      HandleLogger(title, type: LogType.warning, err: message, stack: stack);

  static void info(String title, {Object? message, StackTrace? stack}) =>
      HandleLogger(title, type: LogType.info, err: message, stack: stack);

  static void debug(String title, {Object? message, StackTrace? stack}) =>
      HandleLogger(title, type: LogType.debug, err: message, stack: stack);

  static void track(String title, {Object? message, StackTrace? stack}) =>
      HandleLogger(title, type: LogType.track, err: message, stack: stack);
}
