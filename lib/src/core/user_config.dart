// ===============================================
// lib/src/core/user_data.dart
// User data model for type-safe user information
// ===============================================

// Import nested models for User entity
class AvatarUrl {
  final String id;
  final String url;

  const AvatarUrl({required this.id, required this.url});
}

class UserAction {
  final String code;
  final String description;

  const UserAction({required this.code, required this.description});
}

/// User data model สำหรับเก็บข้อมูลผู้ใช้แบบ type-safe
class HostAppUser {
  /// User ID (Required)
  final String id;

  final bool isKyc;
  final bool isThailandPost;
  final String username;
  final int? birthDate;
  final String? sex;
  final String? phoneNo;
  final String? phoneNoIntl;
  final String? fileAvatarId;
  final String? titleNameTh;
  final String? firstNameTh;
  final String? middleNameTh;
  final String? lastNameTh;
  final String? titleNameEn;
  final String? firstNameEn;
  final String? middleNameEn;
  final String? lastNameEn;

  /// บทบาทของผู้ใช้ (admin, user, guest, etc.)
  final List<String>? roles;
  final AvatarUrl? avatarUrl;

  /// สถานะการใช้งาน
  final String? status;
  final List<UserAction>? userActions;

  const HostAppUser({
    required this.id,
    required this.isKyc,
    required this.isThailandPost,
    required this.username,
    this.birthDate,
    this.sex,
    this.phoneNo,
    this.phoneNoIntl,
    this.fileAvatarId,
    this.titleNameTh,
    this.firstNameTh,
    this.middleNameTh,
    this.lastNameTh,
    this.titleNameEn,
    this.firstNameEn,
    this.middleNameEn,
    this.lastNameEn,
    this.roles,
    this.avatarUrl,
    this.status,
    this.userActions,
  });

  /// สร้างจาก JSON
  factory HostAppUser.fromJson(Map<String, dynamic> json) => HostAppUser(
    id: json['id'] as String,
    isKyc: json['isKyc'] as bool,
    isThailandPost: json['isThailandPost'] as bool,
    username: json['username'] as String,
    birthDate: json['birthDate'] as int,
    sex: json['sex'] as String,
    phoneNo: json['phoneNo'] as String,
    phoneNoIntl: json['phoneNoIntl'] as String,
    fileAvatarId: json['fileAvatarId'] as String,
    titleNameTh: json['titleNameTh'] as String,
    firstNameTh: json['firstNameTh'] as String,
    middleNameTh: json['middleNameTh'] as String,
    lastNameTh: json['lastNameTh'] as String,
    titleNameEn: json['titleNameEn'] as String,
    middleNameEn: json['middleNameEn'] as String,
    lastNameEn: json['lastNameEn'] as String,
    roles: json['roles'] as List<String>,
    avatarUrl: json['avatarUrl'] as AvatarUrl,
    status: json['status'] as String,
    userActions: json['userActions'] as List<UserAction>,
  );

  /// แปลงเป็น JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'isKyc': isKyc,
    'isThailandPost': isThailandPost,
    'username': username,
    'birthDate': birthDate,
    'sex': sex,
    'phoneNo': phoneNo,
    'phoneNoIntl': phoneNoIntl,
    'fileAvatarId': fileAvatarId,
    'titleNameTh': titleNameTh,
    'firstNameTh': firstNameTh,
    'middleNameTh': middleNameTh,
    'lastNameTh': lastNameTh,
    'titleNameEn': titleNameEn,
    'firstNameEn': firstNameEn,
    'middleNameEn': middleNameEn,
    'lastNameEn': lastNameEn,
    'roles': roles,
    'avartarUrl': avatarUrl,
    'status': status,
    'userActions': userActions,
  };

  /// Copy with method
  HostAppUser copyWith({
    String? id,
    bool? isKyc,
    bool? isThailandPost,
    String? username,
    int? birthDate,
    String? sex,
    String? phoneNo,
    String? phoneNoIntl,
    String? fileAvatarId,
    String? titleNameTh,
    String? firstNameTh,
    String? middleNameTh,
    String? lastNameTh,
    String? titleNameEn,
    String? firstNameEn,
    String? middleNameEn,
    String? lastNameEn,
    List<String>? roles,
    AvatarUrl? avatarUrl,
    String? status,
    List<UserAction>? userActions,
  }) => HostAppUser(
    id: id ?? this.id,
    isKyc: isKyc ?? this.isKyc,
    isThailandPost: isThailandPost ?? this.isThailandPost,
    username: username ?? this.username,
    birthDate: birthDate ?? this.birthDate,
    sex: sex ?? this.sex,
    phoneNo: phoneNo ?? this.phoneNo,
    phoneNoIntl: phoneNoIntl ?? this.phoneNoIntl,
    fileAvatarId: fileAvatarId ?? this.fileAvatarId,
    titleNameTh: titleNameTh ?? this.titleNameTh,
    firstNameTh: firstNameTh ?? this.firstNameTh,
    middleNameTh: middleNameTh ?? this.middleNameTh,
    lastNameTh: lastNameTh ?? this.lastNameTh,
    titleNameEn: titleNameEn ?? this.titleNameEn,
    firstNameEn: firstNameEn ?? this.firstNameEn,
    middleNameEn: middleNameEn ?? this.middleNameEn,
    lastNameEn: lastNameEn ?? this.lastNameEn,
    roles: roles ?? this.roles,
    avatarUrl: avatarUrl ?? this.avatarUrl,
    status: status ?? this.status,
    userActions: userActions ?? this.userActions,
  );
}
