import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_task_manager/core/theme/theme_provider.dart';
import '../../domain/entities/task_entity.dart';
import '../providers/task_controller.dart';
import '../providers/task_filter_provider.dart';
import '../../presentation/screens/edit_task_screen.dart';
import '../providers/task_sort_provider.dart';
import 'package:smart_task_manager/features/profile/presentation/screens/profile_screen.dart';
import 'create_task_screen.dart';



class TaskListScreen extends ConsumerStatefulWidget {
  final String userId;

  const TaskListScreen({super.key, required this.userId});

  @override
  ConsumerState<TaskListScreen> createState() =>
      _TaskListScreenState();
}

class _TaskListScreenState
    extends ConsumerState<TaskListScreen> {
    
  @override
void initState() {
  super.initState();

  Future.microtask(() {
    ref
        .read(taskControllerProvider.notifier)
        .fetchTasks(widget.userId);
  });

}

  @override
  Widget build(BuildContext context) {
    final taskState = ref.watch(taskControllerProvider);
    final controller = ref.read(taskControllerProvider.notifier);
    final filter = ref.watch(taskFilterProvider);
final searchQuery = ref.watch(taskSearchProvider);
final sort = ref.watch(taskSortProvider);



    return Scaffold(
  backgroundColor:
      Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.2),
 appBar: AppBar(
  title: const Text(
    "Dashboard",
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 22,
    ),
  ),
  actions: [

    IconButton(
  icon: Icon(
    ref.watch(themeModeProvider) == ThemeMode.dark
        ? Icons.light_mode
        : Icons.dark_mode,
  ),
  onPressed: () {
    final current =
        ref.read(themeModeProvider.notifier).state;

    ref.read(themeModeProvider.notifier).state =
        current == ThemeMode.dark
            ? ThemeMode.light
            : ThemeMode.dark;
  },
),
    IconButton(
      icon: const Icon(Icons.sort),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (_) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: TaskSort.values.map((s) {
                return ListTile(
                  title: Text(s.name.toUpperCase()),
                  onTap: () {
                    ref
                        .read(taskSortProvider.notifier)
                        .state = s;
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            );
          },
        );
      },
    ),
  ],
),
 floatingActionButton: FloatingActionButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            CreateTaskScreen(userId: widget.userId),
      ),
    );
  },
  backgroundColor:
      Theme.of(context).colorScheme.primary,
  foregroundColor: Colors.white,
  elevation: 6,
  child: const Icon(Icons.add, size: 28),
),
      body: Column(
  children: [
    Padding(
  padding: const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 8,
  ),
  child: Card(
    elevation: 1,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
    ),
    child: TextField(
      decoration: InputDecoration(
  hintText: "Search tasks...",
  prefixIcon: const Icon(Icons.search),
  filled: true,
  fillColor: Theme.of(context)
      .colorScheme
      .surfaceVariant
      .withOpacity(0.4),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide.none,
  ),
),
      onChanged: (value) {
        ref.read(taskSearchProvider.notifier).state = value;
      },
    ),
  ),
),

    SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding:
            const EdgeInsets.symmetric(horizontal: 12),
        children: TaskFilter.values.map((f) {
          final isSelected = filter == f;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
  label: Text(
    f.name.toUpperCase(),
    style: TextStyle(
      fontWeight: FontWeight.w600,
      color: isSelected
          ? Theme.of(context).colorScheme.primary
          : null,
    ),
  ),
  selected: isSelected,
  onSelected: (_) {
    ref
        .read(taskFilterProvider.notifier)
        .state = f;
  },
  selectedColor:
      Theme.of(context).colorScheme.primary.withOpacity(0.15),
  backgroundColor:
      Theme.of(context).colorScheme.surface,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  side: BorderSide(
    color: isSelected
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).dividerColor,
  ),
),
          );
        }).toList(),
      ),
    ),

    Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(taskControllerProvider.notifier)
              .fetchTasks(widget.userId);
        },
        child: taskState.when(
          loading: () =>
              const Center(child: CircularProgressIndicator()),
          error: (e, _) =>
              Center(child: Text("Error: $e")),
          data: (tasks) {
            
            var filteredTasks = tasks;

            
            if (filter == TaskFilter.completed) {
              filteredTasks =
                  tasks.where((t) => t.isCompleted).toList();
            } else if (filter == TaskFilter.pending) {
              filteredTasks =
                  tasks.where((t) => !t.isCompleted).toList();
            }

            
            if (searchQuery.isNotEmpty) {
              filteredTasks = filteredTasks
                  .where((t) => t.title
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase()))
                  .toList();
            }

            
if (sort == TaskSort.dueDate) {
  filteredTasks.sort(
      (a, b) => a.dueDate.compareTo(b.dueDate));
} else if (sort == TaskSort.priority) {
  const priorityOrder = {
    "High": 0,
    "Medium": 1,
    "Low": 2,
  };

  filteredTasks.sort((a, b) =>
      (priorityOrder[a.priority] ?? 3)
          .compareTo(priorityOrder[b.priority] ?? 3));
} else {
  // created date (default)
  filteredTasks.sort(
      (a, b) => b.createdAt.compareTo(a.createdAt));
}

            if (filteredTasks.isEmpty) {
              return const Center(
                child: Text("No tasks found"),
              );
            }

            final controller =
                ref.read(taskControllerProvider.notifier);

            return ListView.builder(
              itemCount: controller.hasMore
                  ? filteredTasks.length + 1
                  : filteredTasks.length,
              itemBuilder: (context, index) {
                if (index == filteredTasks.length) {
                  controller.loadMore(widget.userId);

                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final task = filteredTasks[index];
                return Dismissible(
  key: ValueKey(task.id),
  direction: DismissDirection.endToStart,
  background: Container(
    color: Colors.red,
    alignment: Alignment.centerRight,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: const Icon(Icons.delete, color: Colors.white),
  ),
  onDismissed: (_) {
    ref
        .read(taskControllerProvider.notifier)
        .deleteTask(task.id as int, widget.userId);
  },
  
 child: _TaskTile(
  task: task,
  userId: widget.userId,
)
);
              },
            );
          },
        ),
      ),
    ),
  ],
),
    );
  }
}

