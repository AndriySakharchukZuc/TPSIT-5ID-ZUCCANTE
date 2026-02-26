import 'package:zkeep/utils/api.dart';

import '../models/card.dart';
import '../models/task.dart';
import '../db/helper.dart';

class CardsNotifier {
  final List<CardModel> _cards = [];

  List<CardModel> get cards => _cards;

  Future<void> addCard() async {
    CardModel card = CardModel(id: 0, title: '');

    int localId = await DatabaseHelper.insertCard(card);

    CardModel newCard = CardModel(id: localId, title: '');
    _cards.add(newCard);

    try {
      CardModel serverCard = await ApiService.addCard(newCard);
      newCard.serverId = serverCard.serverId;
      await DatabaseHelper.updateCard(newCard);
    } catch (e) {
      print('Offline mode (this is OK): $e');
    }
  }

  Future<void> deleteCard(CardModel card) async {
    _cards.remove(card);
    await DatabaseHelper.deleteCard(card);

    if (card.serverId != null) {
      try {
        await ApiService.deleteCard(card.serverId!);
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  void updateCardTitle(CardModel card, String title) async {
    card.title = title;
    await DatabaseHelper.updateCard(card);
    try {
      await ApiService.updateCard(card);
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> addTask(CardModel card) async {
    Task task = Task(
      id: null,
      name: '',
      cardId: card.id,
      serverCardId: card.serverId,
    );

    int newId = await DatabaseHelper.insertTask(task);
    Task newTask = Task(
      id: newId,
      name: '',
      cardId: card.id,
      serverCardId: card.serverId,
    );
    card.tasks.add(newTask);

    try {
      Task serverTask = await ApiService.addTask(newTask);
      newTask.serverId = serverTask.serverId;
      await DatabaseHelper.updateTask(newTask);
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> deleteTask(CardModel card, Task task) async {
    card.tasks.remove(task);
    await DatabaseHelper.deleteTask(task);
    if (task.serverId != null) {
      try {
        await ApiService.deleteTask(task.serverId!);
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  Future<void> toggleTask(Task task) async {
    task.completed = !task.completed;
    await DatabaseHelper.updateTask(task);
    if (task.serverId != null) {
      try {
        await ApiService.toggleTask(task.serverId!);
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  Future<void> updateTaskName(Task task, String name) async {
    task.name = name;
    await DatabaseHelper.updateTask(task);
    if (task.serverId != null) {
      try {
        await ApiService.updateTask(task);
      } catch (e) {
        print('Error $e');
      }
    }
  }
}
