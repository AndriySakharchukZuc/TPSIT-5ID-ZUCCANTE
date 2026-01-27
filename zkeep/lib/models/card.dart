import 'package:zkeep/models/task.dart';

class Card {
  Card({required this.id, required this.title, List<Task>? tasks})
    : tasks = tasks ?? [];

  final int id;
  String title;
  List<Task> tasks;
  void addTask(Task task) {
    tasks.add(task);
  }

  void removeTask(Task task) {
    tasks.remove(task);
  }

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