class _TaskTile extends ConsumerWidget {
  final task;
  final String userId;

  const _TaskTile({
    required this.task,
    required this.userId,
  });

  @override
Widget build(BuildContext context, WidgetRef ref) {
  return Card(
    margin: const EdgeInsets.symmetric(
  horizontal: 16,
  vertical: 8,
    ),
    shape: RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(14),
  side: BorderSide(
    color: Theme.of(context)
        .colorScheme
        .primary
        .withOpacity(0.08),
  ),
),
    child: ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EditTaskScreen(
              task: task,
              userId: userId,
            ),
          ),
        );
      },
      title: Text(
  task.title,
  maxLines: 1,
  overflow: TextOverflow.ellipsis,
  style: TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: task.isCompleted ? Colors.grey : null,
    decoration: task.isCompleted
        ? TextDecoration.lineThrough
        : TextDecoration.none,
  ),
),
      subtitle: Text(
        "${task.priority} • ${task.category}",
      ),
      trailing: Checkbox(
  value: task.isCompleted,
  onChanged: (value) {
    ref
        .read(taskControllerProvider.notifier)
        .updateTask(
          taskId: task.id,
          userId: userId,
          body: {
            "title": task.title,
            "priority": task.priority,
            "category": task.category,
            "due_date": task.dueDate.toIso8601String(),
            "is_completed": value ?? false,
          },
        );
  },
),
    ),
    
  );
  
}
  
}

Widget _priorityBadge(String priority) {
  Color color;

  switch (priority) {
    case "High":
      color = const Color(0xFFE53935);
      break;
    case "Medium":
      color = const Color(0xFFFFA726);
      break;
    default:
      color = const Color(0xFF43A047);
  }

  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 8,
      vertical: 4,
    ),
    decoration: BoxDecoration(
      color: color.withOpacity(0.15),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      priority,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
    ),
  );
}
void _showCreateDialog(
    BuildContext context, WidgetRef ref, String userId) {
  final controller = TextEditingController();

}
