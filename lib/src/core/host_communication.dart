// ===============================================
// lib/src/core/host_communication.dart
// A static service that facilitates event-based communication between the module and the host application.
// It acts as the central nervous system for inter-app communication
// ===============================================

import 'package:flutter/foundation.dart';

/// Communication service between module and host app
class HostCommunicationService {
  static void Function(String, Map<String, dynamic>)? _eventHandler;
  static bool _isInitialized = false;
  static String? _moduleId;

  /// Initialize the communication service
  /// ในเมธอด onModuleInit() ของ MiniAppModuleBase จะมีการเรียกใช้ HostCommunicationService.initialize()
  /// โดยส่ง moduleId และ onHostEvent callback เข้าไป นี่เป็นการเชื่อมต่อระหว่างโมดูลกับแอปพลิเคชันหลัก
  static void initialize({required String moduleId, void Function(String, Map<String, dynamic>)? onEvent}) {
    _moduleId = moduleId;
    _eventHandler = onEvent;
    _isInitialized = true;

    if (kDebugMode) {
      print('🔌 HostCommunicationService initialized for module: $moduleId');
    }
  }

  /// Send communication to host application
  /// ใช้เมธอดนี้เพื่อส่งข้อมูลไปยังแอปพลิเคชันหลัก โดยข้อมูลจะถูกห่อหุ้มด้วย moduleId และ timestamp
  static void sendEvent(String communicationType, [Map<String, dynamic>? data]) {
    if (!_isInitialized || _eventHandler == null) {
      if (kDebugMode) {
        print('⚠️ HostCommunicationService not initialized');
      }
      return;
    }

    final communicationData = {'moduleId': _moduleId, 'timestamp': DateTime.now().toIso8601String(), ...?data};

    if (kDebugMode) {
      print('📤 Sending event: $communicationType from $_moduleId');
    }

    _eventHandler!(communicationType, communicationData);
  }

  /// Predefined communication methods
  /// ขอให้แอปพลิเคชันหลักนำทางไปยังหน้าจออื่น
  static void requestNavigation(String route, [Map<String, dynamic>? params]) {
    sendEvent(CommunicationType.navigationRequest, {'route': route, 'params': params ?? {}});
  }

  /// ขอปิดโมดูล
  static void requestClose([String? reason]) {
    sendEvent(CommunicationType.closeRequest, {'reason': reason ?? 'user_action'});
  }

  static void requestLogout([String? reason]) {
    sendEvent(CommunicationType.logoutRequest, {'reason': reason ?? 'user_action'});
  }

  /// รายงานข้อผิดพลาดที่เกิดขึ้นในโมดูล
  static void reportError(String error, [String? context, StackTrace? stackTrace]) {
    sendEvent(CommunicationType.errorReport, {
      'error': error,
      'context': context,
      'stackTrace': stackTrace?.toString(),
    });
  }

  /// ขอข้อมูลจากแอปพลิเคชันหลัก
  static void requestData(String dataType, [Map<String, dynamic>? params]) {
    sendEvent(CommunicationType.dataRequest, {'dataType': dataType, 'params': params ?? {}});
  }

  /// แจ้งสถานะที่เปลี่ยนแปลงไปของโมดูล
  static void notifyStateChange(Map<String, dynamic> state) {
    sendEvent(CommunicationType.stateChanged, state);
  }

  /// ส่งเหตุการณ์ที่กำหนดเอง ซึ่งแอปพลิเคชันหลักต้องจัดการเอง
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

// คลาสที่ทำหน้าที่เป็น บริการสื่อสาร ระหว่างโมดูล (mini-app) กับแอปพลิเคชันหลัก (host app) โดยเฉพาะ
// มันเป็นกลไกสำคัญที่ทำให้โมดูลสามารถ ส่งเหตุการณ์ (event) และ คำขอ (request) ต่างๆ ไปยังแอปพลิเคชันหลักได้

/// Communication types
class CommunicationType {
  static const String navigationRequest = 'navigation.request';
  static const String closeRequest = 'module.close_request';
  static const String logoutRequest = 'auth.logout_request';
  static const String errorReport = 'error.report';
  static const String dataRequest = 'data.request';
  static const String stateChanged = 'state.changed';
  static const String ready = 'module.ready';
  static const String disposed = 'module.disposed';
}
