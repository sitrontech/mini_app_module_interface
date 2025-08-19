// ===============================================
// mini_app_module_interface/lib/src/navigation/host_navigator_provider.dart
// ===============================================

import 'package:flutter/material.dart';
import 'navigation_service.dart';

/// InheritedWidget สำหรับ provide navigation service to mini apps
class HostNavigatorProvider extends InheritedWidget {
  final HostNavigationService navigationService;

  const HostNavigatorProvider({super.key, required this.navigationService, required super.child});

  /// Get navigation service from context
  static HostNavigationService? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<HostNavigatorProvider>()?.navigationService;
  }

  /// Try to get navigation service, throw error if not found
  static HostNavigationService require(BuildContext context) {
    final service = of(context);
    if (service == null) {
      throw FlutterError(
        'HostNavigatorProvider not found in widget tree.\n'
        'Make sure to wrap your app with HostNavigatorProvider.',
      );
    }
    return service;
  }

  @override
  bool updateShouldNotify(HostNavigatorProvider oldWidget) {
    return navigationService != oldWidget.navigationService;
  }
}
