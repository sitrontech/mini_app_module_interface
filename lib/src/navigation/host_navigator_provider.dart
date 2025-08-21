// ===============================================
// lib/src/navigation/host_navigator_provider.dart
// ===============================================
//
// ไฟล์นี้ประกอบด้วย classes สำหรับจัดการการส่งผ่าน Navigation Service
// ไปยัง widget tree โดยใช้ InheritedWidget pattern
// ทำให้ mini apps สามารถเข้าถึง navigation service ได้จากทุกที่ใน widget tree
// โดยไม่ต้องส่งผ่าน service เป็น parameter ไปทุก widget

import 'package:flutter/material.dart';
import 'navigation_service.dart';

// ============================================
// HostNavigatorProvider - InheritedWidget
// ============================================

/// InheritedWidget สำหรับ provide navigation service ให้กับ mini apps
///
/// คลาสนี้ใช้ InheritedWidget pattern ซึ่งเป็น Flutter pattern สำหรับ
/// การส่งผ่านข้อมูลลงไปใน widget tree โดยไม่ต้อง pass เป็น constructor parameter
///
/// การทำงาน:
/// 1. Wrap widget tree ด้วย HostNavigatorProvider
/// 2. Child widgets สามารถเข้าถึง service ผ่าน context
/// 3. เมื่อ service เปลี่ยน, widgets ที่ depend จะถูก rebuild
///
/// ตัวอย่างการใช้งาน:
/// ```dart
/// // Wrap app ด้วย provider
/// HostNavigatorProvider(
///   navigationService: myNavigationService,
///   child: MyApp(),
/// )
///
/// // เข้าถึง service จาก child widget
/// final service = HostNavigatorProvider.of(context);
/// ```
class HostNavigatorProvider extends InheritedWidget {
  /// Navigation service instance ที่จะส่งผ่านไปยัง widget tree
  ///
  /// Service นี้จะถูกใช้โดย mini apps และ widgets ต่างๆ
  /// สำหรับการ navigate ระหว่าง modules
  final HostNavigationService navigationService;

  /// Constructor
  ///
  /// Parameters:
  /// - [navigationService]: service instance ที่จะ provide
  /// - [child]: root widget ของ subtree ที่ต้องการ provide service
  const HostNavigatorProvider({super.key, required this.navigationService, required super.child});

  // ============================================
  // Static Methods สำหรับเข้าถึง Service
  // ============================================

  /// ดึง navigation service จาก context
  ///
  /// Method นี้จะค้นหา HostNavigatorProvider ใน widget tree
  /// และ return navigation service ที่อยู่ในนั้น
  ///
  /// Parameters:
  /// - [context]: BuildContext ของ widget ที่ต้องการใช้ service
  ///
  /// Returns:
  /// - HostNavigationService ถ้าพบ provider ใน tree
  /// - null ถ้าไม่พบ provider
  ///
  /// การทำงาน:
  /// 1. ใช้ dependOnInheritedWidgetOfExactType เพื่อค้นหา provider
  /// 2. Method นี้จะ register widget ให้ rebuild เมื่อ provider เปลี่ยน
  /// 3. Return navigation service หรือ null
  ///
  /// ตัวอย่างการใช้:
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   final navService = HostNavigatorProvider.of(context);
  ///   if (navService != null) {
  ///     // ใช้ service
  ///     navService.navigateToModule('payment');
  ///   }
  /// }
  /// ```
  static HostNavigationService? of(BuildContext context) {
    // ค้นหา HostNavigatorProvider ใน widget tree
    // และดึง navigationService ออกมา
    // ใช้ ?. operator เพื่อจัดการกรณีที่ไม่พบ provider
    return context.dependOnInheritedWidgetOfExactType<HostNavigatorProvider>()?.navigationService;
  }

