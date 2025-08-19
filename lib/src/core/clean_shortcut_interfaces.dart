import 'package:flutter/material.dart';

/// Clean shortcut interface ที่ไม่ผูกติดกับ specific navigation
abstract class MiniAppShortcutProvider {
  /// Module information
  String get moduleId;
  String get modulePath;
  String get displayName;
  IconData get defaultIcon;
  Map<String, String> get availableRoutes;

  /// Create basic shortcut button
  Widget createShortcutButton({
    String? title,
    IconData? icon,
    String? targetRoute,
    Map<String, dynamic>? extraData,
    VoidCallback? onPressed,
    ShortcutStyle? style,
  });

  /// Create shortcut card
  Widget createShortcutCard({
    required String title,
    String? subtitle,
    required IconData icon,
    String? targetRoute,
    Map<String, dynamic>? extraData,
    VoidCallback? onPressed,
  });

  /// Create FAB shortcut
  Widget createShortcutFAB({
    String? heroTag,
    String? targetRoute,
    Map<String, dynamic>? extraData,
    VoidCallback? onPressed,
    IconData? icon,
  });

  /// Create collection of shortcuts
  List<Widget> createShortcutCollection();

  /// Create grid of shortcuts
  Widget createShortcutGrid({int crossAxisCount = 2});
}

/// Shortcut styling configuration
class ShortcutStyle {
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const ShortcutStyle({this.backgroundColor, this.textColor, this.width, this.height, this.padding, this.borderRadius});
}

/// Navigation action interface
abstract class NavigationAction {
  void execute(BuildContext context);
}

/// Concrete navigation action สำหรับ shortcut
class ShortcutNavigationAction implements NavigationAction {
  final String moduleId;
  final String modulePath;
  final String? targetRoute;
  final Map<String, dynamic>? extraData;
  final VoidCallback? onPressed;

  const ShortcutNavigationAction({
    required this.moduleId,
    required this.modulePath,
    this.targetRoute,
    this.extraData,
    this.onPressed,
  });

  @override
  void execute(BuildContext context) {
    onPressed?.call();

    final Map<String, dynamic> navigationData = {
      'source': 'shortcut_widget',
      'moduleId': moduleId,
      'timestamp': DateTime.now().toIso8601String(),
    };

    if (targetRoute != null) {
      navigationData['route'] = targetRoute;
    }

    if (extraData != null) {
      navigationData.addAll(extraData!);
    }

    debugPrint('🚀 $moduleId Shortcut navigation: $navigationData');

    // ใช้ Navigator.pushNamed แทน go_router เพื่อความเป็น generic
    Navigator.of(context).pushNamed(modulePath, arguments: navigationData);
  }
}
