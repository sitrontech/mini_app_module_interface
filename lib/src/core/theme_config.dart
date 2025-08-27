// ===============================================
// lib/src/core/theme_config.dart
// Theme configuration for consistent UI across modules
// ===============================================

/// Theme configuration สำหรับ mini app modules
class HostAppThemeConfig {
  // ============================================
  // Colors (สี)
  // ============================================

  /// สีหลักของแอป
  final int? primaryColor;

  /// สีรองของแอป
  final int? secondaryColor;

  /// สีพื้นหลัง
  final int? backgroundColor;

  /// สีพื้นผิว (surface)
  final int? surfaceColor;

  /// สีข้อความหลัก
  final int? textColor;

  /// สีข้อความรอง
  final int? secondaryTextColor;

  /// สีแสดงข้อผิดพลาด
  final int? errorColor;

  /// สีแสดงความสำเร็จ
  final int? successColor;

  /// สีแสดงคำเตือน
  final int? warningColor;

  /// สีแสดงข้อมูล
  final int? infoColor;

  // ============================================
  // Typography (ตัวอักษร)
  // ============================================

  /// ชื่อ font family
  final String? fontFamily;

  /// ขนาด font พื้นฐาน (body text)
  final double? fontSize;

  /// ขนาด font สำหรับหัวข้อใหญ่
  final double? headlineFontSize;

  /// ขนาด font สำหรับหัวข้อย่อย
  final double? titleFontSize;

  /// ขนาด font สำหรับข้อความเล็ก
  final double? captionFontSize;

  /// น้ำหนัก font พื้นฐาน (normal, bold, etc.)
  final String? fontWeight;

  /// ความสูงของบรรทัด (line height)
  final double? lineHeight;

  // ============================================
  // Layout & Spacing (การจัดวางและระยะห่าง)
  // ============================================

  /// ระยะห่างพื้นฐาน
  final double? spacing;

  /// ระยะห่างเล็ก
  final double? smallSpacing;

  /// ระยะห่างใหญ่
  final double? largeSpacing;

  /// Padding พื้นฐาน
  final double? padding;

  /// Border radius พื้นฐาน
  final double? borderRadius;

  /// ความหนาของเส้นขอบ
  final double? borderWidth;

  // ============================================
  // Component Styles (สไตล์ของ component)
  // ============================================

  /// ความสูงของ Button
  final double? buttonHeight;

  /// Border radius ของ Button
  final double? buttonBorderRadius;

  /// ความสูงของ TextField
  final double? textFieldHeight;

  /// Border radius ของ TextField
  final double? textFieldBorderRadius;

  /// ความสูงของ Card
  final double? cardElevation;

  /// Border radius ของ Card
  final double? cardBorderRadius;

  // ============================================
  // App Bar & Navigation
  // ============================================

  /// ความสูงของ AppBar
  final double? appBarHeight;

  /// สีพื้นหลังของ AppBar
  final int? appBarBackgroundColor;

  /// สีข้อความใน AppBar
  final int? appBarTextColor;

  /// แสดง elevation ใน AppBar หรือไม่
  final bool? appBarElevation;

  /// สีของ Bottom Navigation
  final int? bottomNavBackgroundColor;

  /// สีของ item ที่เลือกใน Bottom Navigation
  final int? bottomNavSelectedColor;

  /// สีของ item ที่ไม่เลือกใน Bottom Navigation
  final int? bottomNavUnselectedColor;

  // ============================================
  // Dark/Light Mode
  // ============================================

  /// เปิดใช้งาน Dark Mode
  final bool isDarkMode;

  /// อนุญาตให้ผู้ใช้เปลี่ยน theme หรือไม่
  final bool allowThemeToggle;

  // ============================================
  // Animation & Effects
  // ============================================

  /// ระยะเวลา animation พื้นฐาน (milliseconds)
  final int? animationDuration;

  /// ประเภท animation curve
  final String? animationCurve;

  /// เปิดใช้งาน ripple effect
  final bool? enableRippleEffect;

  /// เปิดใช้งาน shadow effects
  final bool? enableShadows;

