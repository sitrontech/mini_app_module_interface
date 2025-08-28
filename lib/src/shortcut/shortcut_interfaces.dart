// ===============================================
// lib/src/shortcut/shortcut_interfaces.dart
// SIMPLIFIED SHORTCUT INTERFACES WITH ENFORCED NAVIGATION
// ===============================================
//
// ไฟล์นี้กำหนด interfaces และ implementations สำหรับสร้าง
// shortcut widgets ที่ใช้ navigate ไปยัง mini apps
// มีการบังคับใช้ navigation handler เพื่อความเป็นมาตรฐาน
// และรองรับทั้ง default buttons และ custom widgets

import 'package:flutter/material.dart';

import '../core/module_config.dart';
import '../navigation/navigation_handler.dart';

// ============================================
// Main Shortcut Provider Interface
// ============================================

/// Main interface สำหรับ Mini App ที่รองรับ Shortcut Widgets
///
/// Interface นี้กำหนดโครงสร้างที่ mini app ต้องมี
/// เพื่อให้สามารถสร้าง shortcut widgets ได้
///
/// ✅ จุดเด่น: บังคับให้ใช้ BaseMiniAppNavigationHandler
/// เพื่อให้มั่นใจว่าทุก shortcut มี navigation ที่เป็นมาตรฐาน
///
/// การ implement interface นี้ทำให้ mini app:
/// 1. สามารถสร้าง shortcut buttons ได้
/// 2. มี navigation handler ที่พร้อมใช้งาน
/// 3. สามารถ customize การแสดงผลได้
///
/// ตัวอย่างการ implement:
/// ```dart
/// class PaymentModule implements MiniAppShortcutProvider {
///   @override
///   String get moduleId => 'payment';
///
///   @override
///   MiniAppNavigationHandler get navigationHandler =>
///     BaseMiniAppNavigationHandler(
///       moduleId: moduleId,
///       displayName: displayName
///     );
///
///   // ... implement other required methods
/// }
/// ```
abstract class MiniAppShortcutProvider {
  // ============================================
  // Module Information Properties
  // ============================================

  /// Module ID ที่ unique ในระบบ
  ///
  /// ใช้สำหรับ:
  /// - ระบุ target module ใน navigation
  /// - Logging และ debugging
  /// - การจัดการ routing
  // String get moduleId;

  /// Path หลักของ module
  ///
  /// Route path ที่ใช้ navigate ไป module
  /// ตัวอย่าง: '/payment', '/profile'
  // String get modulePath;

  /// ชื่อที่แสดงให้ผู้ใช้เห็น
  ///
  /// ใช้สำหรับ:
  /// - Label ของ shortcut button
  /// - Title ใน dialogs
  /// - User-facing messages
  String get displayName;

  /// Icon default ของ module
  ///
  /// Icon ที่จะใช้เมื่อไม่ได้ระบุ icon เฉพาะ
  /// ตัวอย่าง: Icons.payment, Icons.person
  IconData get defaultIcon;

  /// Routes ที่มีภายใน module
  ///
  /// Map ของ routes ทั้งหมดใน module
  /// Key = route name, Value = route path
  ///
  /// ตัวอย่าง:
  /// ```dart
  /// {
  ///   'home': '/payment/home',
  ///   'history': '/payment/history',
  ///   'settings': '/payment/settings'
  /// }
  /// ```
  // Map<String, String> get availableRoutes;

  // ============================================
  // Navigation Handler (Required)
  // ============================================

  /// ✅ บังคับให้ implement navigation handler
  ///
  /// ทุก module ต้องมี navigation handler
  /// เพื่อจัดการการ navigate อย่างเป็นมาตรฐาน
  ///
  /// Handler นี้จะจัดการ:
  /// - การหา navigation service
  /// - Error handling
  /// - Debug logging
  /// - User feedback
  MiniAppNavigationHandler get navigationHandler;

