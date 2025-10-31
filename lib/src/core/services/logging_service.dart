import 'package:logger/logger.dart';

/// Service for logging with environment-aware log levels.
class LoggingService {
  /// Creates a logging service.
  LoggingService({Level? level})
      : _logger = Logger(level: level ?? _getLogLevel());

  final Logger _logger;

  /// Gets the appropriate log level based on the environment.
  static Level _getLogLevel() {
    // In debug mode, show all logs
    // In release mode, only show warnings and errors
    const isDebugMode = !bool.fromEnvironment('dart.vm.product');
    return isDebugMode ? Level.debug : Level.warning;
  }

  /// Logs a debug message.
  void debug(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Logs an info message.
  void info(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Logs a warning message.
  void warning(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Logs an error message.
  void error(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Logs a fatal error message.
  void fatal(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }
}
