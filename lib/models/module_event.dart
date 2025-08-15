// ===============================================
// lib/src/models/module_event.dart
// ===============================================

/// Event model for module communication
class ModuleEvent {
  final String type;
  final String moduleId;
  final Map<String, dynamic> data;
  final DateTime timestamp;

  ModuleEvent({required this.type, required this.moduleId, this.data = const {}, DateTime? timestamp})
    : timestamp = timestamp ?? DateTime.now();

  factory ModuleEvent.fromMap(Map<String, dynamic> map) {
    return ModuleEvent(
      type: map['type'] as String,
      moduleId: map['moduleId'] as String,
      data: map['data'] as Map<String, dynamic>? ?? {},
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }

  Map<String, dynamic> toMap() => {
    'type': type,
    'moduleId': moduleId,
    'data': data,
    'timestamp': timestamp.toIso8601String(),
  };
}
