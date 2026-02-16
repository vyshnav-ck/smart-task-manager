import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_firestore_datasource.dart';
import '../models/profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileFirestoreDataSource dataSource;

  ProfileRepositoryImpl(this.dataSource);

  @override
  Future<void> createProfile(ProfileEntity profile) async {
    final model = ProfileModel(
      id: profile.id,
      name: profile.name,
      email: profile.email,
      createdAt: profile.createdAt,
      isDarkMode: profile.isDarkMode,
    );
    await dataSource.createProfile(model);
  }

  @override
  Future<ProfileEntity> getProfile(String userId) async {
    return await dataSource.getProfile(userId);
  }

  @override
  Future<void> updateProfile(ProfileEntity profile) async {
    final model = ProfileModel(
      id: profile.id,
      name: profile.name,
      email: profile.email,
      createdAt: profile.createdAt,
      isDarkMode: profile.isDarkMode,
    );
    await dataSource.updateProfile(model);
  }
}
