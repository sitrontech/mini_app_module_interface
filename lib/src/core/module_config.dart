// ===============================================
// lib/src/core/module_config.dart
// A data class that carries all the necessary configuration from the host app to the module
// ===============================================
//
// ไฟล์นี้เป็น Data Model Class ที่ทำหน้าที่เก็บข้อมูล configuration ทั้งหมด
// ที่ Host Application ส่งมาให้ Mini App Module
// เปรียบเสมือน "กล่องข้อมูล" ที่บรรจุการตั้งค่าและข้อมูลที่จำเป็นทั้งหมด
// สำหรับการทำงานของ module ในบริบทของ host app

import 'package:flutter/material.dart';

import 'auth_config.dart';
import 'user_config.dart';

/// Configuration class สำหรับ mini app modules
///
/// คลาสนี้เป็น Immutable Data Class ที่ใช้เก็บข้อมูลการตั้งค่าทั้งหมด
/// ที่ module ต้องการสำหรับการทำงาน โดยข้อมูลเหล่านี้จะถูกส่งมาจาก
/// Host Application ตอนที่เริ่มต้น module
///
/// การออกแบบเป็น immutable (ค่าไม่เปลี่ยนแปลง) ทำให้มั่นใจได้ว่า
/// configuration จะไม่ถูกแก้ไขโดยไม่ตั้งใจระหว่างการทำงาน
class MiniAppModuleConfig {
  // ============================================
  // Core Properties (ข้อมูลหลัก)
  // ============================================

  /// ID เฉพาะของ module (Required)
  ///
  /// เป็นค่าที่ต้องระบุเสมอ ใช้สำหรับ:
  /// - ระบุตัวตนของ module ในระบบ
  /// - การจัดการ routing
  /// - การอ้างอิงใน logs และ analytics
  ///
  /// ตัวอย่าง: 'payment_module', 'user_profile', 'shopping_cart'
  final String moduleId;

  /// เวอร์ชันของ module
  ///
  /// ใช้สำหรับ:
  /// - ตรวจสอบความเข้ากันได้กับ host app
  /// - การจัดการ migration และ updates
  /// - การแสดงผลใน debug mode
  ///
  /// รูปแบบ: Semantic Versioning (major.minor.patch)
  /// Default: '1.0.0'
  final String version;

  /// Route เริ่มต้นเมื่อ module ถูกเปิดใช้งาน
  ///
  /// กำหนดว่า module จะแสดงหน้าไหนเป็นหน้าแรก
  /// สามารถถูก override โดย host app ได้
  ///
  /// ตัวอย่าง: '/', '/dashboard', '/login'
  /// Default: '/'
  final String initialRoute;

  /// ข้อมูลผู้ใช้งานปัจจุบัน
  ///
  /// เก็บข้อมูลของผู้ใช้ที่ login อยู่ เช่น:
  /// - 'id': User ID
  /// - 'name': ชื่อผู้ใช้
  /// - 'email': อีเมล
  /// - 'role': บทบาท (admin, user, guest)
  /// - 'preferences': การตั้งค่าส่วนตัว
  /// - 'permissions': สิทธิ์การใช้งาน
  ///
  /// Module สามารถใช้ข้อมูลนี้เพื่อ:
  /// - แสดงข้อมูลผู้ใช้
  /// - ปรับการทำงานตามสิทธิ์
  /// - Personalization
  final HostAppUser? hostAppUser;

  /// Authentication configuration จาก host app
  final HostAppAuthConfig? hostAppAuthConfig;

