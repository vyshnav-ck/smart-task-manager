import '../../domain/entities/task_entity.dart';


class TaskModel extends TaskEntity {
  TaskModel({
    required super.id,
    required super.title,
    required super.priority,
    required super.category,
    required super.dueDate,
    required super.isCompleted,
    required super.createdAt,
  });

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'] ?? '',
      priority: map['priority'] ?? 'low',
      category: map['category'] ?? '',
      dueDate: DateTime.parse(map['due_date']),
      isCompleted: map['is_completed'] ?? false,
      createdAt: DateTime.parse(map['created_at']),
    );
  }
Map<String, dynamic> toMap() {
  return {
    "id": id,
    "title": title,
    "priority": priority,
    "category": category,
    "due_date": dueDate.toIso8601String(),
    "is_completed": isCompleted,
    "created_at": createdAt.toIso8601String(),
  };
}

}
