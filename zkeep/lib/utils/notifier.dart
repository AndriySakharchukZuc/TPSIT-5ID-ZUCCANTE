import '../models/card.dart';
import '../models/task.dart';
import '../db/helper.dart';

class CardsNotifier {
  final List<CardModel> _cards = [];

  List<CardModel> get cards => _cards;

  void addCard() {
    CardModel card = CardModel(id: 0, title: '');
    _cards.add(card);
    DatabaseHelper.insertCard(card);
  }

  void deleteCard(CardModel card) {
    _cards.remove(card);
    DatabaseHelper.deleteCard(card);
  }

  void addTask(CardModel card) {
    Task task = Task(id: null, name: '', cardId: card.id);
    card.tasks.add(task);
    DatabaseHelper.insertTask(task);
  }

  void deleteTask(CardModel card, Task task) {
    card.tasks.remove(task);
    DatabaseHelper.deleteTask(task);
  }

  void toggleTask(Task task) {
    task.completed = !task.completed;
    DatabaseHelper.updateTask(task);
  }

  void updateTaskName(Task task, String name) {
    task.name = name;
    DatabaseHelper.updateTask(task);
  }

  void updateCardTitle(CardModel card, String title) {
    card.title = title;
    DatabaseHelper.updateCard(card);
  }
}