  /// การตั้งค่า Theme และ UI
  ///
  /// ข้อมูลสำหรับปรับแต่งหน้าตาของ module ให้สอดคล้องกับ host:
  /// - 'primaryColor': สีหลัก
  /// - 'accentColor': สีรอง
  /// - 'fontFamily': font ที่ใช้
  /// - 'fontSize': ขนาด font พื้นฐาน
  /// - 'darkMode': เปิดใช้ dark mode หรือไม่
  /// - 'borderRadius': ความโค้งของขอบ
  /// - 'spacing': ระยะห่างพื้นฐาน
  ///
  /// ทำให้ module มีหน้าตาสอดคล้องกับ host app
  final ThemeData? hostAppThemeData;
  final ThemeData? hostAppDarkThemeData;
  final ThemeMode? hostAppThemeMode;

  final Locale? hostAppLocale;

  // ============================================
  // Data Maps (ข้อมูลแบบ Map)
  // ============================================

  /// Metadata เพิ่มเติมของ module
  ///
  /// ข้อมูลทั่วไปที่ host ต้องการส่งให้ module เช่น:
  /// - 'apiEndpoint': URL ของ API server
  /// - 'environment': dev/staging/production
  /// - 'features': feature flags ที่เปิดใช้งาน
  /// - 'limits': ข้อจำกัดต่างๆ (max file size, rate limits)
  /// - 'locale': ภาษาและ locale settings
  /// - 'timezone': timezone ของผู้ใช้
  final Map<String, dynamic> metadata;

  // ============================================
  // Settings (การตั้งค่าทั่วไป)
  // ============================================

  /// เปิดใช้งาน Debug Mode
  ///
  /// เมื่อเป็น true จะ:
  /// - แสดง debug information
  /// - เปิด verbose logging
  /// - แสดง performance metrics
  /// - Enable development tools
  ///
  /// ควรเป็น false ใน production
  /// Default: false
  final bool enableDebugMode;

  /// ระยะเวลา session timeout
  ///
  /// กำหนดระยะเวลาที่ module สามารถ idle ได้
  /// ก่อนที่จะถูก timeout และต้อง re-authenticate
  ///
  /// ใช้สำหรับ:
  /// - Security (auto logout)
  /// - Resource management
  /// - Session management
  ///
  /// Default: 2 ชั่วโมง
  // final Duration sessionTimeout;

  // ============================================
  // Constructor
  // ============================================

  /// Constructor พร้อมค่า default
  ///
  /// ใช้ const constructor เพื่อ performance และ immutability
  /// moduleId เป็น parameter เดียวที่ required
  /// ที่เหลือมีค่า default ทั้งหมด
  const MiniAppModuleConfig({
    required this.moduleId, // บังคับต้องระบุ
    this.version = '1.0.0', // มีค่า default
    this.initialRoute = '/', // มีค่า default
    this.hostAppUser,
    this.hostAppAuthConfig,
    this.hostAppThemeData,
    this.hostAppDarkThemeData,
    this.hostAppThemeMode,
    this.hostAppLocale,
    this.metadata = const {}, // const empty map for performance
    this.enableDebugMode = false, // default ปิด debug
    // this.sessionTimeout = const Duration(hours: 2), // default 2 ชม.
  });

  // ============================================
  // Helper Methods - Quick Access
  // ============================================

  /// ตรวจสอบว่ามีข้อมูล accessToken หรือไม่
  ///
  /// Return: true ถ้า hostAppAuthConfig.accessToken มีข้อมูล
  /// ใช้สำหรับตรวจสอบว่า user login แล้วหรือยัง
  bool get hasAccessToken => hostAppAuthConfig!.hasAccessToken;

  /// ตรวจสอบว่ามีข้อมูล user หรือไม่
  ///
  /// Return: true ถ้า userData มีข้อมูล
  /// ใช้สำหรับตรวจสอบว่า user login แล้วหรือยัง
  bool get hasUser => hostAppUser != null;

  /// ดึง ID ผู้ใช้ (nullable)
  ///
  /// Return: User ID หรือ null ถ้าไม่มี
  /// ใช้สำหรับการอ้างอิงผู้ใช้ใน API calls
  String? get userId => hostAppUser?.id;

  // ============================================
  // Theme Helper Methods
  // ============================================

