import 'package:logger/logger.dart';
import 'package:semesta/app/utils/format.dart';

enum LogType { error, warning, track, info, debug }

class HandleLogger {
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
    switch (type) {
      case LogType.error:
        _logger.e(message, error: error, time: syncDate(), stackTrace: stack);
        break;
      case LogType.warning:
        _logger.w(message, error: error, time: syncDate(), stackTrace: stack);
        break;
      case LogType.track:
        _logger.t(message, error: error, time: syncDate(), stackTrace: stack);
        break;
      case LogType.info:
        _logger.i(message, error: error, time: syncDate(), stackTrace: stack);
        break;
      case LogType.debug:
        _logger.d(message, error: error, time: syncDate(), stackTrace: stack);
        break;
    }
  }

  final _logger = Logger(
    printer: PrettyPrinter(dateTimeFormat: DateTimeFormat.dateAndTime),
    level: Level.all,
  );
}
