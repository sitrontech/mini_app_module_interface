// ===============================================
// lib/src/services/error_service.dart
// ===============================================

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/host_communication.dart';

/// Error handling service for modules
class ModuleErrorService {
  static void handleError(dynamic error, StackTrace? stackTrace, String context) {
    final errorMessage = error.toString();

    if (kDebugMode) {
      print('❌ Module Error in $context: $errorMessage');
      if (stackTrace != null) {
        print('Stack trace: $stackTrace');
      }
    }

    HostCommunicationService.reportError(errorMessage, context, stackTrace);
  }

  static Widget buildErrorWidget(String message, {VoidCallback? onRetry, VoidCallback? onGoBack}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(message, style: const TextStyle(fontSize: 16), textAlign: TextAlign.center),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (onRetry != null) ...[
                  ElevatedButton(onPressed: onRetry, child: const Text('ลองใหม่')),
                  const SizedBox(width: 16),
                ],
                ElevatedButton(
                  onPressed: onGoBack ?? () => HostCommunicationService.requestClose(),
                  child: const Text('กลับ'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
