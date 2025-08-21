// ===============================================
// lib/src/navigation/navigation_handler.dart
// ===============================================
//
// ไฟล์นี้จัดการ navigation logic สำหรับ mini apps
// โดยมี abstract class และ implementation ที่จัดการการนำทาง
// ระหว่าง modules พร้อม error handling และ debugging features
// ทำหน้าที่เป็นตัวกลางระหว่าง mini app กับ host navigation service

import 'package:flutter/material.dart';
import 'host_navigator_provider.dart';

// ============================================
// Abstract Navigation Handler Interface
// ============================================

/// Abstract navigation handler สำหรับ mini apps
///
/// Interface นี้กำหนดโครงสร้างพื้นฐานที่ navigation handler
/// ทุกตัวต้องมี เพื่อให้มีมาตรฐานเดียวกันในการจัดการ navigation
///
/// การออกแบบเป็น abstract class ทำให้:
/// 1. สามารถสร้าง custom handler ได้
/// 2. มีมาตรฐานเดียวกันทั้งระบบ
/// 3. ง่ายต่อการ test และ mock
abstract class MiniAppNavigationHandler {
  /// Module ID ที่ unique สำหรับระบุ mini app
  ///
  /// ใช้สำหรับ:
  /// - ระบุ target module ในการ navigate
  /// - Logging และ debugging
  /// - การจัดการ routing
  String get moduleId;

  /// ชื่อที่แสดงให้ผู้ใช้เห็น
  ///
  /// ใช้สำหรับ:
  /// - แสดงใน error messages
  /// - UI labels และ titles
  /// - User feedback
  String get displayName;

  /// Method หลักสำหรับจัดการ navigation ไปยัง mini app
  ///
  /// Parameters:
  /// - [context]: BuildContext สำหรับเข้าถึง widget tree
  /// - [targetRoute]: Route ภายใน mini app ที่ต้องการไป (optional)
  /// - [extraData]: ข้อมูลเพิ่มเติมที่ต้องการส่ง (optional)
  /// - [onPressed]: Callback ที่จะเรียกก่อน navigation (optional)
  ///
  /// การทำงาน:
  /// 1. เรียก onPressed callback (ถ้ามี)
  /// 2. เตรียมข้อมูล navigation
  /// 3. หา navigation service และทำการ navigate
  /// 4. จัดการ error ถ้า navigation ล้มเหลว
  void navigateToMiniApp({
    required BuildContext context,
    String? targetRoute,
    Map<String, dynamic>? extraData,
    VoidCallback? onPressed,
  });
}

// ============================================
// Base Implementation
// ============================================

/// Implementation พื้นฐานของ navigation handler
///
/// คลาสนี้ implement logic สำหรับ:
/// 1. การหา navigation service จาก context
/// 2. การเตรียมข้อมูลสำหรับ navigation
/// 3. Error handling และ user feedback
/// 4. Debugging และ logging
///
/// สามารถใช้โดยตรงหรือ extend เพื่อ customize behavior
class BaseMiniAppNavigationHandler implements MiniAppNavigationHandler {
  @override
  final String moduleId;

  @override
  final String displayName;

  /// Constructor
  ///
  /// Parameters:
  /// - [moduleId]: ID ของ module ที่จะ navigate ไป
  /// - [displayName]: ชื่อที่แสดงในกรณี error
  const BaseMiniAppNavigationHandler({required this.moduleId, required this.displayName});

  /// Implementation ของ navigation method หลัก
  ///
  /// ขั้นตอนการทำงาน:
  /// 1. Log การเรียกใช้สำหรับ debugging
  /// 2. เรียก onPressed callback (ถ้ามี)
  /// 3. เตรียมข้อมูล navigation
  /// 4. พยายามหา host navigation service
  /// 5. ทำการ navigate หรือจัดการ error
  @override
  void navigateToMiniApp({
    required BuildContext context,
    String? targetRoute,
    Map<String, dynamic>? extraData,
    VoidCallback? onPressed,
  }) {
    // Debug logging - แสดงข้อมูลการ navigate
    debugPrint('🎯 BaseMiniAppNavigationHandler.navigateToMiniApp called');
    debugPrint('   Module ID: $moduleId');
    debugPrint('   Target route: $targetRoute');
    debugPrint('   Extra data: $extraData');

    // เรียก callback ก่อน navigation (ถ้ามี)
    // ใช้สำหรับ analytics, state update, หรือ side effects อื่นๆ
    onPressed?.call();

    // เตรียมข้อมูลสำหรับ navigation
    // รวม metadata, route, และ extra data
    final navigationData = _prepareNavigationData(targetRoute, extraData);

    // พยายามหา navigation service และทำการ navigate
    _notifyHostApp(context, navigationData);
  }