  /// ตรวจสอบว่ามี theme configuration หรือไม่
  bool get hasThemeData => hostAppThemeData != null;
  bool get hasDarkThemeData => hostAppDarkThemeData != null;
  bool get hasThemeMode => hostAppThemeMode != null;

  // ============================================
  // Localization Helper Methods
  // ============================================

  bool get hasLocale => hostAppLocale != null;

  // ============================================
  // Generic Getter Methods
  // ============================================

  /// ดึงค่าจาก metadata แบบ type-safe
  ///
  /// ใช้ Generic Type <T> เพื่อความปลอดภัยในการ cast type
  ///
  /// ตัวอย่างการใช้:
  /// ```dart
  /// String? apiUrl = config.getMetadata<String>('apiEndpoint');
  /// int? maxRetries = config.getMetadata<int>('maxRetries');
  /// List<String>? features = config.getMetadata<List<String>>('features');
  /// ```
  ///
  /// Return: ค่าที่ cast เป็น type T หรือ null
  T? getMetadata<T>(String key) => metadata[key] as T?;

  // ============================================
  // Serialization Methods
  // ============================================

  /// แปลง object เป็น JSON Map
  ///
  /// ใช้สำหรับ:
  /// - บันทึกลง storage (SharedPreferences, Database)
  /// - ส่งผ่าน network
  /// - Logging และ debugging
  ///
  /// Note: sessionTimeout แปลงเป็น milliseconds เพื่อเก็บใน JSON
  /// - ThemeData, ThemeMode, Locale ไม่ถูก serialize เพราะไม่มี built-in toJson()
  /// - ข้อมูล UI/Theme จะถูกส่งผ่าน runtime constructor แทน
  Map<String, dynamic> toJson() => {
    'moduleId': moduleId,
    'version': version,
    'initialRoute': initialRoute,
    'hostAppUser': hostAppUser?.toJson(),
    'hostAppAuthConfig': hostAppAuthConfig?.toJson(),
    'metadata': metadata,
    'enableDebugMode': enableDebugMode,
    // 'sessionTimeout': sessionTimeout.inMilliseconds, // แปลงเป็น int
    // Note: ข้าม theme/locale data - จะถูกส่งผ่าน constructor
  };

  /// สร้าง instance จาก JSON Map
  ///
  /// Factory constructor สำหรับ deserialization
  /// มีการจัดการ null safety และค่า default อย่างเหมาะสม
  ///
  /// Note: ThemeData, ThemeMode, Locale จะเป็น null เมื่อ deserialize
  /// ต้องส่งผ่าน constructor หรือ copyWith() แยกต่างหาก
  ///
  /// ตัวอย่างการใช้:
  /// ```dart
  /// final jsonString = await storage.getString('config');
  /// final json = jsonDecode(jsonString);
  /// final config = MiniAppModuleConfig.fromJson(json);
  ///
  /// // เพิ่ม theme/locale ภายหลัง
  /// final fullConfig = baseConfig.copyWith(
  ///   hostAppThemeData: currentTheme,
  ///   hostAppLocale: currentLocale,
  /// );
  /// ```
  factory MiniAppModuleConfig.fromJson(Map<String, dynamic> json) => MiniAppModuleConfig(
    moduleId: json['moduleId'] as String, // required field
    version: json['version'] as String? ?? '1.0.0', // with default
    initialRoute: json['initialRoute'] as String? ?? '/',
    hostAppUser: json['hostAppUser'] != null ? HostAppUser.fromJson(json['hostAppUser'] as Map<String, dynamic>) : null,
    hostAppAuthConfig: json['hostAppAuthConfig'] != null
        ? HostAppAuthConfig.fromJson(json['hostAppAuthConfig'] as Map<String, dynamic>)
        : null,
    // Theme/Locale จะเป็น null - ต้องตั้งค่าใหม่ภายหลัง
    metadata: json['metadata'] as Map<String, dynamic>? ?? {},
    enableDebugMode: json['enableDebugMode'] as bool? ?? false,
    // sessionTimeout: Duration(milliseconds: json['sessionTimeout'] as int? ?? 7200000),
  );

