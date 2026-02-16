import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import 'profile_providers.dart';

class ProfileController
    extends StateNotifier<AsyncValue<ProfileEntity?>> {
  final ProfileRepository _repository;

  ProfileController(this._repository)
      : super(const AsyncData(null));

  Future<void> loadProfile(String userId) async {
    state = const AsyncLoading();
    try {
      final profile = await _repository.getProfile(userId);
      state = AsyncData(profile);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> updateTheme(bool isDark) async {
    final current = state.value;
    if (current == null) return;

    final updated = ProfileEntity(
      id: current.id,
      name: current.name,
      email: current.email,
      createdAt: current.createdAt,
      isDarkMode: isDark,
    );

    await _repository.updateProfile(updated);
    state = AsyncData(updated);
  }
}

final profileControllerProvider = StateNotifierProvider<
    ProfileController, AsyncValue<ProfileEntity?>>(
  (ref) =>
      ProfileController(ref.read(profileRepositoryProvider)),
);
