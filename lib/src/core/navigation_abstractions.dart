import 'package:flutter/material.dart';

/// Abstract navigation interface ที่ไม่ผูกติดกับ go_router
abstract class MiniAppNavigationService {
  /// Navigate to a route within the mini app
  void navigateToRoute(String route, {Map<String, dynamic>? extra});

  /// Go back to previous route
  void goBack({String? reason});

  /// Replace current route
  void replaceRoute(String route, {Map<String, dynamic>? extra});

  /// Check if can go back
  bool canGoBack();

  /// Get current route
  String get currentRoute;

  /// Navigation history
  List<String> get navigationHistory;
}

/// Abstract route configuration
abstract class MiniAppRouteConfig {
  String get path;
  String get name;
  Widget buildPage(BuildContext context, Map<String, dynamic>? arguments);
  bool canActivate(Map<String, dynamic>? userData);
}

/// Route builder interface
typedef MiniAppRouteBuilder = Widget Function(BuildContext context, Map<String, dynamic>? arguments);

/// Simple route configuration
class SimpleMiniAppRoute implements MiniAppRouteConfig {
  @override
  final String path;

  @override
  final String name;

  final MiniAppRouteBuilder builder;
  final bool Function(Map<String, dynamic>?)? canActivateCallback;

  const SimpleMiniAppRoute({required this.path, required this.name, required this.builder, this.canActivateCallback});

  @override
  Widget buildPage(BuildContext context, Map<String, dynamic>? arguments) {
    return builder(context, arguments);
  }

  @override
  bool canActivate(Map<String, dynamic>? userData) {
    return canActivateCallback?.call(userData) ?? true;
  }
}

/// Navigation delegate interface
abstract class MiniAppNavigationDelegate {
  /// Initialize navigation for the mini app
  void initialize({
    required List<MiniAppRouteConfig> routes,
    required String initialRoute,
    Map<String, dynamic>? initialArguments,
  });

  /// Create navigation service instance
  MiniAppNavigationService createNavigationService();

  /// Build the navigation widget
  Widget buildNavigationWidget(BuildContext context);

  /// Handle route not found
  Widget buildNotFoundPage(BuildContext context, String route);

  /// Handle navigation errors
  Widget buildErrorPage(BuildContext context, String error);
}
