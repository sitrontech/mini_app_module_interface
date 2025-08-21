// ===============================================
// lib/src/base/mini_app_base.dart
// MINI APP BASE CLASS
// ===============================================
//
// ไฟล์นี้เป็น Base Class หลักสำหรับสร้าง Mini App Module
// ทำหน้าที่เป็นพื้นฐานที่ Mini App ทุกตัวต้อง extends มาใช้งาน
// โดยมีการกำหนดโครงสร้างและ interface ที่จำเป็นสำหรับการทำงานร่วมกับ Host App

import 'package:flutter/material.dart';
import '../core/module_config.dart';
import '../core/host_communication.dart';
import '../core/module_lifecycle.dart';

/// Base class สำหรับ mini app modules ทั้งหมด
///
/// คลาสนี้เป็น abstract class ที่กำหนดโครงสร้างพื้นฐานและ interface
/// ที่ mini app ทุกตัวต้องมี เพื่อให้สามารถทำงานในระบบ modular ได้อย่างถูกต้อง
///
/// Mini app ที่สร้างขึ้นจะต้อง extends คลาสนี้และ implement method ที่จำเป็น
abstract class MiniAppModuleBase extends StatefulWidget {
  // ============================================
  // Properties และ Configuration
  // ============================================

  /// Configuration object ที่เก็บข้อมูลการตั้งค่าทั้งหมดของ module
  ///
  /// [config] จะถูกส่งมาจาก Host Application และประกอบด้วย:
  /// - moduleId: รหัสประจำตัวของ module
  /// - userData: ข้อมูลผู้ใช้งาน (ถ้ามี)
  /// - theme: การตั้งค่าธีมของแอป
  /// - apiEndpoints: endpoints สำหรับเชื่อมต่อ API
  /// - permissions: สิทธิ์ที่ module ได้รับอนุญาต
  /// - additionalConfig: การตั้งค่าเพิ่มเติมอื่นๆ
  final MiniAppModuleConfig config;

  /// Callback function สำหรับรับ event จาก Host Application
  ///
  /// [onHostEvent] เป็น optional callback ที่ใช้สำหรับ:
  /// - รับการแจ้งเตือนจาก host (notifications)
  /// - รับคำสั่งควบคุมจาก host (commands)
  /// - รับข้อมูลที่ host ส่งมาให้ (data updates)
  ///
  /// Parameters:
  /// - String: ชื่อ event ที่เกิดขึ้น
  /// - Map<String, dynamic>: ข้อมูลที่มากับ event
  ///
  /// หาก onHostEvent เป็น null แสดงว่า module กำลังทำงานใน standalone mode
  final void Function(String, Map<String, dynamic>)? onHostEvent;

  const MiniAppModuleBase({super.key, required this.config, this.onHostEvent});

  // ============================================
  // Abstract Methods ที่ต้อง implement
  // ============================================

  /// ระบุ ID เฉพาะของ module
  ///
  /// ต้องเป็น ID ที่ไม่ซ้ำกับ module อื่นในระบบ
  /// ใช้สำหรับการระบุตัวตนและการจัดการ routing
  ///
  /// ตัวอย่าง: 'payment_module', 'user_profile', 'shopping_cart'
  String get moduleId;

  /// Path หลักสำหรับ routing ไปยัง module นี้
  ///
  /// Host app จะใช้ path นี้ในการ navigate มายัง module
  /// ควรเริ่มต้นด้วย '/' และใช้ชื่อที่สื่อความหมาย
  ///
  /// ตัวอย่าง: '/payment', '/profile', '/cart'
  String get modulePath;

  /// Map ของ routes ภายใน module
  ///
  /// กำหนด routes ทั้งหมดที่มีภายใน module นี้
  /// Key = route name, Value = route path
  ///
  /// ตัวอย่าง:
  /// ```dart
  /// {
  ///   'home': '/payment/home',
  ///   'history': '/payment/history',
  ///   'settings': '/payment/settings',
  /// }
  /// ```
  Map<String, String> get availableRoutes;