  /// เตรียมข้อมูลสำหรับ navigation
  ///
  /// สร้าง Map ที่มีข้อมูลทั้งหมดที่จำเป็นสำหรับ navigation
  /// รวมถึง metadata สำหรับ tracking และ debugging
  ///
  /// Parameters:
  /// - [targetRoute]: Route ที่ต้องการไปภายใน module
  /// - [extraData]: ข้อมูลเพิ่มเติม
  ///
  /// Returns:
  /// Map ที่มีข้อมูล navigation ทั้งหมด
  Map<String, dynamic> _prepareNavigationData(String? targetRoute, Map<String, dynamic>? extraData) {
    // สร้าง base data พร้อม metadata
    final data = <String, dynamic>{
      'moduleId': moduleId, // ระบุ target module
      'source': 'mini_app_shortcut', // ระบุที่มาของ navigation
      'timestamp': DateTime.now().toIso8601String(), // เวลาที่ navigate
    };

    // เพิ่ม route ถ้ามีการระบุ
    if (targetRoute != null) {
      data['route'] = targetRoute; // Route หลัก
      data['initialRoute'] = targetRoute; // Initial route สำหรับ compatibility
    }

    // รวม extra data ถ้ามี
    // ใช้ addAll เพื่อ merge data
    if (extraData != null) {
      data.addAll(extraData);
    }

    debugPrint('📦 Navigation data prepared: $data');
    return data;
  }

  /// แจ้ง host app ให้ทำการ navigate
  ///
  /// พยายามหา navigation service จาก context
  /// และใช้ service นั้นในการ navigate
  ///
  /// ลำดับการค้นหา:
  /// 1. หาจาก context โดยตรง
  /// 2. ค้นหาใน widget tree
  /// 3. จัดการ error ถ้าไม่พบ
  void _notifyHostApp(BuildContext context, Map<String, dynamic> data) {
    debugPrint('🔍 Looking for HostNavigatorProvider in context...');

    try {
      // Method 1: พยายามหา navigation service จาก context โดยตรง
      // ใช้ InheritedWidget pattern
      final hostNavigator = HostNavigatorProvider.of(context);

      if (hostNavigator != null) {
        // พบ service - ทำการ navigate
        debugPrint('✅ HostNavigatorProvider found, delegating navigation');
        hostNavigator.navigateToModule(moduleId, data);
        return;
      } else {
        // ไม่พบใน immediate context
        debugPrint('⚠️ HostNavigatorProvider not found in immediate context');

        // Method 2: พยายามค้นหาใน widget tree
        // อาจจะอยู่ในระดับที่สูงกว่า
        if (_tryFindProviderInTree(context, data)) {
          return; // พบและ navigate สำเร็จ
        }
      }

      // Method 3: ไม่พบ service - จัดการ error
      _handleNavigationFailure(context, data);
    } catch (e) {
      // จับ error ทั้งหมดเพื่อป้องกัน crash
      debugPrint('❌ Navigation error: $e');
      _handleNavigationFailure(context, data);
    }
  }

  /// พยายามค้นหา provider ใน widget tree
  ///
  /// เดินขึ้นไปใน widget tree เพื่อหา HostNavigatorProvider
  /// มี depth limit เพื่อป้องกัน infinite loop
  ///
  /// Parameters:
  /// - [context]: Starting context
  /// - [data]: Navigation data
  ///
  /// Returns:
  /// true ถ้าพบและ navigate สำเร็จ, false ถ้าไม่พบ
  bool _tryFindProviderInTree(BuildContext context, Map<String, dynamic> data) {
    debugPrint('🔍 Trying to find provider in widget tree...');

    try {
      // เริ่มจาก context ปัจจุบัน
      BuildContext? currentContext = context;
      int depth = 0;
      const maxDepth = 10; // จำกัดความลึกเพื่อป้องกัน infinite loop

      // เดินขึ้นไปใน tree จนกว่าจะพบหรือถึง limit
      while (currentContext != null && depth < maxDepth) {
        // พยายามหา HostNavigatorProvider
        final provider = currentContext.dependOnInheritedWidgetOfExactType<HostNavigatorProvider>();
        if (provider != null) {
          // พบ provider - ทำการ navigate
          debugPrint('✅ Found HostNavigatorProvider at depth $depth');
          provider.navigationService.navigateToModule(moduleId, data);
          return true;
        }

        // พยายามหา parent context
        // ระวังไม่ข้าม Navigator boundary
        try {
          currentContext = currentContext.widget is! Navigator
              ? currentContext.findAncestorWidgetOfExactType<MaterialApp>()?.createState().context
              : null;
        } catch (e) {
          debugPrint('⚠️ Could not get parent context: $e');
          break;
        }

        depth++;
      }

      debugPrint('❌ Provider not found in widget tree (searched $depth levels)');
      return false;
    } catch (e) {
      debugPrint('❌ Error searching widget tree: $e');
      return false;
    }
  }

