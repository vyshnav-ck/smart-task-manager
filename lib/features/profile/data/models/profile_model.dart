import '../../domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  ProfileModel({
    required super.id,
    required super.name,
    required super.email,
    required super.createdAt,
    required super.isDarkMode,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map, String id) {
    return ProfileModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
      isDarkMode: map['themeMode'] == 'dark',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'createdAt': createdAt.toIso8601String(),
      'themeMode': isDarkMode ? 'dark' : 'light',
    };
  }
}