  /// Metadata ของ module สำหรับแสดงข้อมูลและการตั้งค่า
  ///
  /// ควรประกอบด้วย:
  /// - name: ชื่อที่แสดงผล
  /// - version: เวอร์ชันของ module
  /// - description: คำอธิบาย
  /// - author: ผู้พัฒนา
  /// - primaryColor: สีหลัก (เป็น int value)
  /// - icon: ไอคอนของ module
  Map<String, dynamic> get moduleMetadata;

  /// รายการ permissions ที่ module ต้องการ
  ///
  /// ระบุสิทธิ์ที่จำเป็นสำหรับการทำงานของ module
  /// Host app จะตรวจสอบและอนุญาตตามความเหมาะสม
  ///
  /// ตัวอย่าง: ['camera', 'location', 'storage', 'notifications']
  List<String> get requiredPermissions;

  /// ตรวจสอบว่า module สามารถเริ่มทำงานได้หรือไม่
  ///
  /// ใช้สำหรับตรวจสอบเงื่อนไขก่อนเริ่มต้น module เช่น:
  /// - ตรวจสอบ permissions
  /// - ตรวจสอบ configuration ที่จำเป็น
  /// - ตรวจสอบ dependencies
  ///
  /// Return: true ถ้าสามารถเริ่มทำงานได้, false ถ้าไม่สามารถ
  bool canActivate();

  /// สร้าง UI หลักของ module
  ///
  /// Method นี้จะถูกเรียกเมื่อ module พร้อมแสดงผล
  /// ต้อง return Widget ที่เป็น UI หลักของ module
  ///
  /// ควรจัดการ:
  /// - การสร้าง MaterialApp หรือ widget tree หลัก
  /// - การตั้งค่า theme และ localization
  /// - การจัดการ routing ภายใน module
  Widget buildModule(BuildContext context);

  // ============================================
  // Helper Properties (มีค่า default)
  // ============================================

  /// ดึงค่าสีหลักจาก metadata
  ///
  /// จะพยายามอ่านค่า 'primaryColor' จาก moduleMetadata
  /// และแปลงเป็น Color object
  /// Return null ถ้าไม่มีการกำหนดสี
  Color? get primaryColor {
    final colorValue = moduleMetadata['primaryColor'] as int?;
    return colorValue != null ? Color(colorValue) : null;
  }

  /// ชื่อที่ใช้แสดงผลของ module
  ///
  /// จะใช้ค่าจาก metadata['name'] ถ้ามี
  /// ถ้าไม่มีจะใช้ moduleId แทน
  String get displayName => moduleMetadata['name'] ?? moduleId;

  /// ไอคอน default ของ module
  ///
  /// จะใช้ไอคอนจาก metadata['icon'] ถ้ามี
  /// ถ้าไม่มีจะใช้ Icons.apps เป็นค่า default
  IconData get defaultIcon {
    final iconData = moduleMetadata['icon'] as IconData?;
    return iconData ?? Icons.apps;
  }

  /// ตรวจสอบว่า module กำลังทำงานแบบ standalone หรือไม่
  ///
  /// Standalone mode คือการทำงานโดยไม่มี host application
  /// จะเป็น true เมื่อ onHostEvent เป็น null
  ///
  /// ใช้สำหรับ:
  /// - การทดสอบ module แยกต่างหาก
  /// - การพัฒนา module โดยไม่ต้องรัน host app
  /// - การปรับพฤติกรรมตาม mode การทำงาน
  bool get isStandaloneMode => onHostEvent == null;

  @override
  State<MiniAppModuleBase> createState() => _MiniAppModuleBaseState();
}

// ============================================
// State Class สำหรับจัดการ lifecycle
// ============================================

/// State class ที่จัดการ lifecycle และการ render ของ module
///
/// ใช้ MiniAppModuleLifecycleMixin เพื่อจัดการ:
/// - การเริ่มต้น module (initialization)
/// - การทำลาย module (disposal)
/// - การจัดการ error
/// - การสื่อสารกับ host
class _MiniAppModuleBaseState extends State<MiniAppModuleBase> with MiniAppModuleLifecycleMixin {
  /// Called เมื่อ module เริ่มต้นทำงาน
  ///
  /// จะทำการ:
  /// 1. ตรวจสอบว่ามี onHostEvent หรือไม่ (ไม่ใช่ standalone mode)
  /// 2. Initialize HostCommunicationService สำหรับการสื่อสารกับ host
  /// 3. ลงทะเบียน module กับ host
  @override
  void onModuleInit() {
    // ถ้ามี callback สำหรับรับ event จาก host
    // ให้ทำการ initialize service สำหรับการสื่อสาร
    if (widget.onHostEvent != null) {
      HostCommunicationService.initialize(
        moduleId: widget.config.moduleId, // ส่ง ID ของ module
        onEvent: widget.onHostEvent, // ส่ง callback function
      );
    }
  }

