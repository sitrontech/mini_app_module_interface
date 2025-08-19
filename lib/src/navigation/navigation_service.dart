// ===============================================
// mini_app_module_interface/lib/src/navigation/navigation_service.dart
// ===============================================

import 'package:flutter/foundation.dart';

/// Host navigation service interface
class HostNavigationService {
  final Map<String, String> _moduleRoutes = {};
  final void Function(String moduleId, Map<String, dynamic> data)? _customHandler;

  HostNavigationService({
    Map<String, String>? moduleRoutes,
    void Function(String moduleId, Map<String, dynamic> data)? customHandler,
  }) : _customHandler = customHandler {
    if (moduleRoutes != null) {
      _moduleRoutes.addAll(moduleRoutes);
    }
  }

  /// Navigate to a module
  void navigateToModule(String moduleId, Map<String, dynamic> navigationData) {
    debugPrint('🎯 HostNavigationService: Navigating to $moduleId');
    debugPrint('   Data: $navigationData');

    // Use custom handler if provided
    if (_customHandler != null) {
      _customHandler!(moduleId, navigationData);
      return;
    }

    // Fallback: check if route is registered
    final route = _moduleRoutes[moduleId];
    if (route != null) {
      debugPrint('   Using registered route: $route');
      // Host app should override this behavior
      _defaultNavigation(moduleId, route, navigationData);
    } else {
      debugPrint('❌ No route registered for module: $moduleId');
      _handleUnknownModule(moduleId, navigationData);
    }
  }

  /// Register a module route
  void registerModuleRoute(String moduleId, String route) {
    _moduleRoutes[moduleId] = route;
    debugPrint('📝 Registered route for $moduleId: $route');
  }

  /// Register multiple module routes
  void registerModuleRoutes(Map<String, String> routes) {
    _moduleRoutes.addAll(routes);
    routes.forEach((moduleId, route) {
      debugPrint('📝 Registered route for $moduleId: $route');
    });
  }

  /// Get registered routes
  Map<String, String> get registeredRoutes => Map.unmodifiable(_moduleRoutes);

  /// Check if module is registered
  bool isModuleRegistered(String moduleId) => _moduleRoutes.containsKey(moduleId);

  void _defaultNavigation(String moduleId, String route, Map<String, dynamic> data) {
    debugPrint('⚠️ Using default navigation - host app should override this');
    // Host app should provide custom handler
  }

  void _handleUnknownModule(String moduleId, Map<String, dynamic> data) {
    debugPrint('❌ Unknown module navigation: $moduleId');
    // Host app should handle this case
  }
}
