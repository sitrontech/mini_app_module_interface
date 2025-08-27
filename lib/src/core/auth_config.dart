// ===============================================
// lib/src/core/auth_config.dart
// Authentication configuration for modules
// ===============================================

/// Authentication configuration จาก Host App
class HostAppAuthConfig {
  /// Access token สำหรับ API calls
  final String? accessToken;

  /// เวลาที่ access token หมดอายุ
  final DateTime? expiresIn;

  /// เวลาที่ refresh token หมดอายุ
  final DateTime? refreshExpiresIn;

  /// Refresh token สำหรับ renew access token
  final String? refreshToken;

  /// Token type (Bearer, Basic, etc.)
  final String? tokenType;

  final String? idToken;
  final String? sessionState;
  final String? scope;

  const HostAppAuthConfig({
    this.accessToken,
    this.expiresIn,
    this.refreshExpiresIn,
    this.refreshToken,
    this.tokenType = 'Bearer',
    this.idToken,
    this.sessionState,
    this.scope,
  });

  /// ตรวจสอบว่ามี access token หรือไม่
  bool get hasAccessToken => accessToken != null && accessToken!.isNotEmpty;

  /// ตรวจสอบว่า access token หมดอายุหรือไม่
  bool get isAccessTokenExpired {
    if (expiresIn == null) return false;
    return DateTime.now().isAfter(expiresIn!);
  }

  /// ตรวจสอบว่า refresh token หมดอายุหรือไม่
  bool get isRefreshTokenExpired {
    if (refreshExpiresIn == null) return false;
    return DateTime.now().isAfter(refreshExpiresIn!);
  }

  /// ตรวจสอบว่าต้อง refresh token หรือไม่
  bool get needsRefresh => hasAccessToken && isAccessTokenExpired && !isRefreshTokenExpired;

  /// สร้าง Authorization header
  String? get authorizationHeader {
    if (!hasAccessToken) return null;
    return '$tokenType $accessToken';
  }

  /// สร้างจาก JSON
  factory HostAppAuthConfig.fromJson(Map<String, dynamic> json) => HostAppAuthConfig(
    accessToken: json['accessToken'] as String?,
    expiresIn: json['expiresIn'] != null ? DateTime.parse(json['expiresIn'] as String) : null,
    refreshExpiresIn: json['refreshExpiresIn'] != null ? DateTime.parse(json['refreshExpiresIn'] as String) : null,
    refreshToken: json['refreshToken'] as String?,
    tokenType: json['tokenType'] as String? ?? 'Bearer',
    idToken: json['idToken'] as String?,
    sessionState: json['sessionState'] as String?,
    scope: json['scope'] as String?,
  );

  /// แปลงเป็น JSON
  Map<String, dynamic> toJson() => {
    if (accessToken != null) 'accessToken': accessToken,
    if (expiresIn != null) 'expiresIn': expiresIn!.toIso8601String(),
    if (refreshExpiresIn != null) 'refreshExpiresIn': refreshExpiresIn!.toIso8601String(),
    if (refreshToken != null) 'refreshToken': refreshToken,
    'tokenType': tokenType,
    'idToken': idToken,
    'sessionState': sessionState,
    'scope': scope,
  };

  /// Copy with method
  HostAppAuthConfig copyWith({
    String? accessToken,
    DateTime? expiresIn,
    DateTime? refreshExpiresIn,
    String? refreshToken,
    String? tokenType,
    String? idToken,
    String? sessionState,
    String? scope,
  }) => HostAppAuthConfig(
    accessToken: accessToken ?? this.accessToken,
    expiresIn: expiresIn ?? this.expiresIn,
    refreshExpiresIn: refreshExpiresIn ?? this.refreshExpiresIn,
    refreshToken: refreshToken ?? this.refreshToken,
    tokenType: tokenType ?? this.tokenType,
    idToken: idToken ?? this.idToken,
    sessionState: sessionState ?? this.sessionState,
    scope: scope ?? this.scope,
  );
}
