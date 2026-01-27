import 'package:flutter/material.dart';
import 'package:todolistapp/models/task.dart';
import 'package:todolistapp/models/card.dart' as models;

class TasksListNotifier with ChangeNotifier {
  final _cards = <models.Card>[];

  int get cardsLength => _cards.length;

  // Card management
  void addCard() {
    _cards.add(
      models.Card(id: _cards.length + 1, title: 'New Card', tasks: []),
    );
    notifyListeners();
  }

  void deleteCard(models.Card card) {
    _cards.remove(card);
    notifyListeners();
  }

  models.Card getCard(int i) => _cards[i];

  // Task management within cards
  void addTaskToCard(models.Card card) {
    card.addTask(
      Task(
        id: card.tasks.length + 1,
        name: '',
        cardId: card.id,
        completed: false,
      ),
    );
    notifyListeners();
  }

  void addTask() {
    // For backward compatibility - adds to first card if exists
    if (_cards.isNotEmpty) {
      addTaskToCard(_cards.first);
    }
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
    for (var card in _cards) {
      if (card.tasks.contains(task)) {
        card.removeTask(task);
        break;
      }
    }
    notifyListeners();
  }

  // Helper to get task by index (for backward compatibility)
  Task? getTask(int i) {
    int count = 0;
    for (var card in _cards) {
      if (count + card.tasks.length > i) {
        return card.tasks[i - count];
      }
      count += card.tasks.length;
    }
    return null;
  }

  int get length {
    return _cards.fold(0, (sum, card) => sum + card.tasks.length);
  }
}
