import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolistapp/models/task.dart';
import 'package:todolistapp/utils/notifier.dart';

class TaskItem extends StatefulWidget {
  TaskItem({required this.task}) : super(key: ObjectKey(task));

  final Task task;
  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  final TextEditingController controller = TextEditingController();
  bool enabled = false;

  @override
  void initState() {
    controller.text = widget.task.name;
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  TextStyle? _getTextStyle(bool checked) {
    if (!checked) return null;
    return const TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    final TasksListNotifier notifier = context.watch<TasksListNotifier>();

    return GestureDetector(
      onTap: () => setState(() => enabled = true),
      child: Row(
        children: [
          Checkbox(
            value: widget.task.completed,
            onChanged: (value) {
              notifier.changeTask(widget.task);
            },
          ),
          Expanded(
            child: TextField(
              controller: controller,
              enabled: enabled,
              decoration: const InputDecoration(
                hintText: 'add a task',
                border: InputBorder.none,
              ),
              onSubmitted: (value) {
                notifier.changeTaskName(widget.task, value);
                setState(() => enabled = false);
              },
              style: _getTextStyle(widget.task.completed),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: () => notifier.deleteTask(widget.task),
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(),
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