  // ============================================
  // Immutable Update Method
  // ============================================

  /// สร้าง instance ใหม่พร้อมค่าที่แก้ไข
  ///
  /// เนื่องจาก class นี้เป็น immutable (ค่าไม่เปลี่ยนแปลง)
  /// การ "แก้ไข" ค่าจะต้องสร้าง instance ใหม่แทน
  ///
  /// Pattern นี้เรียกว่า "copyWith pattern" ซึ่งเป็น
  /// best practice สำหรับ immutable objects
  ///
  /// ตัวอย่างการใช้:
  /// ```dart
  /// // สร้าง config ใหม่ที่เปลี่ยนแค่ enableDebugMode
  /// final newConfig = oldConfig.copyWith(
  ///   enableDebugMode: true,
  /// );
  ///
  /// // สร้าง config ใหม่ที่อัพเดท userData
  /// final updatedConfig = config.copyWith(
  ///   userData: {...config.userData, 'lastLogin': DateTime.now()},
  /// );
  /// ```
  ///
  /// Parameters ทั้งหมดเป็น optional
  /// ค่าที่ไม่ระบุจะใช้ค่าเดิมจาก instance ปัจจุบัน
  MiniAppModuleConfig copyWith({
    String? moduleId,
    String? version,
    String? initialRoute,
    HostAppUser? hostAppUser,
    HostAppAuthConfig? hostAppAuthConfig,
    ThemeData? hostAppThemeData,
    ThemeData? hostAppDarkThemeData,
    ThemeMode? hostAppThemeMode,
    Locale? hostAppLocale,
    Map<String, dynamic>? metadata,
    bool? enableDebugMode,
    // Duration? sessionTimeout,
  }) => MiniAppModuleConfig(
    moduleId: moduleId ?? this.moduleId,
    version: version ?? this.version,
    initialRoute: initialRoute ?? this.initialRoute,
    hostAppUser: hostAppUser ?? this.hostAppUser,
    hostAppAuthConfig: hostAppAuthConfig ?? this.hostAppAuthConfig,
    metadata: metadata ?? this.metadata,
    hostAppThemeData: hostAppThemeData ?? this.hostAppThemeData,
    hostAppDarkThemeData: hostAppDarkThemeData ?? this.hostAppDarkThemeData,
    hostAppThemeMode: hostAppThemeMode ?? this.hostAppThemeMode,
    hostAppLocale: hostAppLocale ?? this.hostAppLocale,
    enableDebugMode: enableDebugMode ?? this.enableDebugMode,
    // sessionTimeout: sessionTimeout ?? this.sessionTimeout,
  );
}

// ============================================
// สรุปการใช้งาน MiniAppModuleConfig
// ============================================
//
// 1. **การสร้าง Config จาก Host App:**
//    ```dart
//    final config = MiniAppModuleConfig(
//      moduleId: 'payment',
//      userData: {'id': '123', 'name': 'John'},
//      metadata: {'apiUrl': 'https://api.example.com'},
//      enableDebugMode: true,
//    );
//    ```
//
// 2. **การส่ง Config ให้ Module:**
//    ```dart
//    PaymentModule(config: config)
//    ```
//
// 3. **การใช้งานใน Module:**
//    ```dart
//    class PaymentModule extends MiniAppModuleBase {
//      void someMethod() {
//        final userName = config.userName ?? 'Guest';
//        final apiUrl = config.getMetadata<String>('apiUrl');
//        if (config.enableDebugMode) {
//          print('Debug: Calling API at $apiUrl');
//        }
//      }
//    }
//    ```
//
// คลาสนี้ทำให้การส่งผ่านข้อมูลระหว่าง Host และ Module
// เป็นไปอย่างมีระเบียบ type-safe และง่ายต่อการจัดการ
