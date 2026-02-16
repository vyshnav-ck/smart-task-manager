import '../entities/task_entity.dart';

abstract class TaskRepository {
  Future<Map<String, dynamic>> fetchTasks({
  required String userId,
  required int skip,
  required int limit,
});

  Future<void> createTask({
  required String userId,
  required Map<String, dynamic> body,
}); 

Future<void> updateTask({
  required int taskId,
  required String userId,
  required Map<String, dynamic> body,
});

Future<void> deleteTask({
  required int taskId,
  required String userId,
});

}
