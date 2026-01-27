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

  int get completedCount => tasks.where((task) => task.completed).length;

  int get totalCount => tasks.length;

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title};
  }

  factory Card.fromMap(Map<String, dynamic> map) {
    return Card(id: map['id'], title: map['title'], tasks: []);
  }
}
