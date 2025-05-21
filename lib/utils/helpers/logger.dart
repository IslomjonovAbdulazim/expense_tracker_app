// lib/utils/helpers/logger.dart
import 'package:flutter/foundation.dart';

/// A simple logger utility class that only logs in debug mode.
enum LogType { info, debug, warning, error, success }

///
class Logger {
  /// Enum for log types

  static const String _resetColor = '\x1B[0m';
  static const String _infoColor = '\x1B[36m'; // Cyan
  static const String _debugColor = '\x1B[34m'; // Blue
  static const String _warningColor = '\x1B[33m'; // Yellow
  static const String _errorColor = '\x1B[31m'; // Red
  static const String _successColor = '\x1B[32m'; // Green

  /// Log a regular info message
  static void log(String message) {
    _printLog(LogType.info, message);
  }

  /// Log a debug message
  static void debug(String message) {
    _printLog(LogType.debug, message);
  }

  /// Log a warning message
  static void warning(String message) {
    _printLog(LogType.warning, message);
  }

  /// Log an error message
  static void error(String message) {
    _printLog(LogType.error, message);
  }

  /// Log a success message
  static void success(String message) {
    _printLog(LogType.success, message);
  }

  /// Private method to handle actual printing with formatting
  static void _printLog(LogType type, String message) {
    if (!kDebugMode) return; // Only log in debug mode

    final DateTime now = DateTime.now();
    final String time =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";

    String color;
    String prefix;

    switch (type) {
      case LogType.info:
        color = _infoColor;
        prefix = 'INFO';
        break;
      case LogType.debug:
        color = _debugColor;
        prefix = 'DEBUG';
        break;
      case LogType.warning:
        color = _warningColor;
        prefix = 'WARNING';
        break;
      case LogType.error:
        color = _errorColor;
        prefix = 'ERROR';
        break;
      case LogType.success:
        color = _successColor;
        prefix = 'SUCCESS';
        break;
    }

    debugPrint('$color[$time] [$prefix] $message$_resetColor');
  }
}
