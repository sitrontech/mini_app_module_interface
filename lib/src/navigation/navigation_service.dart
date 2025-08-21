// ===============================================
// lib/src/navigation/navigation_service.dart
// ===============================================
//
// ไฟล์นี้เป็น Navigation Service ที่ทำหน้าที่จัดการการนำทางระหว่าง modules
// ในฝั่ง Host Application โดยมีระบบ routing registry และ custom handler
// ทำให้ host app สามารถควบคุมวิธีการ navigate ได้อย่างยืดหยุ่น

import 'package:flutter/foundation.dart';

/// Host navigation service interface
///
/// Service นี้เป็นตัวกลางในการจัดการ navigation ระหว่าง modules
/// โดย host application จะใช้ service นี้ในการ:
/// 1. ลงทะเบียน routes ของแต่ละ module
/// 2. จัดการ navigation requests จาก modules
/// 3. Customize พฤติกรรมการ navigate ผ่าน custom handler
///
/// การออกแบบเน้นความยืดหยุ่น โดย host สามารถ:
/// - ใช้ระบบ route registration แบบง่าย
/// - หรือใช้ custom handler สำหรับ logic ที่ซับซ้อน
class HostNavigationService {
  // ============================================
  // Private Properties
  // ============================================

  /// Map เก็บ routes ที่ลงทะเบียนของแต่ละ module
  ///
  /// Structure: {moduleId: route}
  /// ตัวอย่าง:
  /// ```dart
  /// {
  ///   'payment': '/payment',
  ///   'profile': '/user/profile',
  ///   'settings': '/app/settings'
  /// }
  /// ```
  ///
  /// ใช้ Map นี้เป็น routing table สำหรับการ navigate
  final Map<String, String> _moduleRoutes = {};

  /// Custom handler function สำหรับจัดการ navigation
  ///
  /// Function signature:
  /// - Parameter 1: moduleId - ID ของ module ที่จะ navigate ไป
  /// - Parameter 2: data - ข้อมูลที่ส่งมาพร้อมกับ navigation request
  ///
  /// ถ้า custom handler ถูกกำหนด จะใช้ handler นี้แทนระบบ routing ปกติ
  /// ทำให้ host app สามารถ implement custom navigation logic ได้
  ///
  /// ตัวอย่างการใช้:
  /// ```dart
  /// void myCustomHandler(String moduleId, Map<String, dynamic> data) {
  ///   if (moduleId == 'payment' && !userIsLoggedIn) {
  ///     navigateToLogin();
  ///   } else {
  ///     navigateToModule(moduleId, data);
  ///   }
  /// }
  /// ```
  final void Function(String moduleId, Map<String, dynamic> data)? _customHandler;

  /// Constructor พร้อม optional parameters
  ///
  /// Parameters:
  /// - [moduleRoutes]: Map ของ routes เริ่มต้น (optional)
  /// - [customHandler]: Custom navigation handler (optional)
  ///
  /// ตัวอย่างการสร้าง:
  /// ```dart
  /// // แบบที่ 1: ใช้ route registration
  /// final service = HostNavigationService(
  ///   moduleRoutes: {
  ///     'payment': '/payment',
  ///     'profile': '/profile'
  ///   }
  /// );
  ///
  /// // แบบที่ 2: ใช้ custom handler
  /// final service = HostNavigationService(
  ///   customHandler: (moduleId, data) {
  ///     // Custom logic
  ///   }
  /// );
  /// ```
  HostNavigationService({
    Map<String, String>? moduleRoutes,
    void Function(String moduleId, Map<String, dynamic> data)? customHandler,
  }) : _customHandler = customHandler {
    // ถ้ามี initial routes ให้เพิ่มเข้า map
    if (moduleRoutes != null) {
      _moduleRoutes.addAll(moduleRoutes);
    }
  }

  // ============================================
  // Public Navigation Methods
  // ============================================

