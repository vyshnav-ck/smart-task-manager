import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import 'task_providers.dart';
import '../../presentation/screens/edit_task_screen.dart';


class TaskController
    extends StateNotifier<AsyncValue<List<TaskEntity>>> {
  final TaskRepository _repository;

  TaskController(this._repository)
      : super(const AsyncData([]));

  int _skip = 0;
  final int _limit = 10;
  bool _hasMore = true;
  bool _isLoadingMore = false;
  bool get hasMore => _hasMore;

  Future<void> fetchTasks(String userId) async {
    state = const AsyncLoading();
      _skip = 0;
   final result = await _repository.fetchTasks(
  userId: userId,
  skip: _skip,
  limit: _limit,
);

final tasks = result["tasks"];

_hasMore = tasks.length == _limit;
if (tasks.length < _limit) {
  _hasMore = false;
}
state = AsyncData(tasks);
  }

  Future<void> loadMore(String userId) async {
    print("LOAD MORE TRIGGERED");
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;

    final current = state.value ?? [];

    try {
      _skip += _limit;

final result = await _repository.fetchTasks(
  userId: userId,
  skip: _skip,
  limit: _limit,
);

final newTasks = result["tasks"];

_hasMore = newTasks.length == _limit;

state = AsyncData([...current, ...newTasks]);

    } catch (e, st) {
      state = AsyncError(e, st);
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> createTask({
  required String userId,
  required String title,
  required String priority,
  required String category,
  required DateTime dueDate,
}) async {
    try {
      await _repository.createTask(
  userId: userId,
  body: {
    "title": title,
    "priority": priority,
    "category": category,
    "due_date": dueDate.toIso8601String(),
  },
);

      await fetchTasks(userId);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

Future<void> updateTask({
  required int taskId,
  required String userId,
  required Map<String, dynamic> body,
}) async {
  final current = state.value ?? [];

  // Optimistic update
  final updated = current.map((task) {
    if (task.id == taskId) {
      return task.copyWith(
        title: body["title"] ?? task.title,
        priority: body["priority"] ?? task.priority,
        category: body["category"] ?? task.category,
        dueDate: body["due_date"] != null
            ? DateTime.parse(body["due_date"])
            : task.dueDate,
        isCompleted:
            body["is_completed"] ?? task.isCompleted,
      );
    }
    return task;
  }).toList();

  state = AsyncData(updated);

  try {
    await _repository.updateTask(
      taskId: taskId,
      userId: userId,
      body: body,
    );
  } catch (e, st) {
    state = AsyncError(e, st);
  }
}

Future<void> deleteTask(int taskId, String userId) async {
  final current = state.value ?? [];

  // Optimistic update
  final updated =
      current.where((t) => t.id != taskId).toList();
  state = AsyncData(updated);

  try {
    await _repository.deleteTask(
      taskId: taskId,
      userId: userId,
    );
  } catch (e) {
    // revert if failed
    state = AsyncData(current);
    rethrow;
  }
}

}

final taskControllerProvider = StateNotifierProvider<
    TaskController, AsyncValue<List<TaskEntity>>>(
  (ref) => TaskController(ref.read(taskRepositoryProvider)),
);