  const HostAppThemeConfig({
    // Colors
    this.primaryColor,
    this.secondaryColor,
    this.backgroundColor,
    this.surfaceColor,
    this.textColor,
    this.secondaryTextColor,
    this.errorColor,
    this.successColor,
    this.warningColor,
    this.infoColor,
    // Typography
    this.fontFamily,
    this.fontSize,
    this.headlineFontSize,
    this.titleFontSize,
    this.captionFontSize,
    this.fontWeight,
    this.lineHeight,
    // Layout & Spacing
    this.spacing,
    this.smallSpacing,
    this.largeSpacing,
    this.padding,
    this.borderRadius,
    this.borderWidth,
    // Component Styles
    this.buttonHeight,
    this.buttonBorderRadius,
    this.textFieldHeight,
    this.textFieldBorderRadius,
    this.cardElevation,
    this.cardBorderRadius,
    // App Bar & Navigation
    this.appBarHeight,
    this.appBarBackgroundColor,
    this.appBarTextColor,
    this.appBarElevation,
    this.bottomNavBackgroundColor,
    this.bottomNavSelectedColor,
    this.bottomNavUnselectedColor,
    // Dark/Light Mode
    this.isDarkMode = false,
    this.allowThemeToggle = true,
    // Animation & Effects
    this.animationDuration,
    this.animationCurve,
    this.enableRippleEffect,
    this.enableShadows,
  });

  // ============================================
  // Helper Methods
  // ============================================

  /// ดึง primary color เป็น Color object (สำหรับ Flutter)
  /// ใช้ extension หรือ helper function ข้างนอก
  int get primaryColorValue => primaryColor ?? 0xFF2196F3; // Material Blue

  /// ดึง secondary color เป็น Color object
  int get secondaryColorValue => secondaryColor ?? 0xFFFF5722; // Material Deep Orange

  /// ดึง background color
  int get backgroundColorValue => backgroundColor ?? (isDarkMode ? 0xFF121212 : 0xFFFFFFFF);

  /// ดึง text color
  int get textColorValue => textColor ?? (isDarkMode ? 0xFFFFFFFF : 0xFF000000);

  /// ดึง font size พื้นฐาน
  double get fontSizeValue => fontSize ?? 14.0;

  /// ดึง spacing พื้นฐาน
  double get spacingValue => spacing ?? 8.0;

  /// ดึง border radius พื้นฐาน
  double get borderRadiusValue => borderRadius ?? 8.0;

  /// ดึง animation duration พื้นฐาน
  int get animationDurationValue => animationDuration ?? 300;

  // ============================================
  // Computed Properties
  // ============================================

  /// ดึง small spacing (ครึ่งหนึ่งของ spacing พื้นฐาน)
  double get computedSmallSpacing => smallSpacing ?? (spacingValue * 0.5);

  /// ดึง large spacing (สองเท่าของ spacing พื้นฐาน)
  double get computedLargeSpacing => largeSpacing ?? (spacingValue * 2.0);

  /// ดึง button height พื้นฐาน
  double get computedButtonHeight => buttonHeight ?? 48.0;

  /// ดึง text field height พื้นฐาน
  double get computedTextFieldHeight => textFieldHeight ?? 56.0;

  // ============================================
  // Preset Themes
  // ============================================

  /// Material Design Light Theme
  static const HostAppThemeConfig materialLight = HostAppThemeConfig(
    primaryColor: 0xFF2196F3,
    secondaryColor: 0xFFFF5722,
    backgroundColor: 0xFFFFFFFF,
    surfaceColor: 0xFFFFFFFF,
    textColor: 0xFF000000,
    secondaryTextColor: 0xFF666666,
    errorColor: 0xFFF44336,
    successColor: 0xFF4CAF50,
    warningColor: 0xFFFF9800,
    infoColor: 0xFF2196F3,
    fontFamily: 'Roboto',
    fontSize: 14.0,
    spacing: 8.0,
    borderRadius: 4.0,
    isDarkMode: false,
  );

