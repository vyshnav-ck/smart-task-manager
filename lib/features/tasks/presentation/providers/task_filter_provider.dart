import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TaskFilter {
  all,
  completed,
  pending,
}

final taskFilterProvider =
    StateProvider<TaskFilter>((ref) => TaskFilter.all);

final taskSearchProvider =
    StateProvider<String>((ref) => '');
