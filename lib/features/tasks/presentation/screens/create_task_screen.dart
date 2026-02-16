import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/task_controller.dart';
import '../../data/models/task_model.dart';

class CreateTaskScreen extends ConsumerStatefulWidget {
  final String userId;

  const CreateTaskScreen({super.key, required this.userId});

  @override
  ConsumerState<CreateTaskScreen> createState() =>
      _CreateTaskScreenState();
}

class _CreateTaskScreenState
    extends ConsumerState<CreateTaskScreen> {
  final _titleController = TextEditingController();
  String _priority = "Medium";
  String _category = "Work";
  DateTime? _dueDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Task")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: "Task Title",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Colors.grey),
              ),
              title: Text(
                _dueDate == null
                    ? "Select Due Date"
                    : "Due: ${_dueDate!.toLocal().toString().split(' ')[0]}",
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );

                if (picked != null) {
                  setState(() {
                    _dueDate = picked;
                  });
                }
              },
            ),

            const SizedBox(height: 16),

            
            DropdownButtonFormField<String>(
              value: _priority,
              decoration: const InputDecoration(
                labelText: "Priority",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: "Low", child: Text("Low")),
                DropdownMenuItem(value: "Medium", child: Text("Medium")),
                DropdownMenuItem(value: "High", child: Text("High")),
              ],
              onChanged: (value) {
                setState(() {
                  _priority = value!;
                });
              },
            ),

            const SizedBox(height: 16),

            // Category
            DropdownButtonFormField<String>(
              value: _category,
              decoration: const InputDecoration(
                labelText: "Category",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: "Work", child: Text("Work")),
                DropdownMenuItem(value: "Personal", child: Text("Personal")),
                DropdownMenuItem(value: "Health", child: Text("Health")),
                DropdownMenuItem(value: "Finance", child: Text("Finance")),
                DropdownMenuItem(value: "Education", child: Text("Education")),
                DropdownMenuItem(value: "Shopping", child: Text("Shopping")),
                DropdownMenuItem(value: "Travel", child: Text("Travel")),
                DropdownMenuItem(value: "Others", child: Text("Others")),
              ],
              onChanged: (value) {
                setState(() {
                  _category = value!;
                });
              },
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (_titleController.text.isEmpty ||
                      _dueDate == null) {
                    return;
                  }

                 await ref
    .read(taskControllerProvider.notifier)
    .createTask(
      userId: widget.userId,
      title: _titleController.text,
      priority: _priority,
      category: _category,
      dueDate: _dueDate!,
    );

                  Navigator.pop(context);
                },
                child: const Text("Create Task"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