  // Material Design Dark Theme
  static const HostAppThemeConfig materialDark = HostAppThemeConfig(
    primaryColor: 0xFF64B5F6,
    secondaryColor: 0xFFFF8A65,
    backgroundColor: 0xFF121212,
    surfaceColor: 0xFF1E1E1E,
    textColor: 0xFFFFFFFF,
    secondaryTextColor: 0xFFB0B0B0,
    errorColor: 0xFFF48FB1,
    successColor: 0xFF81C784,
    warningColor: 0xFFFFB74D,
    infoColor: 0xFF64B5F6,
    fontFamily: 'Roboto',
    fontSize: 14.0,
    spacing: 8.0,
    borderRadius: 4.0,
    isDarkMode: true,
  );

  /// iOS Cupertino Style Theme
  static const HostAppThemeConfig cupertino = HostAppThemeConfig(
    primaryColor: 0xFF007AFF,
    secondaryColor: 0xFFFF3B30,
    backgroundColor: 0xFFFFFFFF,
    surfaceColor: 0xFFF2F2F7,
    textColor: 0xFF000000,
    secondaryTextColor: 0xFF8E8E93,
    errorColor: 0xFFFF3B30,
    successColor: 0xFF34C759,
    warningColor: 0xFFFF9500,
    infoColor: 0xFF007AFF,
    fontFamily: 'SF Pro',
    fontSize: 17.0,
    spacing: 8.0,
    borderRadius: 8.0,
    buttonHeight: 44.0,
    isDarkMode: false,
  );

  // ============================================
  // Serialization
  // ============================================

  factory HostAppThemeConfig.fromJson(Map<String, dynamic> json) => HostAppThemeConfig(
    // Colors
    primaryColor: json['primaryColor'] as int?,
    secondaryColor: json['secondaryColor'] as int?,
    backgroundColor: json['backgroundColor'] as int?,
    surfaceColor: json['surfaceColor'] as int?,
    textColor: json['textColor'] as int?,
    secondaryTextColor: json['secondaryTextColor'] as int?,
    errorColor: json['errorColor'] as int?,
    successColor: json['successColor'] as int?,
    warningColor: json['warningColor'] as int?,
    infoColor: json['infoColor'] as int?,
    // Typography
    fontFamily: json['fontFamily'] as String?,
    fontSize: json['fontSize'] as double?,
    headlineFontSize: json['headlineFontSize'] as double?,
    titleFontSize: json['titleFontSize'] as double?,
    captionFontSize: json['captionFontSize'] as double?,
    fontWeight: json['fontWeight'] as String?,
    lineHeight: json['lineHeight'] as double?,
    // Layout & Spacing
    spacing: json['spacing'] as double?,
    smallSpacing: json['smallSpacing'] as double?,
    largeSpacing: json['largeSpacing'] as double?,
    padding: json['padding'] as double?,
    borderRadius: json['borderRadius'] as double?,
    borderWidth: json['borderWidth'] as double?,
    // Component Styles
    buttonHeight: json['buttonHeight'] as double?,
    buttonBorderRadius: json['buttonBorderRadius'] as double?,
    textFieldHeight: json['textFieldHeight'] as double?,
    textFieldBorderRadius: json['textFieldBorderRadius'] as double?,
    cardElevation: json['cardElevation'] as double?,
    cardBorderRadius: json['cardBorderRadius'] as double?,
    // App Bar & Navigation
    appBarHeight: json['appBarHeight'] as double?,
    appBarBackgroundColor: json['appBarBackgroundColor'] as int?,
    appBarTextColor: json['appBarTextColor'] as int?,
    appBarElevation: json['appBarElevation'] as bool?,
    bottomNavBackgroundColor: json['bottomNavBackgroundColor'] as int?,
    bottomNavSelectedColor: json['bottomNavSelectedColor'] as int?,
    bottomNavUnselectedColor: json['bottomNavUnselectedColor'] as int?,
    // Dark/Light Mode
    isDarkMode: json['isDarkMode'] as bool? ?? false,
    allowThemeToggle: json['allowThemeToggle'] as bool? ?? true,
    // Animation & Effects
    animationDuration: json['animationDuration'] as int?,
    animationCurve: json['animationCurve'] as String?,
    enableRippleEffect: json['enableRippleEffect'] as bool?,
    enableShadows: json['enableShadows'] as bool?,
  );

