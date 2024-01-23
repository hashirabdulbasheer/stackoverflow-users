import 'package:logger/logger.dart';

class SOFLogger {
  static final _logger = Logger();

  static void d(String message) {
    _logger.d(message);
  }

  static void e(Object error) {
    _logger.e(error);
  }
}
