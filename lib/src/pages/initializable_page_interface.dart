import 'dart:async';

import 'package:flutter/material.dart';

/// Generic interface สำหรับ page ที่ต้องการ initialization callback
abstract class InitializablePage {
  /// Callback เมื่อ page initialize เสร็จ
  VoidCallback? get onInitialized;

  /// สร้าง page ใหม่พร้อม initialization callback
  Widget createWithInitializationCallback(VoidCallback onInitialized);
}

/// Interface สำหรับ page ที่สามารถ configure ได้
abstract class ConfigurablePage {
  /// Configuration ของ page
  get config;

  /// Host event callback
  get onHostEvent;
}

/// รวม interface สำหรับ page ที่ทั้ง initializable และ configurable
abstract class MiniAppPageBase implements InitializablePage, ConfigurablePage {}

/// Mixin สำหรับ pages ที่ต้องการ initialization handling
mixin PageInitializationMixin {
  /// Handle page initialization with callback
  void handlePageInitialization({
    required VoidCallback? onInitialized,
    Duration initializationDelay = const Duration(milliseconds: 1500),
    String? pageName,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(initializationDelay, () {
        debugPrint('🎉 ${pageName ?? "Page"} initialization completed');
        onInitialized?.call();
      });
    });
  }
}

/// Mixin สำหรับ loading pages (splash, loading screens, etc.)
mixin LoadingPageMixin {
  /// Handle loading state with progress
  void handleLoadingState({
    required VoidCallback? onLoadingComplete,
    Duration loadingDuration = const Duration(milliseconds: 2000),
    String? loadingMessage,
    VoidCallback? onProgressUpdate,
  }) {
    debugPrint('🔄 Loading started: ${loadingMessage ?? "Initializing..."}');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Simulate progress updates
      final progressInterval = loadingDuration.inMilliseconds ~/ 4;

      Timer.periodic(Duration(milliseconds: progressInterval), (timer) {
        onProgressUpdate?.call();

        if (timer.tick >= 4) {
          timer.cancel();
          debugPrint('✅ Loading completed');
          onLoadingComplete?.call();
        }
      });
    });
  }
}