  // ============================================
  // Shortcut Creation Methods
  // ============================================

  /// สร้าง default shortcut button
  ///
  /// Method นี้สร้าง button มาตรฐานพร้อม icon และ label
  /// สามารถ customize style ได้ผ่าน parameters
  ///
  /// Parameters:
  /// - [title]: ข้อความบน button (default: displayName)
  /// - [icon]: Icon ที่แสดง (default: defaultIcon)
  /// - [targetRoute]: Route ภายใน module ที่จะ navigate ไป
  /// - [extraData]: ข้อมูลเพิ่มเติมที่ส่งไปกับ navigation
  /// - [onPressed]: Callback ก่อน navigation
  /// - [style]: Style configuration สำหรับ button
  ///
  /// Returns:
  /// Widget ของ button ที่พร้อมใช้งาน
  Widget createDefaultShortcutButton({
    String? title,
    IconData? icon,
    String? targetRoute,
    Map<String, dynamic>? extraData,
    VoidCallback? onPressed,
    ShortcutStyle? style,
  });

  /// สร้าง custom shortcut button ด้วย widget ที่กำหนดเอง
  ///
  /// Method นี้ให้ความยืดหยุ่นในการออกแบบ UI
  /// โดยรับ custom widget และเพิ่ม navigation behavior
  ///
  /// Parameters:
  /// - [child]: Custom widget ที่จะใช้เป็น button
  /// - [targetRoute]: Route ภายใน module
  /// - [extraData]: ข้อมูลเพิ่มเติม
  /// - [onPressed]: Callback ก่อน navigation
  ///
  /// Returns:
  /// Custom widget พร้อม navigation behavior
  Widget createCustomShortcutButton({
    required Widget child,
    String? targetRoute,
    Map<String, dynamic>? extraData,
    VoidCallback? onPressed,
  });
}

// ============================================
// Base Implementation
// ============================================

/// ✅ Base implementation ที่บังคับใช้ BaseMiniAppNavigationHandler
///
/// Abstract class นี้ provide implementation พื้นฐาน
/// สำหรับ MiniAppShortcutProvider โดย:
/// 1. Implement navigation handler อัตโนมัติ
/// 2. Provide helper methods สำหรับ navigation
/// 3. Implement default และ custom button creation
///
/// Mini apps สามารถ extend class นี้เพื่อได้
/// functionality พื้นฐานโดยไม่ต้องเขียนเอง
///
/// ตัวอย่างการใช้:
/// ```dart
/// class PaymentShortcutProvider extends BaseMiniAppShortcutProvider {
///   @override
///   String get moduleId => 'payment';
///
///   @override
///   String get displayName => 'Payment';
///
///   // ได้ navigation handler และ button creation ฟรี!
/// }
/// ```
abstract class BaseMiniAppShortcutProvider implements MiniAppShortcutProvider {
  final MiniAppModuleConfig config;

  BaseMiniAppShortcutProvider({required this.config});

  // ✅ Concrete implementation ของ displayName
  @override
  String get displayName {
    // ลองหาจาก metadata หลายแหล่ง
    final sources = [config.metadata['name'], config.metadata['displayName'], config.metadata['title']];

    for (final source in sources) {
      if (source is String && source.trim().isNotEmpty) {
        return source.trim();
      }
    }

    // fallback เป็น moduleId (แปลงเป็น user-friendly)
    return config.moduleId;
  }

  @override
  IconData get defaultIcon {
    final iconFromMetadata = config.defaultIcon;
    return iconFromMetadata ?? Icons.apps; // รับประกันว่าจะไม่เป็น null
  }

  /// ✅ Default navigation handler implementation
  ///
  /// Provide navigation handler อัตโนมัติ
  /// โดยใช้ BaseMiniAppNavigationHandler
  ///
  /// Subclasses สามารถ override เพื่อใช้ custom handler
  /// แต่ต้องเป็น subclass ของ MiniAppNavigationHandler
  @override
  MiniAppNavigationHandler get navigationHandler =>
      BaseMiniAppNavigationHandler(moduleId: config.moduleId, displayName: displayName);

