import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_remote_datasource.dart';
import 'package:hive/hive.dart';
import '../../data/models/task_model.dart';


class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remote;

  TaskRepositoryImpl(this.remote);

  @override
Future<void> createTask({
  required String userId,
  required Map<String, dynamic> body,
}) async {
  await remote.createTask(
    userId: userId,
    body: body,
  );
}

@override
Future<Map<String, dynamic>> fetchTasks({
  required String userId,
  required int skip,
  required int limit,
}) async {
  final box = Hive.box('tasks');

  try {
  final result = await remote.fetchTasks(
    userId: userId,
    skip: skip,
    limit: limit,
  );

  final List tasks = result["tasks"];

 
  final newTasks = tasks
      .map((t) => (t as TaskModel).toMap())
      .toList();

 
  final existing = box.get(userId, defaultValue: []);

  final List existingList = List.from(existing);

  
  final Map<dynamic, dynamic> merged = {
    for (var t in existingList) t['id']: t,
    for (var t in newTasks) t['id']: t,
  };

  box.put(userId, merged.values.toList());

  return result;
}
 catch (e) {
  final cached = box.get(userId);

  if (cached != null) {
    final tasks = (cached as List)
        .map((e) => TaskModel.fromMap(
            Map<String, dynamic>.from(e)))
        .toList();

    return {
      "tasks": tasks,
      "total": tasks.length,
    };
  }

  rethrow;
}
}

@override
Future<void> updateTask({
  required int taskId,
  required String userId,
  required Map<String, dynamic> body,
}) async {
  await remote.updateTask(
    taskId: taskId,
    userId: userId,
    body: body,
  );
}

@override
Future<void> deleteTask({
  required int taskId,
  required String userId,
}) async {
  await remote.deleteTask(
    taskId: taskId,
    userId: userId,
  );
}

}
