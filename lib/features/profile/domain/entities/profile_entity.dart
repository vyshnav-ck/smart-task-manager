class ProfileEntity {
  final String id;
  final String name;
  final String email;
  final DateTime createdAt;
  final bool isDarkMode;

  ProfileEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.isDarkMode,
  });
}
