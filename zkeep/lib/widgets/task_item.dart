import 'package:flutter/material.dart';
import '../models/task.dart';
import '../models/card.dart';
import '../utils/notifier.dart';

class TaskItem extends StatefulWidget {
  const TaskItem({
    super.key,
    required this.task,
    required this.card,
    required this.notifier,
    required this.onChanged,
  });

  final Task task;
  final CardModel card;
  final CardsNotifier notifier;
  final VoidCallback onChanged;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  late TextEditingController _controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.task.name);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: widget.task.completed,
          onChanged: (_) {
            widget.notifier.toggleTask(widget.task);
            widget.onChanged();
          },
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _isEditing = true),
            child: TextField(
              controller: _controller,
              enabled: _isEditing,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Task',
              ),
              autofocus: _isEditing,
              onSubmitted: (value) {
                widget.notifier.updateTaskName(widget.task, value);
                setState(() => _isEditing = false);
                widget.onChanged();
              },
              style: widget.task.completed
                  ? const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                    )
                  : null,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close, size: 18),
          onPressed: () {
            widget.notifier.deleteTask(widget.card, widget.task);
            widget.onChanged();
          },
          color: Colors.grey,
        ),
      ],
    );
  }
}
