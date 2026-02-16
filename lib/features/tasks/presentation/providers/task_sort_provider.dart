import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TaskSort {
  createdDate,
  dueDate,
  priority,
}

final taskSortProvider =
    StateProvider<TaskSort>((ref) => TaskSort.createdDate);
