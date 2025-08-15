// ===============================================
// lib/src/services/navigation_service.dart
// ===============================================

import '../core/host_communication.dart';

/// Navigation service for modules
class ModuleNavigationService {
  static void goToRoute(String route, [Map<String, dynamic>? params]) {
    HostCommunicationService.requestNavigation(route, params);
  }

  static void goBack([String? reason]) {
    HostCommunicationService.requestClose(reason);
  }

  static void logout([String? reason]) {
    HostCommunicationService.requestLogout(reason);
  }
}
