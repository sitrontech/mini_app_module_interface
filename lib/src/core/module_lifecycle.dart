// ===============================================
// lib/src/core/module_lifecycle.dart
// A mixin that provides lifecycle hooks for modules, similar to a StatefulWidget's lifecycle methods.
// It ensures that critical communication events, like ready and disposed, are automatically handled
// ===============================================

import 'package:flutter/widgets.dart';

import 'host_communication.dart';

/// Mixin for module lifecycle management
mixin MiniAppModuleLifecycleMixin<T extends StatefulWidget> on State<T> {
  // เมธอดนี้จะทำงานเมื่อโมดูลถูกสร้างขึ้นมาเป็นครั้งแรก MiniAppModuleLifecycleMixin จะเรียกใช้เมธอด onModuleInit() ของโมดูลและส่งอีเวนต์ ready ไปยังแอปพลิเคชันหลักผ่าน HostCommunicationService
  @override
  void initState() {
    super.initState();
    HostCommunicationService.sendEvent(CommunicationType.ready);
    onModuleInit();
  }

  // เมธอดนี้จะถูกเรียกเมื่อมีการเปลี่ยนแปลงค่า dependencies เช่น ข้อมูลที่ถูกส่งมาผ่าน InheritedWidget mixin จะเรียกใช้เมธอด onModuleDependenciesChanged() เพื่อให้โมดูลสามารถตอบสนองต่อการเปลี่ยนแปลงเหล่านั้นได้
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    onModuleDependenciesChanged();
  }

  // เมธอดนี้จะทำงานเมื่อโมดูลกำลังจะถูกทำลาย (เช่น เมื่อหน้าจอปิด) mixin จะเรียกใช้เมธอด onModuleDispose() และส่งอีเวนต์ disposed ไปยังแอปพลิเคชันหลัก
  @override
  void dispose() {
    onModuleDispose();
    HostCommunicationService.sendEvent(CommunicationType.disposed);
    super.dispose();
  }

  /// Override these methods in your module
  void onModuleInit() {}
  void onModuleDependenciesChanged() {}
  void onModuleDispose() {}
}

// mixin ที่ช่วยจัดการวงจรชีวิตของโมดูล (mini-app) ที่สร้างด้วยไลบรารี mini_app_module_interface มันถูกออกแบบมาเพื่อใช้กับ StatefulWidget และช่วยให้โมดูลสามารถสื่อสารสถานะของตัวเองกับแอปพลิเคชันหลัก (host app) ได้โดยอัตโนมัติ
// การสื่อสารอัตโนมัติ: mixin นี้ช่วยให้โมดูลแจ้งสถานะ ready และ disposed ให้กับแอปพลิเคชันหลักโดยไม่ต้องเขียนโค้ดเพิ่มเติม ซึ่งช่วยให้แอปพลิเคชันหลักรู้ว่าเมื่อไหร่ที่โมดูลพร้อมใช้งานและเมื่อไหร่ที่ควรจะยกเลิกการเชื่อมต่อ
// โครงสร้างที่ชัดเจน: นักพัฒนาสามารถ override เมธอด onModuleInit(), onModuleDependenciesChanged(), และ onModuleDispose() เพื่อเพิ่ม logic ที่จำเป็นสำหรับวงจรชีวิตของโมดูล เช่น การเริ่มต้น logger หรือการ clean up ทรัพยากร
// ลดความซับซ้อน: การใช้ mixin ช่วยลดความซับซ้อนของโค้ด เนื่องจากไม่ต้องจัดการกับ HostCommunicationService โดยตรงในทุกๆ เมธอดของวงจรชีวิต
