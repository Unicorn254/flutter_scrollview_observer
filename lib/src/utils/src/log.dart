import 'dart:developer' as developer;

class Log {
  Log._();

  static void info(String msg) {
    _log('\x1B[34m$msg\x1B[0m');
  }

  static void success(String msg) {
    _log('\x1B[32m$msg\x1B[0m');
  }

  static void warning(String msg) {
    _log('\x1B[33m$msg\x1B[0m');
  }

  static void error(String msg) {
    _log('\x1B[31m$msg\x1B[0m');
  }

  static void _log(String message) {
    developer.log(message, name: 'scrollview_observer');
  }
}
