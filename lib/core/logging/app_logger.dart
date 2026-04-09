import 'dart:developer' as dev;

class AppLogger {
  const AppLogger();

  void i(String message, {String tag = 'app'}) {
    dev.log(message, name: tag);
  }

  void w(String message, {String tag = 'app', Object? error, StackTrace? st}) {
    dev.log(message, name: tag, level: 900, error: error, stackTrace: st);
  }

  void e(String message, {String tag = 'app', Object? error, StackTrace? st}) {
    dev.log(message, name: tag, level: 1000, error: error, stackTrace: st);
  }
}

