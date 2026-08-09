import 'dart:convert';

enum FamilyRole {
  grandparent,
  parent,
  teen,
  child;

  static FamilyRole? fromStorageValue(String? value) {
    for (final FamilyRole role in FamilyRole.values) {
      if (role.name == value) {
        return role;
      }
    }

    return null;
  }
}

class FamilyProfile {
  const FamilyProfile({required this.nickname, required this.role});

  final String nickname;
  final FamilyRole role;

  String toJsonString() {
    return jsonEncode(<String, String>{
      'nickname': nickname,
      'role': role.name,
    });
  }

  static FamilyProfile? fromJsonString(String? source) {
    if (source == null || source.trim().isEmpty) {
      return null;
    }

    try {
      final Object? decoded = jsonDecode(source);

      if (decoded is! Map<String, dynamic>) {
        return null;
      }

      final Object? nicknameValue = decoded['nickname'];
      final Object? roleValue = decoded['role'];

      if (nicknameValue is! String || roleValue is! String) {
        return null;
      }

      final String normalizedNickname = nicknameValue.trim();
      final FamilyRole? role = FamilyRole.fromStorageValue(roleValue);

      if (normalizedNickname.isEmpty || role == null) {
        return null;
      }

      return FamilyProfile(nickname: normalizedNickname, role: role);
    } on FormatException {
      return null;
    }
  }

  @override
  bool operator ==(Object other) {
    return other is FamilyProfile &&
        other.nickname == nickname &&
        other.role == role;
  }

  @override
  int get hashCode => Object.hash(nickname, role);
}
