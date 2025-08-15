// ===============================================
// lib/src/core/host_communication.dart
// ===============================================

import 'package:flutter/foundation.dart';

/// Communication service between module and host app
class HostCommunicationService {
  static void Function(String, Map<String, dynamic>)? _eventHandler;
  static bool _isInitialized = false;
  static String? _moduleId;

  /// Initialize the communication service
  static void initialize({required String moduleId, void Function(String, Map<String, dynamic>)? onEvent}) {
    _moduleId = moduleId;
    _eventHandler = onEvent;
    _isInitialized = true;

    if (kDebugMode) {
      print('🔌 HostCommunicationService initialized for module: $moduleId');
    }
  }

  /// Send event to host application
  static void sendEvent(String eventType, [Map<String, dynamic>? data]) {
    if (!_isInitialized || _eventHandler == null) {
      if (kDebugMode) {
        print('⚠️ HostCommunicationService not initialized');
      }
      return;
    }

    final eventData = {'moduleId': _moduleId, 'timestamp': DateTime.now().toIso8601String(), ...?data};

    if (kDebugMode) {
      print('📤 Sending event: $eventType from $_moduleId');
    }

    _eventHandler!(eventType, eventData);
  }

  /// Predefined event methods
  static void requestNavigation(String route, [Map<String, dynamic>? params]) {
    sendEvent(ModuleEventType.navigationRequest, {'route': route, 'params': params ?? {}});
  }

  static void requestClose([String? reason]) {
    sendEvent(ModuleEventType.closeRequest, {'reason': reason ?? 'user_action'});
  }

  static void requestLogout([String? reason]) {
    sendEvent(ModuleEventType.logoutRequest, {'reason': reason ?? 'user_action'});
  }

  static void reportError(String error, [String? context, StackTrace? stackTrace]) {
    sendEvent(ModuleEventType.errorReport, {'error': error, 'context': context, 'stackTrace': stackTrace?.toString()});
  }

  static void requestData(String dataType, [Map<String, dynamic>? params]) {
    sendEvent(ModuleEventType.dataRequest, {'dataType': dataType, 'params': params ?? {}});
  }

  static void notifyStateChange(Map<String, dynamic> state) {
    sendEvent(ModuleEventType.stateChanged, state);
  }

  static void sendCustomEvent(String eventType, Map<String, dynamic> data) {
    sendEvent(eventType, data);
  }

  /// Cleanup
  static void dispose() {
    _eventHandler = null;
    _isInitialized = false;
    _moduleId = null;
  }
}

/// Predefined event types
class ModuleEventType {
  static const String navigationRequest = 'navigation.request';
  static const String closeRequest = 'module.close_request';
  static const String logoutRequest = 'auth.logout_request';
  static const String errorReport = 'error.report';
  static const String dataRequest = 'data.request';
  static const String stateChanged = 'state.changed';
  static const String ready = 'module.ready';
  static const String disposed = 'module.disposed';
}
