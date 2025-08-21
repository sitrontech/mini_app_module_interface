// ===============================================
// lib/src/core/host_communication.dart
// A static service that facilitates event-based communication between the module and the host application.
// It acts as the central nervous system for inter-app communication
// ===============================================
//
// ไฟล์นี้เป็น Service Class ที่ทำหน้าที่เป็น "ระบบประสาทกลาง" สำหรับการสื่อสาร
// ระหว่าง Mini App Module กับ Host Application
// ใช้ Pattern: Event-driven Communication และ Static Service
// ทำให้ module สามารถส่ง event, request และข้อมูลต่างๆ ไปยัง host ได้

import 'package:flutter/foundation.dart';

/// Communication service ระหว่าง module และ host app
///
/// คลาสนี้เป็น Static Service (Singleton Pattern) ที่ทำหน้าที่:
/// 1. จัดการการเชื่อมต่อระหว่าง module กับ host
/// 2. ส่ง events และ requests จาก module ไปยัง host
/// 3. จัดการ lifecycle ของการสื่อสาร
///
/// การออกแบบเป็น static class ทำให้เข้าถึงได้จากทุกที่ใน module
/// โดยไม่ต้องส่ง instance ไปมา
class HostCommunicationService {
  // ============================================
  // Private Static Variables (State Management)
  // ============================================

  /// Event handler callback function
  ///
  /// เป็น function ที่ host app ส่งมาให้ module
  /// เพื่อใช้ในการรับ events ที่ module ส่งไป
  ///
  /// Parameters:
  /// - String: ประเภทของ event (event type)
  /// - Map<String, dynamic>: ข้อมูลที่ส่งไปพร้อมกับ event
  ///
  /// ถ้าเป็น null แสดงว่า module ทำงานใน standalone mode
  static void Function(String, Map<String, dynamic>)? _eventHandler;

  /// Flag สำหรับตรวจสอบว่า service ถูก initialize แล้วหรือยัง
  ///
  /// ป้องกันการใช้งาน service ก่อนที่จะ initialize
  /// และป้องกันการ initialize ซ้ำ
  static bool _isInitialized = false;

  /// Module ID ที่กำลังใช้ service นี้
  ///
  /// ใช้สำหรับ:
  /// - ระบุตัวตนของ module ใน events
  /// - Debugging และ logging
  /// - การจัดการ routing
  static String? _moduleId;

  // ============================================
  // Initialization & Disposal
  // ============================================

  /// Initialize communication service
  ///
  /// เมธอดนี้จะถูกเรียกโดย MiniAppModuleBase ใน onModuleInit()
  /// เพื่อเชื่อมต่อ module เข้ากับ host application
  ///
  /// การทำงาน:
  /// 1. เก็บ moduleId สำหรับใช้อ้างอิง
  /// 2. เก็บ event handler callback จาก host
  /// 3. ตั้ง flag ว่า initialized แล้ว
  /// 4. Log การเชื่อมต่อ (ใน debug mode)
  ///
  /// Parameters:
  /// - [moduleId]: ID ของ module ที่จะใช้ในการสื่อสาร
  /// - [onEvent]: Callback function จาก host สำหรับรับ events
  ///
  /// ตัวอย่างการเรียกใช้ (จาก MiniAppModuleBase):
  /// ```dart
  /// HostCommunicationService.initialize(
  ///   moduleId: widget.config.moduleId,
  ///   onEvent: widget.onHostEvent
  /// );
  /// ```
  static void initialize({required String moduleId, void Function(String, Map<String, dynamic>)? onEvent}) {
    // เก็บค่าที่จำเป็นสำหรับการสื่อสาร
    _moduleId = moduleId;
    _eventHandler = onEvent;
    _isInitialized = true;

    // Debug logging - แสดงเฉพาะใน debug mode
    // ใช้ emoji 🔌 เพื่อให้หา log ได้ง่าย
    if (kDebugMode) {
      print('🔌 HostCommunicationService initialized for module: $moduleId');
    }
  }

  // ============================================
  // Core Communication Method
  // ============================================