  /// Method หลักสำหรับ navigate ไปยัง module
  ///
  /// Method นี้จะถูกเรียกเมื่อมี navigation request
  /// จาก mini app หรือส่วนอื่นๆ ของ application
  ///
  /// Parameters:
  /// - [moduleId]: ID ของ module ที่ต้องการ navigate ไป
  /// - [navigationData]: ข้อมูลที่ส่งมาพร้อมกับ request
  ///
  /// ลำดับการทำงาน:
  /// 1. Log navigation request
  /// 2. ถ้ามี custom handler ให้ใช้ handler
  /// 3. ถ้าไม่มี handler ให้ใช้ registered routes
  /// 4. ถ้าไม่พบ route ให้จัดการ unknown module
  ///
  /// ตัวอย่างการเรียกใช้:
  /// ```dart
  /// service.navigateToModule('payment', {
  ///   'orderId': '12345',
  ///   'amount': 1500.00,
  ///   'timestamp': DateTime.now().toIso8601String()
  /// });
  /// ```
  void navigateToModule(String moduleId, Map<String, dynamic> navigationData) {
    // Debug logging - แสดงข้อมูล navigation
    debugPrint('🎯 HostNavigationService: Navigating to $moduleId');
    debugPrint('   Data: $navigationData');

    // ถ้ามี custom handler ให้ใช้ handler และจบการทำงาน
    // Custom handler มี priority สูงสุด
    if (_customHandler != null) {
      _customHandler!(moduleId, navigationData);
      return; // จบการทำงานทันที
    }

    // Fallback: ใช้ระบบ route registration
    // ค้นหา route ที่ลงทะเบียนไว้
    final route = _moduleRoutes[moduleId];

    if (route != null) {
      // พบ route - ทำการ navigate
      debugPrint('   Using registered route: $route');

      // เรียก default navigation
      // Host app ควร override behavior นี้
      _defaultNavigation(moduleId, route, navigationData);
    } else {
      // ไม่พบ route - จัดการ unknown module
      debugPrint('❌ No route registered for module: $moduleId');
      _handleUnknownModule(moduleId, navigationData);
    }
  }

  // ============================================
  // Route Registration Methods
  // ============================================

  /// ลงทะเบียน route สำหรับ module เดียว
  ///
  /// ใช้สำหรับเพิ่ม route mapping ทีละ module
  ///
  /// Parameters:
  /// - [moduleId]: ID ของ module
  /// - [route]: Route path สำหรับ module นั้น
  ///
  /// ตัวอย่างการใช้:
  /// ```dart
  /// service.registerModuleRoute('payment', '/payment');
  /// service.registerModuleRoute('profile', '/user/profile');
  /// ```
  void registerModuleRoute(String moduleId, String route) {
    _moduleRoutes[moduleId] = route;
    debugPrint('📝 Registered route for $moduleId: $route');
  }

  /// ลงทะเบียน routes หลายตัวพร้อมกัน
  ///
  /// ใช้สำหรับเพิ่ม route mappings จำนวนมากในครั้งเดียว
  /// สะดวกสำหรับการ setup ตอน initialization
  ///
  /// Parameters:
  /// - [routes]: Map ของ moduleId -> route
  ///
  /// ตัวอย่างการใช้:
  /// ```dart
  /// service.registerModuleRoutes({
  ///   'payment': '/payment',
  ///   'profile': '/profile',
  ///   'settings': '/settings',
  ///   'help': '/help'
  /// });
  /// ```
  void registerModuleRoutes(Map<String, String> routes) {
    // เพิ่ม routes ทั้งหมดเข้า map
    _moduleRoutes.addAll(routes);

    // Log แต่ละ route ที่ลงทะเบียน
    routes.forEach((moduleId, route) {
      debugPrint('📝 Registered route for $moduleId: $route');
    });
  }

  // ============================================
  // Query Methods
  // ============================================

  /// ดึง routes ที่ลงทะเบียนทั้งหมด (read-only)
  ///
  /// Returns:
  /// Unmodifiable map ของ routes ที่ลงทะเบียน
  /// ป้องกันการแก้ไขจากภายนอก
  ///
  /// ใช้สำหรับ:
  /// - Debugging
  /// - แสดงรายการ modules ที่มี
  /// - Validation
  ///
  /// ตัวอย่างการใช้:
  /// ```dart
  /// final routes = service.registeredRoutes;
  /// print('Available modules: ${routes.keys}');
  /// ```
  Map<String, String> get registeredRoutes => Map.unmodifiable(_moduleRoutes);

