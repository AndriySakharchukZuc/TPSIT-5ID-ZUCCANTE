import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolistapp/models/card.dart' as models;
import 'package:todolistapp/widgets/todo_item.dart';
import 'package:todolistapp/utils/notifier.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({super.key, required this.card});

  final models.Card card;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  final TextEditingController _titleController = TextEditingController();
  bool _editingTitle = false;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.card.title;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<TasksListNotifier>();

    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header with Title
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _editingTitle = true),
                    child: _editingTitle
                        ? TextField(
                            controller: _titleController,
                            autofocus: true,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Card Title',
                            ),
                            onSubmitted: (value) {
                              widget.card.title = value;
                              setState(() => _editingTitle = false);
                            },
                          )
                        : Text(
                            widget.card.title.isEmpty
                                ? 'Untitled Card'
                                : widget.card.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                // Progress indicator
                Text(
                  '${widget.card.completedCount}/${widget.card.totalCount}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                // Delete card button
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Card'),
                        content: const Text(
                          'Are you sure you want to delete this card and all its tasks?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              notifier.deleteCard(widget.card);
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          // Tasks List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.card.tasks.length,
            itemBuilder: (context, index) {
              return TaskItem(task: widget.card.tasks[index]);
            },
          ),

          // Add Task Button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton.icon(
              onPressed: () {
                notifier.addTaskToCard(widget.card);
                setState(() {});
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Task'),
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
