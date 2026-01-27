import 'package:todolistapp/models/task.dart';

class Card {
  Card({required this.id, required this.title, List<Task>? tasks})
    : tasks = tasks ?? [];

  final int id;
  String title;
  List<Task> tasks;

  // Add a new task to this card
  void addTask(Task task) {
    tasks.add(task);
  }

  // Remove a task from this card
  void removeTask(Task task) {
    tasks.remove(task);
  }

  // Get completed tasks count
  int get completedCount => tasks.where((task) => task.completed).length;

  // Get total tasks count
  int get totalCount => tasks.length;

  // Check if all tasks are completed
  bool get isAllCompleted =>
      tasks.isNotEmpty && tasks.every((task) => task.completed);

  // Convert to Map for storage (without tasks - tasks stored separately)
  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title};
  }

  // Create from Map (without tasks - tasks loaded separately)
  factory Card.fromMap(Map<String, dynamic> map) {
    return Card(
      id: map['id'],
      title: map['title'],
      tasks: [], // Tasks will be loaded separately using cardId
    );
  }
}