  Map<String, dynamic> toJson() => {
    // Colors
    if (primaryColor != null) 'primaryColor': primaryColor,
    if (secondaryColor != null) 'secondaryColor': secondaryColor,
    if (backgroundColor != null) 'backgroundColor': backgroundColor,
    if (surfaceColor != null) 'surfaceColor': surfaceColor,
    if (textColor != null) 'textColor': textColor,
    if (secondaryTextColor != null) 'secondaryTextColor': secondaryTextColor,
    if (errorColor != null) 'errorColor': errorColor,
    if (successColor != null) 'successColor': successColor,
    if (warningColor != null) 'warningColor': warningColor,
    if (infoColor != null) 'infoColor': infoColor,
    // Typography
    if (fontFamily != null) 'fontFamily': fontFamily,
    if (fontSize != null) 'fontSize': fontSize,
    if (headlineFontSize != null) 'headlineFontSize': headlineFontSize,
    if (titleFontSize != null) 'titleFontSize': titleFontSize,
    if (captionFontSize != null) 'captionFontSize': captionFontSize,
    if (fontWeight != null) 'fontWeight': fontWeight,
    if (lineHeight != null) 'lineHeight': lineHeight,
    // Layout & Spacing
    if (spacing != null) 'spacing': spacing,
    if (smallSpacing != null) 'smallSpacing': smallSpacing,
    if (largeSpacing != null) 'largeSpacing': largeSpacing,
    if (padding != null) 'padding': padding,
    if (borderRadius != null) 'borderRadius': borderRadius,
    if (borderWidth != null) 'borderWidth': borderWidth,
    // Component Styles
    if (buttonHeight != null) 'buttonHeight': buttonHeight,
    if (buttonBorderRadius != null) 'buttonBorderRadius': buttonBorderRadius,
    if (textFieldHeight != null) 'textFieldHeight': textFieldHeight,
    if (textFieldBorderRadius != null) 'textFieldBorderRadius': textFieldBorderRadius,
    if (cardElevation != null) 'cardElevation': cardElevation,
    if (cardBorderRadius != null) 'cardBorderRadius': cardBorderRadius,
    // App Bar & Navigation
    if (appBarHeight != null) 'appBarHeight': appBarHeight,
    if (appBarBackgroundColor != null) 'appBarBackgroundColor': appBarBackgroundColor,
    if (appBarTextColor != null) 'appBarTextColor': appBarTextColor,
    if (appBarElevation != null) 'appBarElevation': appBarElevation,
    if (bottomNavBackgroundColor != null) 'bottomNavBackgroundColor': bottomNavBackgroundColor,
    if (bottomNavSelectedColor != null) 'bottomNavSelectedColor': bottomNavSelectedColor,
    if (bottomNavUnselectedColor != null) 'bottomNavUnselectedColor': bottomNavUnselectedColor,
    // Dark/Light Mode
    'isDarkMode': isDarkMode,
    'allowThemeToggle': allowThemeToggle,
    // Animation & Effects
    if (animationDuration != null) 'animationDuration': animationDuration,
    if (animationCurve != null) 'animationCurve': animationCurve,
    if (enableRippleEffect != null) 'enableRippleEffect': enableRippleEffect,
    if (enableShadows != null) 'enableShadows': enableShadows,
  };

