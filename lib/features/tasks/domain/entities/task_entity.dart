class TaskEntity {

final int id;
final String title;
final String priority;
final String category;
final DateTime dueDate;
final bool isCompleted;
final DateTime createdAt;

  TaskEntity({
  required this.id,
  required this.title,
  required this.priority,
  required this.category,
  required this.dueDate,
  required this.isCompleted,
  required this.createdAt,
});

TaskEntity copyWith({
  String? title,
  String? priority,
  String? category,
  DateTime? dueDate,
  bool? isCompleted,
}) {
  return TaskEntity(
    id: id,
    title: title ?? this.title,
    priority: priority ?? this.priority,
    category: category ?? this.category,
    dueDate: dueDate ?? this.dueDate,
    isCompleted: isCompleted ?? this.isCompleted,
    createdAt: createdAt,
  );
}
}
