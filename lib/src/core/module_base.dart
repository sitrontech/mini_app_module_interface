// ===============================================
// lib/src/core/module_base.dart
// ===============================================

import 'package:flutter/material.dart';

import 'host_communication.dart';
import 'module_config.dart';
import 'module_lifecycle.dart';

/// Base class for all modules
abstract class MiniAppModuleBase extends StatefulWidget {
  final MiniAppModuleConfig config;
  final void Function(String eventType, Map<String, dynamic> data)? onHostEvent;

  const MiniAppModuleBase({super.key, required this.config, this.onHostEvent});

  /// Create the main widget for this module
  Widget buildModule(BuildContext context);

  /// Module metadata
  Map<String, dynamic> get moduleMetadata;

  /// Required permissions
  List<String> get requiredPermissions => [];

  /// Can this module activate with current config?
  bool canActivate() => true;

  @override
  State<MiniAppModuleBase> createState() => _MiniAppModuleBaseState();
}

class _MiniAppModuleBaseState extends State<MiniAppModuleBase> with MiniAppModuleLifecycleMixin {
  @override
  void onModuleInit() {
    HostCommunicationService.initialize(moduleId: widget.config.moduleId, onEvent: widget.onHostEvent);
  }

  @override
  void onModuleDispose() {
    HostCommunicationService.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.canActivate()) {
      return _buildErrorWidget('Module cannot activate with current configuration');
    }

    try {
      return widget.buildModule(context);
    } catch (error, stackTrace) {
      HostCommunicationService.reportError(error.toString(), 'module_build', stackTrace);
      return _buildErrorWidget('Error building module: $error');
    }
  }

  Widget _buildErrorWidget(String message) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Error - ${widget.config.moduleId}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => HostCommunicationService.requestClose(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: () => HostCommunicationService.requestClose(), child: const Text('Go Back')),
          ],
        ),
      ),
    );
  }
}