  /// ส่ง event/communication ไปยัง host application
  ///
  /// เป็น core method ที่ methods อื่นๆ ใช้ในการส่งข้อมูล
  /// จะเพิ่ม metadata (moduleId, timestamp) ให้กับทุก event อัตโนมัติ
  ///
  /// การทำงาน:
  /// 1. ตรวจสอบว่า service initialized แล้ว
  /// 2. สร้าง event data พร้อม metadata
  /// 3. Log event (ใน debug mode)
  /// 4. เรียก event handler callback
  ///
  /// Parameters:
  /// - [communicationType]: ประเภทของการสื่อสาร (ดูที่ CommunicationType class)
  /// - [data]: ข้อมูลเพิ่มเติมที่ต้องการส่ง (optional)
  ///
  /// Data structure ที่ส่งไป:
  /// ```dart
  /// {
  ///   'moduleId': 'payment_module',
  ///   'timestamp': '2024-01-15T10:30:00.000Z',
  ///   ...additionalData
  /// }
  /// ```
  static void sendEvent(String communicationType, [Map<String, dynamic>? data]) {
    // ตรวจสอบว่า service พร้อมใช้งาน
    if (!_isInitialized || _eventHandler == null) {
      // Log คำเตือนใน debug mode
      if (kDebugMode) {
        print('⚠️ HostCommunicationService not initialized');
      }
      return; // ออกจาก method ถ้ายังไม่พร้อม
    }

    // สร้าง event data พร้อม metadata
    // ใช้ spread operator ...? เพื่อรวม data (ถ้ามี)
    final communicationData = {
      'moduleId': _moduleId, // ระบุว่า event มาจาก module ไหน
      'timestamp': DateTime.now().toIso8601String(), // เวลาที่ส่ง event
      ...?data, // ข้อมูลเพิ่มเติม (ถ้ามี)
    };

    // Debug logging - แสดง event ที่กำลังส่ง
    if (kDebugMode) {
      print('📤 Sending event: $communicationType from $_moduleId');
    }

    // เรียก event handler callback ที่ host ส่งมาให้
    // ใช้ ! เพราะเช็คแล้วว่าไม่ null
    _eventHandler!(communicationType, communicationData);
  }

  // ============================================
  // Predefined Communication Methods
  // ============================================
  // เมธอดสำเร็จรูปสำหรับการสื่อสารแบบต่างๆ
  // ทำให้ใช้งานง่าย และมีมาตรฐานเดียวกันทั้งระบบ

  /// ขอให้ host นำทางไปยังหน้าจออื่น
  ///
  /// ใช้เมื่อ module ต้องการให้ host เปลี่ยนหน้า
  /// เช่น กลับไป home, ไปหน้า settings, หรือไป module อื่น
  ///
  /// Parameters:
  /// - [route]: path ของหน้าที่ต้องการไป
  /// - [params]: parameters ที่ต้องการส่งไปด้วย (optional)
  ///
  /// ตัวอย่างการใช้:
  /// ```dart
  /// // ไปหน้า profile พร้อม userId
  /// HostCommunicationService.requestNavigation(
  ///   '/profile',
  ///   {'userId': '12345'}
  /// );
  ///
  /// // กลับหน้า home
  /// HostCommunicationService.requestNavigation('/home');
  /// ```
  static void requestNavigation(String route, [Map<String, dynamic>? params]) {
    sendEvent(CommunicationType.navigationRequest, {
      'route': route, // เส้นทางที่ต้องการไป
      'params': params ?? {}, // parameters (default เป็น map ว่าง)
    });
  }

  /// ขอปิด module
  ///
  /// ใช้เมื่อ module ต้องการปิดตัวเอง
  /// host จะจัดการ cleanup และนำผู้ใช้กลับไปหน้าก่อนหน้า
  ///
  /// Parameters:
  /// - [reason]: เหตุผลในการปิด (optional)
  ///
  /// ตัวอย่างการใช้:
  /// ```dart
  /// // ผู้ใช้กดปุ่มปิด
  /// HostCommunicationService.requestClose('user_action');
  ///
  /// // ปิดเพราะทำงานเสร็จแล้ว
  /// HostCommunicationService.requestClose('task_completed');
  ///
  /// // ปิดเพราะ error
  /// HostCommunicationService.requestClose('error_occurred');
  /// ```
  static void requestClose([String? reason]) {
    sendEvent(CommunicationType.closeRequest, {
      'reason': reason ?? 'user_action', // default reason
    });
  }

