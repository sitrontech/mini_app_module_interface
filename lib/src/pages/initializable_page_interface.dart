// ===============================================
// lib/src/pages/initializable_page_interface.dart
// ===============================================
//
// ไฟล์นี้กำหนด interfaces และ mixins สำหรับ pages ที่ต้องการ
// initialization callbacks และ configuration management
// ใช้สำหรับ pages ที่ต้องมีการ setup หรือ loading ก่อนแสดงผล
// เช่น splash screens, loading pages, หรือ pages ที่ต้อง fetch data

import 'dart:async';

import 'package:flutter/material.dart';

// ============================================
// Abstract Interfaces
// ============================================

/// Generic interface สำหรับ page ที่ต้องการ initialization callback
///
/// Interface นี้กำหนดโครงสร้างสำหรับ pages ที่ต้องการ:
/// 1. แจ้ง host/parent เมื่อ initialization เสร็จ
/// 2. สร้าง instance ใหม่พร้อม callback
///
/// Use cases:
/// - Splash screens ที่ต้องแจ้งเมื่อ animation เสร็จ
/// - Loading pages ที่ต้องแจ้งเมื่อ data โหลดเสร็จ
/// - Setup pages ที่ต้องแจ้งเมื่อ configuration เสร็จ
///
/// ตัวอย่างการ implement:
/// ```dart
/// class MySplashPage implements InitializablePage {
///   final VoidCallback? onInitialized;
///
///   MySplashPage({this.onInitialized});
///
///   @override
///   Widget createWithInitializationCallback(VoidCallback onInitialized) {
///     return MySplashPage(onInitialized: onInitialized);
///   }
/// }
/// ```
abstract class InitializablePage {
  /// Callback ที่จะถูกเรียกเมื่อ page initialization เสร็จ
  ///
  /// Callback นี้ใช้สำหรับ:
  /// - แจ้ง parent/host ว่า page พร้อมแล้ว
  /// - Trigger การ navigate ไปหน้าถัดไป
  /// - Update state ของ parent widget
  ///
  /// เป็น nullable เพื่อให้ page สามารถทำงานได้
  /// แม้ไม่มี callback (standalone mode)
  VoidCallback? get onInitialized;

  /// สร้าง page instance ใหม่พร้อม initialization callback
  ///
  /// Method นี้ใช้สำหรับสร้าง page instance ใหม่
  /// โดยส่ง callback เข้าไปใน constructor
  ///
  /// Parameters:
  /// - [onInitialized]: Callback ที่จะถูกเรียกเมื่อ initialization เสร็จ
  ///
  /// Returns:
  /// Widget instance ของ page พร้อม callback
  ///
  /// Pattern นี้ช่วยให้:
  /// - Parent สามารถ inject callback ได้
  /// - Page สามารถทำงานแบบ standalone ได้
  /// - ง่ายต่อการ test
  Widget createWithInitializationCallback(VoidCallback onInitialized);
}

/// Interface สำหรับ page ที่สามารถ configure ได้
///
/// Interface นี้กำหนดโครงสร้างสำหรับ pages ที่ต้องการ:
/// 1. รับ configuration จาก host/parent
/// 2. รับ event callbacks จาก host
///
/// Use cases:
/// - Pages ที่ต้องการ theme configuration
/// - Pages ที่ต้องการ user data
/// - Pages ที่ต้องการ communicate กับ host
///
/// ตัวอย่างการ implement:
/// ```dart
/// class MyConfigurablePage implements ConfigurablePage {
///   @override
///   final PageConfig config;
///
///   @override
///   final Function(String, dynamic)? onHostEvent;
///
///   MyConfigurablePage({
///     required this.config,
///     this.onHostEvent,
///   });
/// }
/// ```
abstract class ConfigurablePage {
  /// Configuration object ของ page
  ///
  /// ใช้ dynamic type เพื่อความยืดหยุ่น
  /// แต่ละ page สามารถกำหนด config type ของตัวเองได้
  ///
  /// ตัวอย่าง config types:
  /// - Map<String, dynamic> สำหรับ flexible config
  /// - Custom class สำหรับ type-safe config
  /// - String/int สำหรับ simple config
  ///
  /// Config อาจประกอบด้วย:
  /// - Theme settings
  /// - User preferences
  /// - API endpoints
  /// - Feature flags
  get config;