  HostAppThemeConfig copyWith({
    // Colors
    int? primaryColor,
    int? secondaryColor,
    int? backgroundColor,
    int? surfaceColor,
    int? textColor,
    int? secondaryTextColor,
    int? errorColor,
    int? successColor,
    int? warningColor,
    int? infoColor,
    // Typography
    String? fontFamily,
    double? fontSize,
    double? headlineFontSize,
    double? titleFontSize,
    double? captionFontSize,
    String? fontWeight,
    double? lineHeight,
    // Layout & Spacing
    double? spacing,
    double? smallSpacing,
    double? largeSpacing,
    double? padding,
    double? borderRadius,
    double? borderWidth,
    // Component Styles
    double? buttonHeight,
    double? buttonBorderRadius,
    double? textFieldHeight,
    double? textFieldBorderRadius,
    double? cardElevation,
    double? cardBorderRadius,
    // App Bar & Navigation
    double? appBarHeight,
    int? appBarBackgroundColor,
    int? appBarTextColor,
    bool? appBarElevation,
    int? bottomNavBackgroundColor,
    int? bottomNavSelectedColor,
    int? bottomNavUnselectedColor,
    // Dark/Light Mode
    bool? isDarkMode,
    bool? allowThemeToggle,
    // Animation & Effects
    int? animationDuration,
    String? animationCurve,
    bool? enableRippleEffect,
    bool? enableShadows,
  }) => HostAppThemeConfig(
    // Colors
    primaryColor: primaryColor ?? this.primaryColor,
    secondaryColor: secondaryColor ?? this.secondaryColor,
    backgroundColor: backgroundColor ?? this.backgroundColor,
    surfaceColor: surfaceColor ?? this.surfaceColor,
    textColor: textColor ?? this.textColor,
    secondaryTextColor: secondaryTextColor ?? this.secondaryTextColor,
    errorColor: errorColor ?? this.errorColor,
    successColor: successColor ?? this.successColor,
    warningColor: warningColor ?? this.warningColor,
    infoColor: infoColor ?? this.infoColor,
    // Typography
    fontFamily: fontFamily ?? this.fontFamily,
    fontSize: fontSize ?? this.fontSize,
    headlineFontSize: headlineFontSize ?? this.headlineFontSize,
    titleFontSize: titleFontSize ?? this.titleFontSize,
    captionFontSize: captionFontSize ?? this.captionFontSize,
    fontWeight: fontWeight ?? this.fontWeight,
    lineHeight: lineHeight ?? this.lineHeight,
    // Layout & Spacing
    spacing: spacing ?? this.spacing,
    smallSpacing: smallSpacing ?? this.smallSpacing,
    largeSpacing: largeSpacing ?? this.largeSpacing,
    padding: padding ?? this.padding,
    borderRadius: borderRadius ?? this.borderRadius,
    borderWidth: borderWidth ?? this.borderWidth,
    // Component Styles
    buttonHeight: buttonHeight ?? this.buttonHeight,
    buttonBorderRadius: buttonBorderRadius ?? this.buttonBorderRadius,
    textFieldHeight: textFieldHeight ?? this.textFieldHeight,
    textFieldBorderRadius: textFieldBorderRadius ?? this.textFieldBorderRadius,
    cardElevation: cardElevation ?? this.cardElevation,
    cardBorderRadius: cardBorderRadius ?? this.cardBorderRadius,
    // App Bar & Navigation
    appBarHeight: appBarHeight ?? this.appBarHeight,
    appBarBackgroundColor: appBarBackgroundColor ?? this.appBarBackgroundColor,
    appBarTextColor: appBarTextColor ?? this.appBarTextColor,
    appBarElevation: appBarElevation ?? this.appBarElevation,
    bottomNavBackgroundColor: bottomNavBackgroundColor ?? this.bottomNavBackgroundColor,
    bottomNavSelectedColor: bottomNavSelectedColor ?? this.bottomNavSelectedColor,
    bottomNavUnselectedColor: bottomNavUnselectedColor ?? this.bottomNavUnselectedColor,
    // Dark/Light Mode
    isDarkMode: isDarkMode ?? this.isDarkMode,
    allowThemeToggle: allowThemeToggle ?? this.allowThemeToggle,
    // Animation & Effects
    animationDuration: animationDuration ?? this.animationDuration,
    animationCurve: animationCurve ?? this.animationCurve,
    enableRippleEffect: enableRippleEffect ?? this.enableRippleEffect,
    enableShadows: enableShadows ?? this.enableShadows,
  );
}
