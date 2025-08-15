// ===============================================
// lib/src/core/module_config.dart
// ===============================================

import 'dart:convert';

/// Configuration class for modules
class MiniAppModuleConfig {
  final String moduleId;
  final String version;
  final String initialRoute;
  final Map<String, dynamic> userData;
  final Map<String, dynamic> metadata;
  final Map<String, dynamic> themeConfig;
  final bool enableDebugMode;
  final Duration sessionTimeout;

  const MiniAppModuleConfig({
    required this.moduleId,
    this.version = '1.0.0',
    this.initialRoute = '/',
    this.userData = const {},
    this.metadata = const {},
    this.themeConfig = const {},
    this.enableDebugMode = false,
    this.sessionTimeout = const Duration(hours: 2),
  });

  // Helper methods
  bool get hasUser => userData.isNotEmpty;
  String? get userName => userData['name'] as String?;
  String? get userEmail => userData['email'] as String?;
  String? get userId => userData['id'] as String?;

  T? getMetadata<T>(String key) => metadata[key] as T?;
  T? getThemeValue<T>(String key) => themeConfig[key] as T?;
  T? getUserData<T>(String key) => userData[key] as T?;

  Map<String, dynamic> toJson() => {
    'moduleId': moduleId,
    'version': version,
    'initialRoute': initialRoute,
    'userData': userData,
    'metadata': metadata,
    'themeConfig': themeConfig,
    'enableDebugMode': enableDebugMode,
    'sessionTimeout': sessionTimeout.inMilliseconds,
  };

  factory MiniAppModuleConfig.fromJson(Map<String, dynamic> json) => MiniAppModuleConfig(
    moduleId: json['moduleId'] as String,
    version: json['version'] as String? ?? '1.0.0',
    initialRoute: json['initialRoute'] as String? ?? '/',
    userData: json['userData'] as Map<String, dynamic>? ?? {},
    metadata: json['metadata'] as Map<String, dynamic>? ?? {},
    themeConfig: json['themeConfig'] as Map<String, dynamic>? ?? {},
    enableDebugMode: json['enableDebugMode'] as bool? ?? false,
    sessionTimeout: Duration(milliseconds: json['sessionTimeout'] as int? ?? 7200000),
  );

  MiniAppModuleConfig copyWith({
    String? moduleId,
    String? version,
    String? initialRoute,
    Map<String, dynamic>? userData,
    Map<String, dynamic>? metadata,
    Map<String, dynamic>? themeConfig,
    bool? enableDebugMode,
    Duration? sessionTimeout,
  }) => MiniAppModuleConfig(
    moduleId: moduleId ?? this.moduleId,
    version: version ?? this.version,
    initialRoute: initialRoute ?? this.initialRoute,
    userData: userData ?? this.userData,
    metadata: metadata ?? this.metadata,
    themeConfig: themeConfig ?? this.themeConfig,
    enableDebugMode: enableDebugMode ?? this.enableDebugMode,
    sessionTimeout: sessionTimeout ?? this.sessionTimeout,
  );
}
