// mini_app_module_interface/lib/src/shortcut/shortcut_interfaces.dart

// ===============================================
// 1. CONSOLIDATED CLEAN SHORTCUT INTERFACES
// ===============================================

import 'package:flutter/material.dart';

/// Main interface สำหรับ Mini App ที่รองรับ Shortcut Widgets
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

    // Use generic navigation
    Navigator.of(context).pushNamed(modulePath, arguments: navigationData);
  }
}

/// Generic shortcut widgets
class CleanShortcutButton extends StatelessWidget {
  final NavigationAction action;
  final String title;
  final IconData icon;
  final ShortcutStyle style;

  const CleanShortcutButton({
    super.key,
    required this.action,
    required this.title,
    required this.icon,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: style.width ?? double.infinity,
      height: style.height,
      child: ElevatedButton.icon(
        onPressed: () => action.execute(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: style.backgroundColor ?? Theme.of(context).primaryColor,
          foregroundColor: style.textColor ?? Colors.white,
          padding: style.padding ?? const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: style.borderRadius ?? BorderRadius.circular(8)),
        ),
        icon: Icon(icon),
        label: Text(title),
      ),
    );
  }
}

class CleanShortcutCard extends StatelessWidget {
  final NavigationAction action;
  final String title;
  final String? subtitle;
  final IconData icon;

  const CleanShortcutCard({super.key, required this.action, required this.title, this.subtitle, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () => action.execute(context),
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
}