  /// ตรวจสอบว่า module ถูกลงทะเบียนหรือไม่
  ///
  /// Parameters:
  /// - [moduleId]: ID ของ module ที่ต้องการตรวจสอบ
  ///
  /// Returns:
  /// true ถ้า module มี route ที่ลงทะเบียน, false ถ้าไม่มี
  ///
  /// ใช้สำหรับ:
  /// - Validation ก่อน navigate
  /// - แสดง/ซ่อน UI elements
  /// - Feature flags
  ///
  /// ตัวอย่างการใช้:
  /// ```dart
  /// if (service.isModuleRegistered('payment')) {
  ///   showPaymentButton();
  /// } else {
  ///   showComingSoonMessage();
  /// }
  /// ```
  bool isModuleRegistered(String moduleId) => _moduleRoutes.containsKey(moduleId);

  // ============================================
  // Private Helper Methods
  // ============================================

  /// Default navigation implementation
  ///
  /// Method นี้เป็น placeholder สำหรับ default navigation
  /// Host app ควร provide custom handler หรือ override method นี้
  ///
  /// Parameters:
  /// - [moduleId]: ID ของ module
  /// - [route]: Route ที่ลงทะเบียน
  /// - [data]: Navigation data
  ///
  /// Note: Method นี้จะ print warning เท่านั้น
  /// Host app ต้อง implement navigation logic จริง
  void _defaultNavigation(String moduleId, String route, Map<String, dynamic> data) {
    debugPrint('⚠️ Using default navigation - host app should override this');

    // Host app ควร:
    // 1. ใช้ Navigator.pushNamed(context, route, arguments: data)
    // 2. หรือใช้ custom navigation solution (go_router, auto_route, etc.)
    // 3. หรือ handle ด้วย state management
  }

  /// จัดการกรณี module ไม่รู้จัก
  ///
  /// Method นี้จะถูกเรียกเมื่อพยายาม navigate ไป module
  /// ที่ไม่มี route ลงทะเบียน
  ///
  /// Parameters:
  /// - [moduleId]: ID ของ module ที่ไม่รู้จัก
  /// - [data]: Navigation data
  ///
  /// Host app ควร:
  /// - แสดง error message
  /// - Navigate ไป fallback page
  /// - Log error สำหรับ monitoring
  void _handleUnknownModule(String moduleId, Map<String, dynamic> data) {
    debugPrint('❌ Unknown module navigation: $moduleId');

    // Host app ควร handle กรณีนี้ เช่น:
    // - แสดง 404 page
    // - แสดง error dialog
    // - Redirect ไป home page
    // - Log to crash reporting service
  }
}

// ============================================
// สรุปการใช้งาน HostNavigationService
// ============================================
//
// Service นี้มี 2 โหมดการทำงาน:
//
// **โหมดที่ 1: Route Registration**
// ```dart
// final service = HostNavigationService();
// 
// // ลงทะเบียน routes
// service.registerModuleRoutes({
//   'payment': '/payment',
//   'profile': '/profile'
// });
// 
// // Navigate
// service.navigateToModule('payment', {'orderId': '123'});
// ```
//
// **โหมดที่ 2: Custom Handler**
// ```dart
// final service = HostNavigationService(
//   customHandler: (moduleId, data) {
//     // Custom logic
//     switch(moduleId) {
//       case 'payment':
//         if (userIsLoggedIn) {
//           Navigator.pushNamed(context, '/payment', arguments: data);
//         } else {
//           Navigator.pushNamed(context, '/login');
//         }
//         break;
//       default:
//         showErrorDialog('Unknown module: $moduleId');
//     }
//   }
// );
// ```
//
// **Integration with Provider:**
// ```dart
// // ที่ root ของ app
// HostNavigatorProvider(
//   navigationService: service,
//   child: MyApp()
// )
// ```
//
// Service นี้ให้ flexibility ในการจัดการ navigation
// โดย host app สามารถเลือกใช้วิธีที่เหมาะสมกับ architecture