  /// ✅ Protected method สำหรับ navigation (ใช้ navigationHandler เท่านั้น)
  ///
  /// Helper method ที่รวม logic การ navigation
  /// ใช้ @protected เพื่อให้เรียกได้เฉพาะใน subclasses
  ///
  /// การทำงาน:
  /// 1. เรียก onPressed callback (ถ้ามี)
  /// 2. ใช้ navigationHandler ในการ navigate
  ///
  /// Parameters:
  /// - [context]: BuildContext สำหรับ navigation
  /// - [targetRoute]: Route ภายใน module
  /// - [extraData]: ข้อมูลเพิ่มเติม
  /// - [onPressed]: Callback ก่อน navigation
  @protected
  void navigateToMiniApp(
    BuildContext context, {
    String? targetRoute,
    Map<String, dynamic>? extraData,
    VoidCallback? onPressed,
  }) {
    // เรียก callback ก่อน (สำหรับ analytics, state update, etc.)
    onPressed?.call();

    // ใช้ navigation handler ในการ navigate
    // Handler จะจัดการ error และ logging
    navigationHandler.navigateToMiniApp(context: context, targetRoute: targetRoute, extraData: extraData);
  }

  /// ✅ Default shortcut button implementation
  ///
  /// สร้าง button มาตรฐานพร้อม icon และ label
  /// ใช้ Builder เพื่อให้มี context สำหรับ navigation
  ///
  /// Features:
  /// - ใช้ค่า default จาก module properties
  /// - Support ทั้ง ElevatedButton และ OutlinedButton
  /// - Customizable ผ่าน ShortcutStyle
  @override
  Widget createDefaultShortcutButton({
    String? title,
    IconData? icon,
    String? targetRoute,
    Map<String, dynamic>? extraData,
    VoidCallback? onPressed,
    ShortcutStyle? style,
  }) {
    // ใช้ Builder เพื่อได้ context ที่ถูกต้อง
    return Builder(
      builder: (context) {
        return _buildDefaultButton(
          context,
          title: title ?? displayName, // ใช้ displayName ถ้าไม่ระบุ title
          icon: icon ?? defaultIcon, // ใช้ defaultIcon ถ้าไม่ระบุ icon
          targetRoute: targetRoute,
          extraData: extraData,
          onPressed: onPressed,
          style: style ?? const ShortcutStyle(),
        );
      },
    );
  }

  /// ✅ Custom shortcut button with user-provided widget
  ///
  /// Wrap custom widget ด้วย GestureDetector
  /// เพื่อเพิ่ม tap behavior สำหรับ navigation
  ///
  /// ให้ flexibility สูงสุดในการออกแบบ UI
  /// แต่ยังคง navigation behavior มาตรฐาน
  @override
  Widget createCustomShortcutButton({
    required Widget child,
    String? targetRoute,
    Map<String, dynamic>? extraData,
    VoidCallback? onPressed,
  }) {
    // ใช้ Builder เพื่อได้ context
    return Builder(
      builder: (context) {
        // Wrap child widget ด้วย GestureDetector
        return GestureDetector(
          onTap: () => navigateToMiniApp(context, targetRoute: targetRoute, extraData: extraData, onPressed: onPressed),
          child: child, // Custom widget จาก user
        );
      },
    );
  }