  /// ขอ logout จากระบบ
  ///
  /// ใช้เมื่อ module ต้องการให้ผู้ใช้ logout
  /// host จะจัดการ clear session และนำไปหน้า login
  ///
  /// Parameters:
  /// - [reason]: เหตุผลในการ logout
  ///
  /// ตัวอย่างการใช้:
  /// ```dart
  /// // Session timeout
  /// HostCommunicationService.requestLogout('session_expired');
  ///
  /// // ผู้ใช้กด logout
  /// HostCommunicationService.requestLogout('user_logout');
  ///
  /// // Security issue
  /// HostCommunicationService.requestLogout('security_violation');
  /// ```
  static void requestLogout([String? reason]) {
    sendEvent(CommunicationType.logoutRequest, {'reason': reason ?? 'user_action'});
  }

  /// รายงานข้อผิดพลาดที่เกิดขึ้นใน module
  ///
  /// ใช้สำหรับส่ง error ให้ host จัดการ
  /// host อาจจะ log, แสดง dialog, หรือส่งไป crash reporting
  ///
  /// Parameters:
  /// - [error]: ข้อความ error
  /// - [context]: บริบทที่ error เกิด (optional)
  /// - [stackTrace]: stack trace สำหรับ debugging (optional)
  ///
  /// ตัวอย่างการใช้:
  /// ```dart
  /// try {
  ///   await apiCall();
  /// } catch (e, stackTrace) {
  ///   HostCommunicationService.reportError(
  ///     e.toString(),
  ///     'api_call_failed',
  ///     stackTrace
  ///   );
  /// }
  /// ```
  static void reportError(String error, [String? context, StackTrace? stackTrace]) {
    sendEvent(CommunicationType.errorReport, {
      'error': error, // ข้อความ error
      'context': context, // context (nullable)
      'stackTrace': stackTrace?.toString(), // stack trace (nullable)
    });
  }

  // ขอข้อมูลจาก host application
  ///
  /// ใช้เมื่อ module ต้องการข้อมูลที่ host เก็บไว้
  /// เช่น user profile ล่าสุด, settings, หรือข้อมูลที่ share ระหว่าง modules
  ///
  /// Parameters:
  /// - [dataType]: ประเภทของข้อมูลที่ต้องการ
  /// - [params]: parameters เพิ่มเติม (optional)
  ///
  /// ตัวอย่างการใช้:
  /// ```dart
  /// // ขอข้อมูล user profile
  /// HostCommunicationService.requestData('user_profile');
  ///
  /// // ขอข้อมูล transactions ในช่วงเวลา
  /// HostCommunicationService.requestData(
  ///   'transactions',
  ///   {'from': '2024-01-01', 'to': '2024-01-31'}
  /// );
  ///
  /// // ขอ app settings
  /// HostCommunicationService.requestData('app_settings');
  /// ```
  static void requestData(String dataType, [Map<String, dynamic>? params]) {
    sendEvent(CommunicationType.dataRequest, {
      'dataType': dataType, // ประเภทข้อมูลที่ต้องการ
      'params': params ?? {}, // parameters เพิ่มเติม
    });
  }

  /// แจ้ง host ว่า state ของ module เปลี่ยนแปลง
  ///
  /// ใช้สำหรับ sync state ระหว่าง module กับ host
  /// host อาจจะใช้ข้อมูลนี้ในการ update UI หรือ save state
  ///
  /// Parameters:
  /// - [state]: state data ที่เปลี่ยนแปลง
  ///
  /// ตัวอย่างการใช้:
  /// ```dart
  /// // แจ้งว่ากำลัง loading
  /// HostCommunicationService.notifyStateChange({
  ///   'isLoading': true,
  ///   'loadingMessage': 'กำลังโหลดข้อมูล...'
  /// });
  ///
  /// // แจ้งว่ามีการเปลี่ยนแปลงข้อมูล
  /// HostCommunicationService.notifyStateChange({
  ///   'hasUnsavedChanges': true,
  ///   'lastModified': DateTime.now().toIso8601String()
  /// });
  ///
  /// // แจ้ง progress
  /// HostCommunicationService.notifyStateChange({
  ///   'progress': 0.75,
  ///   'currentStep': 3,
  ///   'totalSteps': 4
  /// });
  /// ```
  static void notifyStateChange(Map<String, dynamic> state) {
    sendEvent(CommunicationType.stateChanged, state);
  }

