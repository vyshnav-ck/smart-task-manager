import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/datasources/profile_firestore_datasource.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/repositories/profile_repository.dart';

final firestoreProvider =
    Provider((ref) => FirebaseFirestore.instance);

final profileDataSourceProvider =
    Provider((ref) => ProfileFirestoreDataSource(
          ref.read(firestoreProvider),
        ));

final profileRepositoryProvider =
    Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(
    ref.read(profileDataSourceProvider),
  );
});
