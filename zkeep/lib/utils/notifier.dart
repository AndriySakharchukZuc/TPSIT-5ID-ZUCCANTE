import '../models/card.dart';
import '../models/task.dart';

class CardsNotifier {
  final List<CardModel> _cards = [];

  List<CardModel> get cards => _cards;

  void addCard() {
    _cards.add(CardModel(id: _cards.length + 1, title: ''));
  }

  void deleteCard(CardModel card) {
    _cards.remove(card);
  }

  void addTask(CardModel card) {
    card.tasks.add(Task(id: card.tasks.length + 1, name: '', cardId: card.id));
  }

  void deleteTask(CardModel card, Task task) {
    card.tasks.remove(task);
  }

  void toggleTask(Task task) {
    task.completed = !task.completed;
  }

  void updateTaskName(Task task, String name) {
    task.name = name;
  }

  void updateCardTitle(CardModel card, String title) {
    card.title = title;
  }
}