  /// Callback สำหรับรับ events จาก host
  ///
  /// ใช้ dynamic type เพื่อความยืดหยุ่นในการกำหนด
  /// function signature ตาม use case
  ///
  /// ตัวอย่าง signatures:
  /// - void Function(String event, Map data)
  /// - void Function(HostEvent event)
  /// - Stream<Event> get eventStream
  ///
  /// Events ที่อาจได้รับ:
  /// - Navigation events
  /// - Data updates
  /// - State changes
  /// - User actions
  get onHostEvent;
}

/// Interface รวมสำหรับ page ที่ทั้ง initializable และ configurable
///
/// Interface นี้รวมความสามารถของทั้ง:
/// - InitializablePage: จัดการ initialization callbacks
/// - ConfigurablePage: รับ configuration และ events
///
/// เหมาะสำหรับ pages ที่ซับซ้อนซึ่งต้องการทั้ง:
/// 1. Configuration จาก host
/// 2. Initialization callbacks
/// 3. Event communication
///
/// ตัวอย่างการใช้:
/// ```dart
/// class MyComplexPage extends StatefulWidget implements MiniAppPageBase {
///   @override
///   final VoidCallback? onInitialized;
///
///   @override
///   final PageConfig config;
///
///   @override
///   final Function(String, dynamic)? onHostEvent;
///
///   MyComplexPage({
///     this.onInitialized,
///     required this.config,
///     this.onHostEvent,
///   });
///
///   @override
///   Widget createWithInitializationCallback(VoidCallback onInitialized) {
///     return MyComplexPage(
///       onInitialized: onInitialized,
///       config: config,
///       onHostEvent: onHostEvent,
///     );
///   }
/// }
/// ```
abstract class MiniAppPageBase implements InitializablePage, ConfigurablePage {}

// ============================================
// Mixins for Common Behaviors
// ============================================

/// Mixin สำหรับ pages ที่ต้องการ initialization handling
///
/// Mixin นี้ provide method สำเร็จรูปสำหรับจัดการ
/// initialization callback พร้อม delay และ logging
///
/// Features:
/// - Configurable delay
/// - Automatic callback execution
/// - Debug logging
/// - Post-frame callback handling
///
/// การใช้งาน:
/// ```dart
/// class MySplashPageState extends State<MySplashPage>
///     with PageInitializationMixin {
///
///   @override
///   void initState() {
///     super.initState();
///     handlePageInitialization(
///       onInitialized: widget.onInitialized,
///       initializationDelay: Duration(seconds: 2),
///       pageName: 'Splash Screen',
///     );
///   }
/// }
/// ```
mixin PageInitializationMixin {
  /// จัดการ page initialization พร้อม callback
  ///
  /// Method นี้จะ:
  /// 1. รอให้ frame แรกถูก render (post-frame callback)
  /// 2. Delay ตามที่กำหนด (สำหรับ animation/loading)
  /// 3. เรียก initialization callback
  /// 4. Log การทำงานสำหรับ debugging
  ///
  /// Parameters:
  /// - [onInitialized]: Callback ที่จะเรียกเมื่อ initialization เสร็จ (nullable)
  /// - [initializationDelay]: ระยะเวลา delay ก่อนเรียก callback (default: 1.5 วินาที)
  /// - [pageName]: ชื่อ page สำหรับ logging (optional)
  ///
  /// การทำงาน:
  /// 1. ใช้ addPostFrameCallback เพื่อรอให้ UI render เสร็จ
  /// 2. Delay เพื่อให้ animations/loading ทำงาน
  /// 3. เรียก callback และ log
  ///
  /// Use cases:
  /// - Splash screens ที่ต้องแสดง animation
  /// - Loading screens ที่ต้องแสดง progress
  /// - Setup screens ที่ต้อง initialize resources
  void handlePageInitialization({
    required VoidCallback? onInitialized,
    Duration initializationDelay = const Duration(milliseconds: 1500),
    String? pageName,
  }) {
    // รอให้ frame แรกถูก render เสร็จ
    // ป้องกันการเรียก callback ก่อน UI พร้อม
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Delay ตามที่กำหนด
      // ใช้สำหรับ animations หรือ minimum display time
      Future.delayed(initializationDelay, () {
        // Log การ initialization สำเร็จ
        debugPrint('🎉 ${pageName ?? "Page"} initialization completed');

        // เรียก callback ถ้ามี
        // ใช้ ?. operator เพื่อจัดการ null case
        onInitialized?.call();
      });
    });
  }
}

