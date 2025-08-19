import 'package:flutter/material.dart';

import '../../mini_app_module_interface.dart';
import 'clean_shortcut_interfaces.dart';
import 'clean_shortcut_widgets.dart';
import 'navigation_abstractions.dart';

/// Clean base class ที่ไม่ผูกติดกับ specific navigation library
abstract class CleanMiniAppModuleBase extends StatelessWidget implements MiniAppShortcutProvider {
  final MiniAppModuleConfig config;
  final void Function(String, Map<String, dynamic>)? onHostEvent;

  const CleanMiniAppModuleBase({super.key, required this.config, this.onHostEvent});

  // Abstract methods
  @override
  String get moduleId;

  @override
  String get modulePath;

  @override
  Map<String, String> get availableRoutes;

  Map<String, dynamic> get moduleMetadata;
  List<String> get requiredPermissions;
  bool canActivate();

  // Navigation-agnostic methods
  List<MiniAppRouteConfig> buildRoutes();
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

  // @override
  // Widget createShortcutCard({
  //   required String title,
  //   String? subtitle,
  //   required IconData icon,
  //   String? targetRoute,
  //   Map<String, dynamic>? extraData,
  //   VoidCallback? onPressed,
  // }) {
  //   return CleanShortcutCard(
  //     action: ShortcutNavigationAction(
  //       moduleId: moduleId,
  //       modulePath: modulePath,
  //       targetRoute: targetRoute,
  //       extraData: extraData,
  //       onPressed: onPressed,
  //     ),
  //     title: title,
  //     subtitle: subtitle,
  //     icon: icon,
  //   );
  // }

  @override
  Widget createShortcutFAB({
    String? heroTag,
    String? targetRoute,
    Map<String, dynamic>? extraData,
    VoidCallback? onPressed,
    IconData? icon,
  }) {
    return FloatingActionButton(
      heroTag: heroTag ?? '${moduleId}_shortcut_fab',
      onPressed: () {
        final action = ShortcutNavigationAction(
          moduleId: moduleId,
          modulePath: modulePath,
          targetRoute: targetRoute,
          extraData: extraData,
          onPressed: onPressed,
        );
        // Note: Context ต้องส่งมาจากที่เรียกใช้
      },
      child: Icon(icon ?? defaultIcon),
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
  Widget build(BuildContext context) {
    return buildModule(context);
  }
}
