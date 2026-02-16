import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource dataSource;

  AuthRepositoryImpl(this.dataSource);

  @override
  Future<UserEntity> login(String email, String password) async {
    final user = await dataSource.login(email, password);
    return UserModel.fromFirebaseUser(user);
  }

  @override
  Future<UserEntity> register(String email, String password) async {
    final user = await dataSource.register(email, password);
    return UserModel.fromFirebaseUser(user);
  }

  @override
  Future<void> logout() async {
    await dataSource.logout();
  }

  @override
  Stream<UserEntity?> authStateChanges() {
    return dataSource.authStateChanges().map(
      (user) => user != null ? UserModel.fromFirebaseUser(user) : null,
    );
  }
}
