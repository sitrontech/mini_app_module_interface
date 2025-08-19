// mini_app_module_interface/lib/src/base/mini_app_base.dart

// ===============================================
// MINI APP BASE CLASS
// ===============================================

import 'package:flutter/material.dart';
import '../shortcut/shortcut_interfaces.dart';
import '../navigation/navigation_abstractions.dart';
import '../core/module_config.dart';
import '../core/host_communication.dart';
import '../core/module_lifecycle.dart';

/// Base class for mini app modules
abstract class MiniAppModuleBase extends StatefulWidget implements MiniAppShortcutProvider {
  // พารามิเตอร์ที่จำเป็นสำหรับทุกโมดูล
  // ทำหน้าที่เก็บข้อมูลการตั้งค่าทั้งหมดที่แอปพลิเคชันหลักส่งมาให้โมดูล เช่น ID ของโมดูล ข้อมูลผู้ใช้ และการตั้งค่าธีม
  final MiniAppModuleConfig config;

  // callback ที่ให้โมดูลสามารถรับฟังและจัดการกับเหตุการณ์ต่างๆ ที่แอปพลิเคชันหลักส่งมาได้
  final void Function(String, Map<String, dynamic>)? onHostEvent;

  const MiniAppModuleBase({super.key, required this.config, this.onHostEvent});

  @override
  String get moduleId;

  @override
  String get modulePath;

  @override
  Map<String, String> get availableRoutes;

  Map<String, dynamic> get moduleMetadata;

  List<String> get requiredPermissions;

  bool canActivate();

  // Navigation methods
  List<MiniAppRouteConfig> buildRoutes();

  /// เมธอดที่โมดูลจะต้อง override เพื่อสร้างและคืนค่าโครงสร้าง UI หลักของตัวเอง
  Widget buildModule(BuildContext context);

  MiniAppNavigationDelegate createNavigationDelegate();

  // Shortcut implementations
  @override
  String get displayName => moduleMetadata['name'] ?? moduleId;

  @override
  IconData get defaultIcon {
    final iconData = moduleMetadata['icon'] as IconData?;
    return iconData ?? Icons.apps;
  }

  Color? get primaryColor {
    final colorValue = moduleMetadata['primaryColor'] as int?;
    return colorValue != null ? Color(colorValue) : null;
  }

  @override
  Widget createShortcutButton({
    String? title,
    IconData? icon,
    String? targetRoute,
    Map<String, dynamic>? extraData,
    VoidCallback? onPressed,
    ShortcutStyle? style,
  }) {
    return CleanShortcutButton(
      action: ShortcutNavigationAction(
        moduleId: moduleId,
        modulePath: modulePath,
        targetRoute: targetRoute,
        extraData: extraData,
        onPressed: onPressed,
      ),
      title: title ?? 'Open $displayName',
      icon: icon ?? defaultIcon,
      style: style ?? ShortcutStyle(backgroundColor: primaryColor, textColor: Colors.white),
    );
  }

  @override
  Widget createShortcutCard({
    required String title,
    String? subtitle,
    required IconData icon,
    String? targetRoute,
    Map<String, dynamic>? extraData,
    VoidCallback? onPressed,
  }) {
    return CleanShortcutCard(
      action: ShortcutNavigationAction(
        moduleId: moduleId,
        modulePath: modulePath,
        targetRoute: targetRoute,
        extraData: extraData,
        onPressed: onPressed,
      ),
      title: title,
      subtitle: subtitle,
      icon: icon,
    );
  }

  @override
  Widget createShortcutFAB({
    String? heroTag,
    String? targetRoute,
    Map<String, dynamic>? extraData,
    VoidCallback? onPressed,
    IconData? icon,
  }) {
    return Builder(
      builder: (context) => FloatingActionButton(
        heroTag: heroTag ?? '${moduleId}_shortcut_fab',
        onPressed: () {
          final action = ShortcutNavigationAction(
            moduleId: moduleId,
            modulePath: modulePath,
            targetRoute: targetRoute,
            extraData: extraData,
            onPressed: onPressed,
          );
          action.execute(context);
        },
        child: Icon(icon ?? defaultIcon),
      ),
    );
  }

  @override
  List<Widget> createShortcutCollection() {
    final shortcuts = <Widget>[createShortcutButton(title: 'Open $displayName')];

    if (availableRoutes.containsKey('home')) {
      shortcuts.addAll([
        const SizedBox(height: 8),
        createShortcutButton(
          title: '$displayName Home',
          targetRoute: availableRoutes['home'],
          style: ShortcutStyle(backgroundColor: Colors.green),
        ),
      ]);
    }

    return shortcuts;
  }

  @override
  Widget createShortcutGrid({int crossAxisCount = 2}) {
    final shortcuts = <Widget>[];

    availableRoutes.forEach((routeName, routePath) {
      shortcuts.add(
        createShortcutCard(
          title: '$displayName ${routeName.toUpperCase()}',
          subtitle: 'Access $routeName',
          icon: defaultIcon,
          targetRoute: routePath,
        ),
      );
    });

    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: shortcuts,
    );
  }

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
