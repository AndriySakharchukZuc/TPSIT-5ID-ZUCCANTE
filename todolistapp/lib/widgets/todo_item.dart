import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolistapp/models/task.dart';
import 'package:todolistapp/utils/notifier.dart';

class TaskItem extends StatelessWidget {
  TaskItem({required this.task}) : super(key: ObjectKey(task));

  final Task task;

  TextStyle? _getTextStyle(bool checked) {
    if (!checked) return null;
    return const TextStyle(
      color: Colors.black,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    final TasksListNotifier notifier = context.watch<TasksListNotifier>();
    final TextEditingController controller = TextEditingController();
    controller.text = task.name;
    bool enabled = true;

    return Row(
      children: [
        Checkbox(
          value: task.completed,
          onChanged: (value) {
            notifier.changeTask(task);
          },
        ),
        Expanded(
          child: TextField(
            controller: controller,
            enabled: enabled,
            decoration: const InputDecoration(hintText: 'add a task'),
            onSubmitted: (value) {
              notifier.changeTaskName(task, value);
              enabled = false;
            },
          ),
        ),
      ],
    );
  }
}
