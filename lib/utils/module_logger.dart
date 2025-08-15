// ===============================================
// lib/src/utils/module_logger.dart
// ===============================================

import 'package:flutter/foundation.dart';

/// Logger utility for modules
class ModuleLogger {
  static bool _enableLogging = kDebugMode;
  static String? _moduleId;

  static void initialize(String moduleId, {bool? enableLogging}) {
    _moduleId = moduleId;
    _enableLogging = enableLogging ?? kDebugMode;
  }

  static void debug(String message) {
    if (_enableLogging) {
      print('🐛 [$_moduleId] $message');
    }
  }

  static void info(String message) {
    if (_enableLogging) {
      print('ℹ️ [$_moduleId] $message');
    }
  }

  static void warning(String message) {
    if (_enableLogging) {
      print('⚠️ [$_moduleId] $message');
    }
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    if (_enableLogging) {
      print('❌ [$_moduleId] $message');
      if (error != null) print('Error: $error');
      if (stackTrace != null) print('Stack: $stackTrace');
    }
  }
}
