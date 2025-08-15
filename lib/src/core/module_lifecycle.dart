// ===============================================
// lib/src/core/module_lifecycle.dart
// ===============================================

import 'package:flutter/widgets.dart';

import 'host_communication.dart';

/// Mixin for module lifecycle management
mixin ModuleLifecycleMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    HostCommunicationService.sendEvent(ModuleEventType.ready);
    onModuleInit();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    onModuleDependenciesChanged();
  }

  @override
  void dispose() {
    onModuleDispose();
    HostCommunicationService.sendEvent(ModuleEventType.disposed);
    super.dispose();
  }

  /// Override these methods in your module
  void onModuleInit() {}
  void onModuleDependenciesChanged() {}
  void onModuleDispose() {}
}
