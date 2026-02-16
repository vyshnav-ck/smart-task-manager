import 'package:dio/dio.dart';
import '../models/task_model.dart';

class TaskRemoteDataSource {
  final Dio dio;

  TaskRemoteDataSource(this.dio);

Future<void> createTask({
  required String userId,
  required Map<String, dynamic> body,
}) async {
  try {
    final response = await dio.post(
      '/tasks/',
      queryParameters: {
        'user_id': userId,
      },
      data: body,
    );

    print("CREATE SUCCESS: ${response.data}");
  } on DioException catch (e) {
    print("CREATE ERROR: ${e.response?.data}");
    rethrow;
  }
}

 Future<Map<String, dynamic>> fetchTasks({
  required String userId,
  required int skip,
  required int limit,
}) async {
  print("FETCH TASKS → skip: $skip, limit: $limit");

  final response = await dio.get(
    '/tasks/',
    queryParameters: {
      'user_id': userId,
      'skip': skip,
      'limit': limit,
    },
  );

  final data = response.data;

  print("API RESPONSE: $data");

  final List items = data['data'] ?? [];
  final int total = data['total'] ?? items.length;

  final tasks =
      items.map((e) => TaskModel.fromMap(e)).toList();

  return {
    "tasks": tasks,
    "total": total,
  };
}

Future<void> updateTask({
  required int taskId,
  required String userId,
  required Map<String, dynamic> body,
}) async {
  await dio.put(
    '/tasks/$taskId',
    data: body,
    queryParameters: {
      'user_id': userId,
    },
  );
}

Future<void> deleteTask({
  required int taskId,
  required String userId,
}) async {
  await dio.delete(
    '/tasks/$taskId',
    queryParameters: {
      'user_id': userId,
    },
  );
}

}