  /// จัดการกรณี navigation ล้มเหลว
  ///
  /// แสดง error message ให้ผู้ใช้เห็น
  /// และ log debug information
  void _handleNavigationFailure(BuildContext context, Map<String, dynamic> data) {
    debugPrint('❌ Navigation failed - no valid navigation method found');
    debugPrint('📋 Failed navigation data: $data');

    // แสดง error ให้ผู้ใช้เห็น (ถ้า context ยัง mounted)
    if (context.mounted) {
      _showNavigationError(context);
    }

    // Log ข้อมูล debug เพิ่มเติม
    _logDebugInfo(context);
  }

  /// แสดง error message ผ่าน SnackBar
  ///
  /// แสดง SnackBar พร้อม:
  /// - ข้อความ error ที่เข้าใจง่าย
  /// - ปุ่ม Debug สำหรับดูรายละเอียด
  /// - สีแดงเพื่อบ่งบอกว่าเป็น error
  void _showNavigationError(BuildContext context) {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to open $displayName'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
          action: SnackBarAction(label: 'Debug', textColor: Colors.white, onPressed: () => _showDebugDialog(context)),
        ),
      );
    } catch (e) {
      // จับ error กรณีไม่มี ScaffoldMessenger
      debugPrint('❌ Could not show error SnackBar: $e');
    }
  }

  /// แสดง debug dialog พร้อมรายละเอียด error
  ///
  /// Dialog นี้แสดง:
  /// - Module information
  /// - คำแนะนำในการแก้ไข
  /// - Technical details
  void _showDebugDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Navigation Debug'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // แสดงข้อมูล module
            Text('Module ID: $moduleId'),
            Text('Display Name: $displayName'),
            const SizedBox(height: 8),

            // คำอธิบายปัญหาและวิธีแก้
            const Text(
              'The navigation service is not properly configured. '
              'Make sure HostNavigatorProvider is available in the widget tree.',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK'))],
      ),
    );
  }

  /// Log debug information สำหรับ troubleshooting
  ///
  /// แสดงข้อมูล context และ widget tree
  /// ช่วยในการ debug ว่าทำไม navigation ถึงล้มเหลว
  void _logDebugInfo(BuildContext context) {
    debugPrint('📋 Navigation Debug Info:');
    debugPrint('   Widget: ${context.widget.runtimeType}');
    debugPrint('   Mounted: ${context.mounted}');
    debugPrint('   Has Scaffold: ${Scaffold.maybeOf(context) != null}');
    debugPrint('   Has Navigator: ${Navigator.maybeOf(context) != null}');
    debugPrint('   Has Material App: ${context.findAncestorWidgetOfExactType<MaterialApp>() != null}');
  }
}

// ============================================
// สรุปการใช้งาน Navigation Handler
// ============================================
//
// 1. **สร้าง Handler Instance:**
//    ```dart
//    final handler = BaseMiniAppNavigationHandler(
//      moduleId: 'payment_module',
//      displayName: 'Payment',
//    );
//    ```
//
// 2. **ใช้ใน Widget (เช่น ปุ่ม):**
//    ```dart
//    ElevatedButton(
//      onPressed: () {
//        handler.navigateToMiniApp(
//          context: context,
//          targetRoute: '/checkout',
//          extraData: {'orderId': '12345'},
//          onPressed: () => analytics.track('payment_clicked'),
//        );
//      },
//      child: Text('Go to Payment'),
//    )
//    ```
//
// 3. **สร้าง Custom Handler:**
//    ```dart
//    class CustomNavigationHandler extends BaseMiniAppNavigationHandler {
//      CustomNavigationHandler() : super(
//        moduleId: 'custom',
//        displayName: 'Custom Module',
//      );
//
//      @override
//      void navigateToMiniApp({...}) {
//        // Custom logic
//        super.navigateToMiniApp(...);
//      }
//    }
//    ```
//
// Handler นี้จัดการ navigation logic ทั้งหมด
// พร้อม error handling และ debugging features
// ทำให้การ navigate ระหว่าง modules เป็นไปอย่างราบรื่น
