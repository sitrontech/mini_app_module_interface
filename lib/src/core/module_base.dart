// ===============================================
// lib/src/core/module_base.dart
// The foundational class for all modules
// It's a StatefulWidget that provides a standard structure and lifecycle management for a module's UI
// ===============================================

import 'package:flutter/material.dart';

import 'host_communication.dart';
import 'module_config.dart';
import 'module_lifecycle.dart';

/// Base class for all modules
abstract class MiniAppModuleBase extends StatefulWidget {
  // พารามิเตอร์ที่จำเป็นสำหรับทุกโมดูล มันทำหน้าที่เก็บข้อมูลการตั้งค่าทั้งหมดที่แอปพลิเคชันหลักส่งมาให้โมดูล เช่น ID ของโมดูล ข้อมูลผู้ใช้ และการตั้งค่าธีม
  final MiniAppModuleConfig config;

  // callback ที่ให้โมดูลสามารถรับฟังและจัดการกับเหตุการณ์ต่างๆ ที่แอปพลิเคชันหลักส่งมาได้
  final void Function(String eventType, Map<String, dynamic> data)? onHostEvent;

  const MiniAppModuleBase({super.key, required this.config, this.onHostEvent});

  /// Create the main widget for this module
  /// เมธอดที่โมดูลจะต้อง override เพื่อสร้างและคืนค่าโครงสร้าง UI หลักของตัวเอง
  Widget buildModule(BuildContext context);

  /// Module metadata
  /// เมธอดนี้ใช้เพื่อระบุข้อมูลเมตาดาต้าของโมดูล เช่น ชื่อและเวอร์ชัน
  Map<String, dynamic> get moduleMetadata;

  /// Required permissions
  List<String> get requiredPermissions => [];

  /// Can this module activate with current config?
  /// เมธอดที่ใช้ตรวจสอบว่าโมดูลสามารถเริ่มต้นทำงานได้หรือไม่ โดยค่าเริ่มต้นจะคืนค่า true แต่สามารถเขียนทับเพื่อเพิ่มเงื่อนไขได้ เช่น การตรวจสอบว่ามีข้อมูลผู้ใช้หรือไม่
  bool canActivate() => true;

  @override
  State<MiniAppModuleBase> createState() => _MiniAppModuleBaseState();
}

// มีการใช้ MiniAppModuleLifecycleMixin เพื่อจัดการวงจรชีวิตของโมดูล ทำให้มั่นใจได้ว่าการสื่อสารกับแอปพลิเคชันหลักจะเกิดขึ้นอย่างถูกต้องในแต่ละช่วงเวลา เช่น เมื่อโมดูลเริ่มต้นหรือถูกทำลาย
class _MiniAppModuleBaseState extends State<MiniAppModuleBase> with MiniAppModuleLifecycleMixin {
  @override
  void onModuleInit() {
    HostCommunicationService.initialize(moduleId: widget.config.moduleId, onEvent: widget.onHostEvent);
  }

  @override
  void onModuleDispose() {
    HostCommunicationService.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.canActivate()) {
      return _buildErrorWidget('Module cannot activate with current configuration');
    }

    try {
      return widget.buildModule(context);
    } catch (error, stackTrace) {
      HostCommunicationService.reportError(error.toString(), 'module_build', stackTrace);
      return _buildErrorWidget('Error building module: $error');
    }
  }

  Widget _buildErrorWidget(String message) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Error - ${widget.config.moduleId}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => HostCommunicationService.requestClose(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: () => HostCommunicationService.requestClose(), child: const Text('Go Back')),
          ],
        ),
      ),
    );
  }
}

// คลาสหลักที่ใช้สร้างโมดูล (mini-app) ทั้งหมดในไลบรารี mini_app_module_interface 
// มันถูกออกแบบมาเพื่อเป็น StatefulWidget พื้นฐานที่จัดการวงจรชีวิตและการสื่อสารกับแอปพลิเคชันหลัก (host app) โดยอัตโนมัติ 
// โมดูลแต่ละตัวจะต้องสืบทอด (inherit) คลาสนี้เพื่อใช้งาน
// เมธอด build ของ MiniAppModuleBase มีการใช้ try-catch block เพื่อดักจับข้อผิดพลาดที่อาจเกิดขึ้นระหว่างการสร้าง UI ของโมดูล 
// หากเกิดข้อผิดพลาดขึ้น มันจะส่งรายงานไปยังแอปพลิเคชันหลักผ่าน HostCommunicationService และแสดงหน้าจอข้อผิดพลาดมาตรฐานแทน ซึ่งช่วยป้องกันไม่ให้แอปพลิเคชันหลักเสียหายจากการทำงานผิดพลาดของโมดูล