  /// ✅ Internal default button builder
  ///
  /// Private method สำหรับสร้าง button widget จริง
  /// Support 2 styles:
  /// 1. ElevatedButton - มี background color
  /// 2. OutlinedButton - transparent background
  ///
  /// การเลือก style:
  /// - ถ้า backgroundColor = transparent → OutlinedButton
  /// - อื่นๆ → ElevatedButton
  Widget _buildDefaultButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    String? targetRoute,
    Map<String, dynamic>? extraData,
    VoidCallback? onPressed,
    required ShortcutStyle style,
  }) {
    // ตรวจสอบว่าเป็น outlined style หรือไม่
    final isOutlined = style.backgroundColor == Colors.transparent;

    // กำหนดสีพื้นฐาน
    final backgroundColor = style.backgroundColor ?? Colors.blue;
    final textColor = style.textColor ?? Colors.white;

    // สร้าง OutlinedButton ถ้า background transparent
    if (isOutlined) {
      return OutlinedButton.icon(
        onPressed: () =>
            navigateToMiniApp(context, targetRoute: targetRoute, extraData: extraData, onPressed: onPressed),
        style: OutlinedButton.styleFrom(
          foregroundColor: textColor, // สีข้อความและ icon
          side: BorderSide(color: textColor), // สีขอบ
          padding: EdgeInsets.symmetric(vertical: (style.height ?? 40) / 5, horizontal: 12), // คำนวณ padding จาก height
          shape: RoundedRectangleBorder(borderRadius: style.borderRadius ?? BorderRadius.circular(8)),
        ),
        icon: Icon(icon, size: 16),
        label: Text(title, style: const TextStyle(fontSize: 12)),
      );
    }

    // สร้าง ElevatedButton สำหรับ style ปกติ
    return ElevatedButton.icon(
      onPressed: () => navigateToMiniApp(context, targetRoute: targetRoute, extraData: extraData, onPressed: onPressed),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor, // สีพื้นหลัง
        foregroundColor: textColor, // สีข้อความและ icon
        padding: EdgeInsets.symmetric(vertical: (style.height ?? 40) / 5, horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: style.borderRadius ?? BorderRadius.circular(8)),
      ),
      icon: Icon(icon, size: 16),
      label: Text(title, style: const TextStyle(fontSize: 12)),
    );
  }
}

// ============================================
// Style Configuration
// ============================================

/// Shortcut styling configuration
///
/// Class สำหรับกำหนด style ของ shortcut buttons
/// ทุก property เป็น optional เพื่อความยืดหยุ่น
///
/// Properties:
/// - [backgroundColor]: สีพื้นหลัง (transparent = OutlinedButton)
/// - [textColor]: สีข้อความและ icon
/// - [width]: ความกว้างของ button
/// - [height]: ความสูงของ button
/// - [padding]: padding ภายใน button
/// - [borderRadius]: ความโค้งของขอบ
///
/// ตัวอย่างการใช้:
/// ```dart
/// ShortcutStyle(
///   backgroundColor: Colors.blue,
///   textColor: Colors.white,
///   height: 48,
///   borderRadius: BorderRadius.circular(12),
/// )
/// ```
class ShortcutStyle {
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const ShortcutStyle({this.backgroundColor, this.textColor, this.width, this.height, this.padding, this.borderRadius});
}

// ============================================
// สรุปการใช้งาน Shortcut Interfaces
// ============================================
//
// **1. Implement Provider:**
// ```dart
// class PaymentModule extends BaseMiniAppShortcutProvider {
//   @override
//   String get moduleId => 'payment';
//   
//   @override
//   String get displayName => 'Payment';
//   
//   @override
//   IconData get defaultIcon => Icons.payment;
// }
// ```
//
// **2. Create Default Button:**
// ```dart
// final button = module.createDefaultShortcutButton(
//   title: 'Pay Now',
//   targetRoute: '/checkout',
//   style: ShortcutStyle(
//     backgroundColor: Colors.green,
//   ),
// );
// ```
//
// **3. Create Custom Button:**
// ```dart
// final custom = module.createCustomShortcutButton(
//   child: Card(
//     child: ListTile(
//       leading: Icon(Icons.payment),
//       title: Text('Payment'),
//     ),
//   ),
//   targetRoute: '/home',
// );
// ```
//
// System นี้ทำให้การสร้าง shortcuts มีมาตรฐาน