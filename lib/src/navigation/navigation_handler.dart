// ===============================================
// mini_app_module_interface/lib/src/navigation/navigation_handler.dart
// ===============================================

import 'package:flutter/material.dart';
import 'host_navigator_provider.dart';

/// Abstract navigation handler for mini apps
abstract class MiniAppNavigationHandler {
  String get moduleId;
  String get displayName;

  void navigateToMiniApp({
    required BuildContext context,
    String? targetRoute,
    Map<String, dynamic>? extraData,
    VoidCallback? onPressed,
  });
}

/// Base implementation of navigation handler
class BaseMiniAppNavigationHandler implements MiniAppNavigationHandler {
  @override
  final String moduleId;

  @override
  final String displayName;

  const BaseMiniAppNavigationHandler({required this.moduleId, required this.displayName});

  @override
  void navigateToMiniApp({
    required BuildContext context,
    String? targetRoute,
    Map<String, dynamic>? extraData,
    VoidCallback? onPressed,
  }) {
    // Call onPressed callback first
    onPressed?.call();

    // Prepare navigation data
    final navigationData = _prepareNavigationData(targetRoute, extraData);

    // Notify host app
    _notifyHostApp(context, navigationData);
  }

  Map<String, dynamic> _prepareNavigationData(String? targetRoute, Map<String, dynamic>? extraData) {
    final data = <String, dynamic>{
      'moduleId': moduleId,
      'source': 'mini_app_shortcut',
      'timestamp': DateTime.now().toIso8601String(),
    };

    if (targetRoute != null) {
      data['route'] = targetRoute;
    }

    if (extraData != null) {
      data.addAll(extraData!);
    }

    return data;
  }

  void _notifyHostApp(BuildContext context, Map<String, dynamic> data) {
    try {
      // Try to get host navigation service
      final hostNavigator = HostNavigatorProvider.of(context);

      if (hostNavigator != null) {
        hostNavigator.navigateToModule(moduleId, data);
      } else {
        _fallbackNavigation(context, data);
      }
    } catch (e) {
      debugPrint('❌ Navigation error: $e');
      _fallbackNavigation(context, data);
    }
  }

  void _fallbackNavigation(BuildContext context, Map<String, dynamic> data) {
    debugPrint('⚠️ Using fallback navigation for $moduleId');

    // Fallback: use named route
    try {
      Navigator.of(context).pushNamed('/mini_app', arguments: {'moduleId': moduleId, 'navigationData': data});
    } catch (e) {
      debugPrint('❌ Fallback navigation failed: $e');
      // Could show error dialog here
    }
  }
}
