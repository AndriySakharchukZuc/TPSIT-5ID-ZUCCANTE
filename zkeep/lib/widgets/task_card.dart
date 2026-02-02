import 'package:flutter/material.dart';
import '../models/card.dart';
import '../utils/notifier.dart';
import 'task_item.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key,
    required this.card,
    required this.notifier,
    required this.onChanged,
  });

  final CardModel card;
  final CardsNotifier notifier;
  final VoidCallback onChanged;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  late TextEditingController _titleController;
  bool _isEditingTitle = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.card.title);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isEditingTitle = true),
                    child: TextField(
                      controller: _titleController,
                      enabled: _isEditingTitle,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Title',
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      autofocus: _isEditingTitle,
                      onSubmitted: (value) {
                        widget.notifier.updateCardTitle(widget.card, value);
                        setState(() => _isEditingTitle = false);
                        widget.onChanged();
                      },
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  onPressed: () {
                    widget.notifier.deleteCard(widget.card);
                    widget.onChanged();
                  },
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          ...widget.card.tasks.map(
            (task) => TaskItem(
              task: task,
              card: widget.card,
              notifier: widget.notifier,
              onChanged: widget.onChanged,
            ),
          ),
          TextButton.icon(
            onPressed: () {
              widget.notifier.addTask(widget.card);
              widget.onChanged();
            },
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add task'),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }
}
