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

    return ListTile(
      onTap: () {
        notifier.changeTask(task);
      },
      onLongPress: () {
        notifier.deleteTask(task);
      },
      leading: CircleAvatar(child: Text(task.name)),
      title: Text(task.name, style: _getTextStyle(task.completed)),
    );
  }
}
