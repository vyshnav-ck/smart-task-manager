import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../data/datasources/firebase_auth_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';

// Firebase instance
final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

// Data source
final authDataSourceProvider = Provider<FirebaseAuthDataSource>(
  (ref) => FirebaseAuthDataSource(ref.read(firebaseAuthProvider)),
);

// Repository
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(ref.read(authDataSourceProvider)),
);

// Auth state stream
final authStateProvider = StreamProvider(
  (ref) => ref.read(authRepositoryProvider).authStateChanges(),
);
