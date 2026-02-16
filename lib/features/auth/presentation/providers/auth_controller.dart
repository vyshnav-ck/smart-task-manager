import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_providers.dart';
import '../../../profile/domain/entities/profile_entity.dart';
import '../../../profile/presentation/providers/profile_providers.dart';

class AuthController extends StateNotifier<AsyncValue<void>> {
  final AuthRepository _repository;
  final Ref _ref;

  AuthController(this._repository, this._ref)
      : super(const AsyncData(null));

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    try {
      await _repository.login(email, password);
      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

 Future<void> register(String email, String password) async {
  state = const AsyncLoading();
  try {
    final user = await _repository.register(email, password);

    final profileRepo =
        _ref.read(profileRepositoryProvider);

    await profileRepo.createProfile(
      ProfileEntity(
        id: user.id,
        name: "New User",
        email: user.email,
        createdAt: DateTime.now(),
        isDarkMode: false,
      ),
    );

    state = const AsyncData(null);
  } catch (e) {
    state = AsyncError(e, StackTrace.current);
  }
}

  Future<void> logout() async {
    await _repository.logout();
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>(
  (ref) => AuthController(
    ref.read(authRepositoryProvider),
    ref,
  ),
);
