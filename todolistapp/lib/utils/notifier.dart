import 'package:flutter/material.dart';
import 'package:todolistapp/models/task.dart';

class TasksListNotifier with ChangeNotifier {
  final _tasks = <Task>[];
  int get length => _tasks.length;

  void addTask() {
    _tasks.add(Task(id: _tasks.length + 1, name: '', completed: false));
    notifyListeners();
  }

  void changeTask(Task task) {
    task.completed = !task.completed;
    notifyListeners();
  }

  void changeTaskName(Task task, String nTitle) {
    task.name = nTitle;
    notifyListeners();
  }

  void deleteTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }

  Task getTask(int i) => _tasks[i];
}
