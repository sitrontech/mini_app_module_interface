// ===============================================
// lib/src/utils/module_logger.dart
// ===============================================

import 'package:flutter/foundation.dart';

/// Logger utility for modules
class MiniAppModuleLogger {
  static bool _enableLogging = kDebugMode;
  static String? _moduleId;

  static void initialize(String moduleId, {bool? enableLogging}) {
    _moduleId = moduleId;
    _enableLogging = enableLogging ?? kDebugMode;
  }

  static void debug(String message) {
    if (_enableLogging) {
      debugPrint('🐛 [$_moduleId] $message');
    }
  }

  static void info(String message) {
    if (_enableLogging) {
      debugPrint('ℹ️ [$_moduleId] $message');
    }
  }

  static void warning(String message) {
    if (_enableLogging) {
      debugPrint('⚠️ [$_moduleId] $message');
    }
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    if (_enableLogging) {
      debugPrint('❌ [$_moduleId] $message');
      if (error != null) debugPrint('Error: $error');
      if (stackTrace != null) debugPrint('Stack: $stackTrace');
    }
  }
}