/// Mixin สำหรับ loading pages (splash, loading screens, etc.)
///
/// Mixin นี้ provide method สำเร็จรูปสำหรับจัดการ
/// loading state พร้อม progress updates
///
/// Features:
/// - Simulated progress updates
/// - Configurable loading duration
/// - Progress callbacks
/// - Loading message support
///
/// การใช้งาน:
/// ```dart
/// class MyLoadingPageState extends State<MyLoadingPage>
///     with LoadingPageMixin {
///
///   double _progress = 0;
///
///   @override
///   void initState() {
///     super.initState();
///     handleLoadingState(
///       onLoadingComplete: () => Navigator.pushReplacement(...),
///       loadingDuration: Duration(seconds: 3),
///       loadingMessage: 'Loading resources...',
///       onProgressUpdate: () {
///         setState(() {
///           _progress += 0.25;
///         });
///       },
///     );
///   }
/// }
/// ```
mixin LoadingPageMixin {
  /// จัดการ loading state พร้อม progress updates
  ///
  /// Method นี้จะ:
  /// 1. Simulate loading progress
  /// 2. เรียก progress callbacks เป็นระยะ
  /// 3. เรียก completion callback เมื่อเสร็จ
  /// 4. Log loading states
  ///
  /// Parameters:
  /// - [onLoadingComplete]: Callback เมื่อ loading เสร็จ (nullable)
  /// - [loadingDuration]: ระยะเวลา loading ทั้งหมด (default: 2 วินาที)
  /// - [loadingMessage]: ข้อความแสดงระหว่าง loading (optional)
  /// - [onProgressUpdate]: Callback สำหรับ update progress (optional)
  ///
  /// การทำงาน:
  /// 1. แบ่ง loading duration เป็น 4 ช่วง (25% each)
  /// 2. เรียก onProgressUpdate ทุกช่วง
  /// 3. เรียก onLoadingComplete เมื่อครบ 100%
  ///
  /// Progress simulation:
  /// - 0% → 25% → 50% → 75% → 100%
  /// - เรียก callback 4 ครั้ง
  /// - จบที่ completion callback
  void handleLoadingState({
    required VoidCallback? onLoadingComplete,
    Duration loadingDuration = const Duration(milliseconds: 2000),
    String? loadingMessage,
    VoidCallback? onProgressUpdate,
  }) {
    // Log เริ่ม loading
    debugPrint('🔄 Loading started: ${loadingMessage ?? "Initializing..."}');

    // รอให้ frame แรก render เสร็จ
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // คำนวณ interval สำหรับ progress updates
      // แบ่งเป็น 4 ช่วงเท่าๆ กัน (25% each)
      final progressInterval = loadingDuration.inMilliseconds ~/ 4;

      // สร้าง timer สำหรับ simulate progress
      Timer.periodic(Duration(milliseconds: progressInterval), (timer) {
        // เรียก progress update callback
        // ใช้สำหรับ update UI (progress bar, percentage, etc.)
        onProgressUpdate?.call();

        // ตรวจสอบว่าครบ 4 ticks (100%) หรือยัง
        if (timer.tick >= 4) {
          // หยุด timer
          timer.cancel();

          // Log loading เสร็จ
          debugPrint('✅ Loading completed');

          // เรียก completion callback
          onLoadingComplete?.call();
        }
      });
    });
  }
}

// ============================================
// สรุปการใช้งาน Page Interfaces และ Mixins
// ============================================
//
// **1. Simple Initializable Page:**
// ```dart
// class SimplePage extends StatefulWidget implements InitializablePage {
//   @override
//   final VoidCallback? onInitialized;
//   
//   SimplePage({this.onInitialized});
//   
//   @override
//   Widget createWithInitializationCallback(VoidCallback onInitialized) {
//     return SimplePage(onInitialized: onInitialized);
//   }
// }
// ```
//
// **2. Page with Initialization Mixin:**
// ```dart
// class SplashPageState extends State<SplashPage> 
//     with PageInitializationMixin {
//   
//   @override
//   void initState() {
//     super.initState();
//     handlePageInitialization(
//       onInitialized: widget.onInitialized,
//       pageName: 'Splash',
//     );
//   }
// }
// ```
//
// **3. Loading Page with Progress:**
// ```dart
// class LoadingPageState extends State<LoadingPage> 
//     with LoadingPageMixin {
//   
//   double progress = 0;
//   
//   @override
//   void initState() {
//     super.initState();
//     handleLoadingState(
//       onLoadingComplete: () => navigateToHome(),
//       onProgressUpdate: () {
//         setState(() => progress += 0.25);
//       },
//     );
//   }
// }
// ```
//
// Interfaces และ Mixins เหล่านี้ช่วยให้การสร้าง
// pages ที่ต้องการ initialization และ loading
// เป็นไปอย่างมีมาตรฐานและ reusable