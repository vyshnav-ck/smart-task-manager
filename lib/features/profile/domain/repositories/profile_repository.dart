import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<void> createProfile(ProfileEntity profile);
  Future<ProfileEntity> getProfile(String userId);
  Future<void> updateProfile(ProfileEntity profile);
}