  /// ตรวจสอบว่ามี provider อยู่ใน context หรือไม่
  ///
  /// ใช้สำหรับตรวจสอบก่อนที่จะพยายามใช้ service
  /// ป้องกัน null pointer exceptions
  ///
  /// Parameters:
  /// - [context]: BuildContext ที่ต้องการตรวจสอบ
  ///
  /// Returns:
  /// - true ถ้าพบ provider ใน tree
  /// - false ถ้าไม่พบ
  ///
  /// ตัวอย่างการใช้:
  /// ```dart
  /// if (HostNavigatorProvider.exists(context)) {
  ///   // มั่นใจว่ามี provider แล้วค่อยใช้
  ///   final service = HostNavigatorProvider.of(context)!;
  ///   service.navigateToModule('profile');
  /// } else {
  ///   // จัดการกรณีไม่มี provider
  ///   print('Navigation service not available');
  /// }
  /// ```
  static bool exists(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<HostNavigatorProvider>() != null;
  }

  // /// Try to get navigation service, throw error if not found
  // static HostNavigationService require(BuildContext context) {
  //   final service = of(context);
  //   if (service == null) {
  //     throw FlutterError(
  //       'HostNavigatorProvider not found in widget tree.\n'
  //       'Make sure to wrap your app with HostNavigatorProvider.',
  //     );
  //   }
  //   return service;
  // }

  /// กำหนดเงื่อนไขการ rebuild ของ widgets ที่ depend on provider นี้
  ///
  /// Method นี้จะถูกเรียกเมื่อ widget tree rebuild
  /// เพื่อตัดสินใจว่าต้อง notify dependent widgets หรือไม่
  ///
  /// Parameters:
  /// - [oldWidget]: instance เก่าของ provider
  ///
  /// Returns:
  /// - true ถ้า navigationService เปลี่ยน (ต้อง rebuild dependents)
  /// - false ถ้า navigationService เหมือนเดิม (ไม่ต้อง rebuild)
  ///
  /// การทำงาน:
  /// เปรียบเทียบ reference ของ navigationService
  /// ถ้าเป็นคนละ instance จะ return true
  @override
  bool updateShouldNotify(HostNavigatorProvider oldWidget) {
    // เปรียบเทียบ reference ของ service
    // ถ้าเปลี่ยน = ต้อง notify widgets ที่ depend
    return navigationService != oldWidget.navigationService;
  }
}

// ============================================
// NavigationServiceBuilder - Helper Widget
// ============================================

/// Widget builder ที่ช่วยให้การใช้ HostNavigatorProvider สะดวกขึ้น
///
/// คลาสนี้เป็น convenience widget ที่ wrap HostNavigatorProvider
/// ทำให้ code อ่านง่ายขึ้นและลด boilerplate
///
/// แทนที่จะเขียน:
/// ```dart
/// HostNavigatorProvider(
///   navigationService: service,
///   child: MyApp(),
/// )
/// ```
///
/// สามารถเขียน:
/// ```dart
/// NavigationServiceBuilder(
///   navigationService: service,
///   child: MyApp(),
/// )
/// ```
class NavigationServiceBuilder extends StatelessWidget {
  /// Navigation service ที่จะ provide
  final HostNavigationService navigationService;

  /// Widget tree ที่ต้องการ provide service ให้
  final Widget child;

  /// Constructor
  const NavigationServiceBuilder({super.key, required this.navigationService, required this.child});

  /// Build method ที่ wrap child ด้วย HostNavigatorProvider
  ///
  /// ทำหน้าที่เป็น wrapper ที่ช่วยลด boilerplate code
  /// และทำให้ intent ของ code ชัดเจนขึ้น
  @override
  Widget build(BuildContext context) {
    return HostNavigatorProvider(navigationService: navigationService, child: child);
  }
}

// ============================================
// NavigationServiceMixin - Mixin Helper
// ============================================

