// ===============================================
// mini_app_module_interface/lib/src/shortcut/shortcut_interfaces.dart
// ===============================================

import 'package:flutter/material.dart';

/// Interface สำหรับ Mini App ที่รองรับ Shortcut Widgets
abstract class MiniAppShortcutProvider {
  /// สร้าง shortcut widget พื้นฐาน
  Widget createShortcutButton({
    String? title,
    IconData? icon,
    String? targetRoute,
    Map<String, dynamic>? extraData,
    VoidCallback? onPressed,
    Color? backgroundColor,
    Color? textColor,
    double? width,
    double? height,
  });

  /// สร้าง shortcut แบบ card
  Widget createShortcutCard({
    required String title,
    String? subtitle,
    required IconData icon,
    String? targetRoute,
    Map<String, dynamic>? extraData,
    VoidCallback? onPressed,
  });

  /// สร้าง FAB shortcut
  Widget createShortcutFAB({
    String? heroTag,
    String? targetRoute,
    Map<String, dynamic>? extraData,
    VoidCallback? onPressed,
    IconData? icon,
  });

  /// สร้าง collection ของ shortcuts
  List<Widget> createShortcutCollection();

  /// สร้าง grid ของ shortcuts
  Widget createShortcutGrid({int crossAxisCount = 2});

  /// ข้อมูล module สำหรับการสร้าง shortcut
  String get moduleId;
  String get modulePath; // เช่น '/app3', '/payment', '/profile'
  Map<String, String> get availableRoutes; // route name -> route path
}

/// Base class สำหรับ Shortcut Widget ที่ทุก mini app สามารถใช้ได้
abstract class BaseMiniAppShortcutWidget extends StatelessWidget {
  final String moduleId;
  final String modulePath;
  final String? title;
  final IconData? icon;
  final String? targetRoute;
  final Map<String, dynamic>? extraData;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;

  const BaseMiniAppShortcutWidget({
    super.key,
    required this.moduleId,
    required this.modulePath,
    this.title,
    this.icon,
    this.targetRoute,
    this.extraData,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton.icon(
        onPressed: () => _handlePress(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
          foregroundColor: textColor ?? Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
        icon: Icon(icon ?? Icons.apps),
        label: Text(title ?? 'Open $moduleId'),
      ),
    );
  }

  void _handlePress(BuildContext context) {
    onPressed?.call();

    final Map<String, dynamic> routeExtra = {
      'source': 'shortcut_widget',
      'moduleId': moduleId,
      'timestamp': DateTime.now().toIso8601String(),
    };

    if (targetRoute != null) {
      routeExtra['route'] = targetRoute;
    }

    if (extraData != null) {
      routeExtra.addAll(extraData!);
    }

    debugPrint('🚀 $moduleId Shortcut pressed - navigating with extra: $routeExtra');

    // Navigate ไป module path พร้อม extra data
    Navigator.of(context).pushNamed(modulePath, arguments: routeExtra);
  }
}

/// Generic Shortcut Widget ที่ทุก mini app ใช้ได้
class GenericMiniAppShortcut extends BaseMiniAppShortcutWidget {
  const GenericMiniAppShortcut({
    super.key,
    required super.moduleId,
    required super.modulePath,
    super.title,
    super.icon,
    super.targetRoute,
    super.extraData,
    super.onPressed,
    super.backgroundColor,
    super.textColor,
    super.width,
    super.height,
  });
}

/// Generic Card Shortcut
class GenericMiniAppShortcutCard extends StatelessWidget {
  final String moduleId;
  final String modulePath;
  final String title;
  final String? subtitle;
  final IconData icon;
  final String? targetRoute;
  final Map<String, dynamic>? extraData;
  final VoidCallback? onPressed;

  const GenericMiniAppShortcutCard({
    super.key,
    required this.moduleId,
    required this.modulePath,
    required this.title,
    this.subtitle,
    required this.icon,
    this.targetRoute,
    this.extraData,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () => _handlePress(context),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: Theme.of(context).primaryColor),
              const SizedBox(height: 8),
              Text(title, style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(subtitle!, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _handlePress(BuildContext context) {
    onPressed?.call();

    final Map<String, dynamic> routeExtra = {
      'source': 'shortcut_card',
      'moduleId': moduleId,
      'timestamp': DateTime.now().toIso8601String(),
    };

    if (targetRoute != null) {
      routeExtra['route'] = targetRoute;
    }

    if (extraData != null) {
      routeExtra.addAll(extraData!);
    }

    debugPrint('🚀 $moduleId Card pressed - navigating with extra: $routeExtra');
    Navigator.of(context).pushNamed(modulePath, arguments: routeExtra);
  }
}

/// Configuration สำหรับ shortcut
class MiniAppShortcutConfig {
  final String moduleId;
  final String modulePath;
  final String displayName;
  final IconData defaultIcon;
  final Map<String, String> availableRoutes;
  final Color? primaryColor;

  const MiniAppShortcutConfig({
    required this.moduleId,
    required this.modulePath,
    required this.displayName,
    required this.defaultIcon,
    required this.availableRoutes,
    this.primaryColor,
  });
}

/// Factory สำหรับสร้าง shortcut widgets
class MiniAppShortcutFactory {
  static Widget createButton({
    required MiniAppShortcutConfig config,
    String? title,
    IconData? icon,
    String? targetRoute,
    Map<String, dynamic>? extraData,
    VoidCallback? onPressed,
    Color? backgroundColor,
    double? width,
  }) {
    return GenericMiniAppShortcut(
      moduleId: config.moduleId,
      modulePath: config.modulePath,
      title: title ?? 'Open ${config.displayName}',
      icon: icon ?? config.defaultIcon,
      targetRoute: targetRoute,
      extraData: extraData,
      onPressed: onPressed,
      backgroundColor: backgroundColor ?? config.primaryColor,
      width: width,
    );
  }

  static Widget createCard({
    required MiniAppShortcutConfig config,
    required String title,
    String? subtitle,
    IconData? icon,
    String? targetRoute,
    Map<String, dynamic>? extraData,
    VoidCallback? onPressed,
  }) {
    return GenericMiniAppShortcutCard(
      moduleId: config.moduleId,
      modulePath: config.modulePath,
      title: title,
      subtitle: subtitle,
      icon: icon ?? config.defaultIcon,
      targetRoute: targetRoute,
      extraData: extraData,
      onPressed: onPressed,
    );
  }

  static List<Widget> createQuickAccessCollection({required MiniAppShortcutConfig config}) {
    return [
      createButton(config: config, title: 'Open ${config.displayName}'),
      if (config.availableRoutes.containsKey('home')) ...[
        const SizedBox(height: 8),
        createButton(
          config: config,
          title: '${config.displayName} Home',
          targetRoute: config.availableRoutes['home'],
          backgroundColor: Colors.green,
        ),
      ],
    ];
  }

  static Widget createGrid({required MiniAppShortcutConfig config, int crossAxisCount = 2}) {
    final shortcuts = <Widget>[];

    // เพิ่ม card สำหรับแต่ละ route
    config.availableRoutes.forEach((routeName, routePath) {
      shortcuts.add(
        createCard(
          config: config,
          title: '${config.displayName} ${routeName.toUpperCase()}',
          subtitle: 'Access $routeName',
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
}
