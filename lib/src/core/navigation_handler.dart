import 'package:flutter/material.dart';

/// Abstract navigation handler ที่ไม่ผูกติดกับ specific routing
abstract class MiniAppNavigationHandler {
  /// Navigate to the mini app with optional route and data
  void navigateToMiniApp({
    required BuildContext context,
    String? targetRoute,
    Map<String, dynamic>? extraData,
    VoidCallback? onPressed,
  });

  /// Get module information
  String get moduleId;
  String get displayName;
}

/// Navigation action interface
abstract class NavigationAction {
  void execute(BuildContext context);
}

/// Generic mini app navigation action
class MiniAppNavigationAction implements NavigationAction {
  final MiniAppNavigationHandler handler;
  final String? targetRoute;
  final Map<String, dynamic>? extraData;
  final VoidCallback? onPressed;

  const MiniAppNavigationAction({required this.handler, this.targetRoute, this.extraData, this.onPressed});

  @override
  void execute(BuildContext context) {
    handler.navigateToMiniApp(context: context, targetRoute: targetRoute, extraData: extraData, onPressed: onPressed);
  }
}