  /// ส่ง custom event ที่ไม่อยู่ในรูปแบบมาตรฐาน
  ///
  /// ใช้สำหรับ events พิเศษที่ module และ host ตกลงกันเอง
  /// ให้ flexibility ในการขยายการสื่อสารนอกเหนือจาก predefined methods
  ///
  /// Parameters:
  /// - [eventType]: ชื่อ/ประเภทของ event
  /// - [data]: ข้อมูลที่ต้องการส่ง
  ///
  /// ตัวอย่างการใช้:
  /// ```dart
  /// // ส่ง analytics event
  /// HostCommunicationService.sendCustomEvent(
  ///   'analytics.track',
  ///   {
  ///     'event': 'button_clicked',
  ///     'properties': {'button_id': 'submit_payment'}
  ///   }
  /// );
  ///
  /// // ส่ง notification request
  /// HostCommunicationService.sendCustomEvent(
  ///   'notification.show',
  ///   {
  ///     'title': 'Payment Success',
  ///     'body': 'Your payment has been processed',
  ///     'type': 'success'
  ///   }
  /// );
  /// ```
  static void sendCustomEvent(String eventType, Map<String, dynamic> data) {
    sendEvent(eventType, data);
  }

  /// Cleanup และยกเลิกการเชื่อมต่อ
  ///
  /// เมธอดนี้จะถูกเรียกโดย MiniAppModuleBase ใน onModuleDispose()
  /// เพื่อทำความสะอาดและตัดการเชื่อมต่อกับ host
  ///
  /// การทำงาน:
  /// 1. ลบ event handler reference
  /// 2. Reset initialization flag
  /// 3. ลบ module ID
  ///
  /// สำคัญ: ต้องเรียก method นี้เสมอเมื่อ module ถูก dispose
  /// เพื่อป้องกัน memory leaks
  static void dispose() {
    _eventHandler = null; // ลบ reference ไปยัง callback
    _isInitialized = false; // reset flag
    _moduleId = null; // ลบ module ID
  }
}

// ============================================
// Event Type Constants
// ============================================

/// คลาสที่เก็บค่าคงที่ของประเภท communication/events
///
/// ใช้ constants เพื่อ:
/// 1. ป้องกันการพิมพ์ผิด (typo)
/// 2. ทำให้ refactor ง่าย
/// 3. เป็นมาตรฐานเดียวกันทั้งระบบ
/// 4. IDE auto-complete ช่วยในการพัฒนา
///
/// Naming convention:
/// - ใช้ dot notation: category.action
/// - lowercase with underscore
class CommunicationType {
  // Navigation Events
  /// Event สำหรับขอให้ host นำทางไปหน้าอื่น
  static const String navigationRequest = 'navigation.request';

  // Module Lifecycle Events
  /// Event สำหรับขอปิด module
  static const String closeRequest = 'module.close_request';

  // Authentication Events
  /// Event สำหรับขอ logout
  static const String logoutRequest = 'auth.logout_request';

  // Error Events
  /// Event สำหรับรายงาน error
  static const String errorReport = 'error.report';

  // Data Events
  /// Event สำหรับขอข้อมูลจาก host
  static const String dataRequest = 'data.request';

  // State Events
  /// Event แจ้งการเปลี่ยนแปลง state
  static const String stateChanged = 'state.changed';

  /// Event แจ้งว่า module พร้อมทำงานแล้ว
  static const String ready = 'module.ready';

  /// Event แจ้งว่า module ถูก dispose แล้ว
  static const String disposed = 'module.disposed';
}

// ============================================
// สรุปการใช้งาน HostCommunicationService
// ============================================
//
// 1. **Initialization (ใน MiniAppModuleBase):**
//    ```dart
//    void onModuleInit() {
//      HostCommunicationService.initialize(
//        moduleId: 'payment',
//        onEvent: handleHostEvent
//      );
//    }
//    ```
//
// 2. **การส่ง Events:**
//    ```dart
//    // Navigate
//    HostCommunicationService.requestNavigation('/home');
//    
//    // Report Error
//    HostCommunicationService.reportError('API Failed');
//    
//    // Custom Event
//    HostCommunicationService.sendCustomEvent('custom.action', data);
//    ```
//
// 3. **Disposal:**
//    ```dart
//    void onModuleDispose() {
//      HostCommunicationService.dispose();
//    }
//    ```
//
// Service นี้ทำให้การสื่อสารระหว่าง Module และ Host 
// เป็นไปอย่างมีระเบียบ ปลอดภัย และง่ายต่อการจัดการ