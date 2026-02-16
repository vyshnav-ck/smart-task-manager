import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_provider.dart';
import '../../data/datasources/task_remote_datasource.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../domain/repositories/task_repository.dart';

final taskRemoteDataSourceProvider =
    Provider((ref) => TaskRemoteDataSource(ref.read(dioProvider)));

final taskRepositoryProvider = Provider<TaskRepository>(
  (ref) => TaskRepositoryImpl(
    ref.read(taskRemoteDataSourceProvider),
  ),
);
