// ===============================================
// lib/src/models/module_result.dart
// ===============================================

/// Result model for module operations
class ModuleResult<T> {
  final T? data;
  final String? error;
  final bool isSuccess;
  final Map<String, dynamic> metadata;

  const ModuleResult.success(this.data, {this.metadata = const {}}) : error = null, isSuccess = true;

  const ModuleResult.error(this.error, {this.metadata = const {}}) : data = null, isSuccess = false;

  Map<String, dynamic> toMap() => {'data': data, 'error': error, 'isSuccess': isSuccess, 'metadata': metadata};
}