/// Mixin สำหรับ StatefulWidgets ที่ต้องการใช้ navigation service
///
/// Mixin นี้ provide helper methods และ properties
/// ที่ทำให้การใช้ navigation service สะดวกขึ้น
///
/// Features:
/// 1. Getter สำหรับเข้าถึง service
/// 2. Helper method สำหรับ navigation
/// 3. ตรวจสอบการมีอยู่ของ service
///
/// การใช้งาน:
/// ```dart
/// class MyWidgetState extends State<MyWidget>
///     with NavigationServiceMixin {
///
///   void onButtonPressed() {
///     // ใช้ helper method จาก mixin
///     navigateToModule('payment', {'amount': 100});
///   }
/// }
/// ```
///
/// Type parameter [T] ต้อง extends StatefulWidget
/// เพื่อให้มั่นใจว่า mixin ถูกใช้กับ State class เท่านั้น
mixin NavigationServiceMixin<T extends StatefulWidget> on State<T> {
  /// Getter สำหรับเข้าถึง navigation service จาก context
  ///
  /// Returns:
  /// - HostNavigationService ถ้าพบใน widget tree
  /// - null ถ้าไม่พบ
  ///
  /// Property นี้ทำให้เข้าถึง service ได้ง่าย
  /// โดยไม่ต้องเรียก HostNavigatorProvider.of(context) เอง
  HostNavigationService? get navigationService => HostNavigatorProvider.of(context);

  /// ตรวจสอบว่ามี navigation service หรือไม่
  ///
  /// Returns:
  /// - true ถ้ามี service
  /// - false ถ้าไม่มี
  ///
  /// ใช้สำหรับ conditional logic:
  /// ```dart
  /// if (hasNavigationService) {
  ///   // แสดงปุ่ม navigate
  /// } else {
  ///   // ซ่อนปุ่มหรือแสดง disabled state
  /// }
  /// ```
  bool get hasNavigationService => navigationService != null;

  /// Helper method สำหรับ navigate ไปยัง module อื่น
  ///
  /// Method นี้จัดการ null checking และ error handling
  /// ทำให้การ navigate สะดวกและปลอดภัยขึ้น
  ///
  /// Parameters:
  /// - [moduleId]: ID ของ module ที่ต้องการ navigate ไป
  /// - [data]: ข้อมูลที่ต้องการส่งไปยัง module (optional)
  ///
  /// การทำงาน:
  /// 1. ดึง navigation service จาก context
  /// 2. ถ้ามี service ให้เรียก navigateToModule
  /// 3. ถ้าไม่มี service ให้ print error message
  ///
  /// ตัวอย่างการใช้:
  /// ```dart
  /// // Navigate พร้อมส่งข้อมูล
  /// navigateToModule('payment', {
  ///   'orderId': '12345',
  ///   'amount': 1500.00
  /// });
  ///
  /// // Navigate แบบไม่ส่งข้อมูล
  /// navigateToModule('profile');
  /// ```
  void navigateToModule(String moduleId, [Map<String, dynamic>? data]) {
    // ดึง service จาก getter
    final service = navigationService;

    if (service != null) {
      // มี service - ทำการ navigate
      // ใช้ ?? {} เพื่อส่ง empty map ถ้า data เป็น null
      service.navigateToModule(moduleId, data ?? {});
    } else {
      // ไม่มี service - แสดง error message
      // ใช้ debugPrint แทน print เพื่อไม่แสดงใน production
      debugPrint('❌ Navigation service not found in context');
    }
  }
}

// ============================================
// สรุปการใช้งาน
// ============================================
//
// 1. **Setup Provider ที่ root ของ app:**
//    ```dart
//    void main() {
//      final navService = HostNavigationService();
//      runApp(
//        NavigationServiceBuilder(
//          navigationService: navService,
//          child: MyApp(),
//        )
//      );
//    }
//    ```
//
// 2. **ใช้ service ใน widget แบบ manual:**
//    ```dart
//    Widget build(BuildContext context) {
//      final navService = HostNavigatorProvider.of(context);
//      return ElevatedButton(
//        onPressed: () {
//          navService?.navigateToModule('payment');
//        },
//        child: Text('Go to Payment'),
//      );
//    }
//    ```
//
// 3. **ใช้ผ่าน mixin (recommended):**
//    ```dart
//    class MyPageState extends State<MyPage> 
//        with NavigationServiceMixin {
//      
//      void handlePayment() {
//        navigateToModule('payment', {'amount': 100});
//      }
//    }
//    ```
//
// Pattern นี้ทำให้การจัดการ navigation service 
// เป็นไปอย่างมีระเบียบและง่ายต่อการใช้งานทั่วทั้ง app