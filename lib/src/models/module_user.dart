// ===============================================
// lib/src/models/module_user.dart
// ===============================================

/// Generic user model for modules
class ModuleUser {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final Map<String, dynamic> metadata;

  const ModuleUser({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.metadata = const {},
  });

  factory ModuleUser.fromMap(Map<String, dynamic> data) {
    return ModuleUser(
      id: data['id'] as String? ?? '',
      name: data['name'] as String? ?? 'Unknown',
      email: data['email'] as String? ?? '',
      avatarUrl: data['avatarUrl'] as String?,
      metadata: data['metadata'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'email': email,
    'avatarUrl': avatarUrl,
    'metadata': metadata,
  };

  T? getMetadata<T>(String key) => metadata[key] as T?;

  ModuleUser copyWith({String? id, String? name, String? email, String? avatarUrl, Map<String, dynamic>? metadata}) =>
      ModuleUser(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        metadata: metadata ?? this.metadata,
      );
}