  /// Called เมื่อ module ถูกทำลาย
  ///
  /// จะทำการ:
  /// 1. ยกเลิกการลงทะเบียนกับ host
  /// 2. ทำความสะอาด resources ที่ใช้
  /// 3. ปิดการเชื่อมต่อต่างๆ
  @override
  void onModuleDispose() {
    // ถ้ามีการเชื่อมต่อกับ host
    // ให้ทำการ dispose service
    if (widget.onHostEvent != null) {
      HostCommunicationService.dispose();
    }
  }

  /// Build method หลักที่จัดการการ render module
  ///
  /// ขั้นตอนการทำงาน:
  /// 1. ตรวจสอบว่า module สามารถ activate ได้หรือไม่
  /// 2. ถ้าได้ ให้เรียก buildModule() เพื่อสร้าง UI
  /// 3. ถ้าไม่ได้ หรือเกิด error ให้แสดง error widget
  @override
  Widget build(BuildContext context) {
    // ตรวจสอบว่า module สามารถเริ่มทำงานได้หรือไม่
    if (!widget.canActivate()) {
      return _buildErrorWidget('Module cannot activate with current configuration');
    }

    // พยายามสร้าง UI ของ module
    try {
      // เรียก buildModule ที่ subclass implement ไว้
      return widget.buildModule(context);
    } catch (error, stackTrace) {
      // ถ้าเกิด error ระหว่างการสร้าง UI

      // ถ้าไม่ใช่ standalone mode ให้รายงาน error ไปยัง host
      if (widget.onHostEvent != null) {
        HostCommunicationService.reportError(
          error.toString(), // error message
          'module_build', // error type
          stackTrace, // stack trace สำหรับ debugging
        );
      }

      // แสดง error widget พร้อมข้อความ error
      return _buildErrorWidget('Error building module: $error');
    }
  }

  /// สร้าง Widget สำหรับแสดง error
  ///
  /// จะแสดง:
  /// - ไอคอน error
  /// - ข้อความ error
  /// - ปุ่ม "Go Back" (ถ้าไม่ใช่ standalone mode)
  ///
  /// [message] ข้อความ error ที่ต้องการแสดง
  Widget _buildErrorWidget(String message) {
    return MaterialApp(
      // แสดงชื่อ module ใน title bar
      title: 'Error - ${widget.config.moduleId}',
      home: Scaffold(
        // AppBar พร้อมชื่อ module
        appBar: AppBar(
          title: Text('Error - ${widget.config.moduleId}'),

          // ถ้าเป็น standalone mode จะไม่มีปุ่ม back
          // ถ้าไม่ใช่ จะมีปุ่ม back สำหรับกลับไป host
          leading: widget.isStandaloneMode
              ? null // ไม่แสดงปุ่ม back
              : IconButton(
                  icon: const Icon(Icons.arrow_back),
                  // เมื่อกดปุ่ม back จะส่ง request ให้ host ปิด module
                  onPressed: () => HostCommunicationService.requestClose(),
                ),
        ),
        // Body แสดงรายละเอียด error
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ไอคอน error ขนาดใหญ่สีแดง
              const Icon(Icons.error_outline, size: 64, color: Colors.red),

              const SizedBox(height: 16),

              // ข้อความ error
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
              ),

              const SizedBox(height: 16),

              // ปุ่ม "Go Back" (แสดงเฉพาะเมื่อไม่ใช่ standalone mode)
              if (!widget.isStandaloneMode)
                ElevatedButton(onPressed: () => HostCommunicationService.requestClose(), child: const Text('Go Back')),
            ],
          ),
        ),
      ),
    );
  }
}
