import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zkeep/models/task.dart';
import '../models/card.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.1.4:8080/api';

  static Future<List<CardModel>> getCards() async {
    final response = await http
        .get(Uri.parse('$baseUrl/cards'))
        .timeout(Duration(seconds: 5));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) {
        return CardModel(id: 0, serverId: json['id'], title: json['title']);
      }).toList();
    } else {
      throw Exception('Failed to load cards');
    }
  }

  static Future<CardModel> addCard(CardModel card) async {
    final response = await http
        .post(
          Uri.parse("$baseUrl/cards"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({'title': card.title}),
        )
        .timeout(Duration(seconds: 5));

    if (response.statusCode != 201) {
      throw Exception('Failed to add card');
    }

    var data = json.decode(response.body);
    print('Server returned ID: ${data['id']}');

    return CardModel(id: 0, serverId: data['id'], title: data['title'] ?? '');
  }

  static Future<void> deleteCard(int serverId) async {
    print('Deleting card with ID: $serverId from $baseUrl/cards/$serverId');
    final response = await http
        .delete(Uri.parse("$baseUrl/cards/$serverId"))
        .timeout(Duration(seconds: 5));
    print('Delete response: ${response.statusCode}');
    if (response.statusCode != 200) {
      throw Exception('Failed to delete from DB: ${response.body}');
    }
  }

  static Future<void> updateCard(CardModel card) async {
    print('Server ID: ${card.serverId}');
    final response = await http
        .put(
          Uri.parse('$baseUrl/cards/${card.serverId}'),
          body: jsonEncode(card.toMap()),
        )
        .timeout(Duration(seconds: 5));
    if (response.statusCode != 200) {
      throw Exception('Failed to update card');
    }
  }

  static Future<List<Task>> getTasks() async {
    final response = await http
        .get(Uri.parse("$baseUrl/tasks"))
        .timeout(Duration(seconds: 5));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) {
        return Task(
          id: 0,
          name: json['name'],
          cardId: 0,
          serverId: json['id'],
          serverCardId: json['card_id'],
        );
      }).toList();
    }

    throw Exception('Failed to fetch tasks');
  }

  static Future<Task> addTask(Task task) async {
    final response = await http
        .post(
          Uri.parse('$baseUrl/tasks'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({'name': task.name, 'card_id': task.serverCardId}),
        )
        .timeout(Duration(seconds: 5));

    if (response.statusCode != 201) {
      throw Exception('Failed to add task');
    }

    var data = json.decode(response.body);

    return Task(
      id: 0,
      name: data['name'],
      cardId: task.cardId,
      serverId: data['id'],
      serverCardId: data['card_id'],
    );
  }

  static Future<void> deleteTask(int serverTaskId) async {
    final response = await http
        .delete(Uri.parse('$baseUrl/tasks/$serverTaskId'))
        .timeout(Duration(seconds: 5));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }
  }

  static Future<void> updateTask(Task task) async {
    final response = await http
        .put(
          Uri.parse('$baseUrl/tasks/${task.serverId}'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'name': task.name, 'completed': task.completed}),
        )
        .timeout(Duration(seconds: 5));
    if (response.statusCode != 200) {
      throw Exception('Failed to update task');
    }
  }

  static Future<void> toggleTask(int serverTaskId) async {
    final response = await http
        .patch(Uri.parse('$baseUrl/tasks/$serverTaskId/toggle'))
        .timeout(Duration(seconds: 5));
    if (response.statusCode != 200) {
      throw Exception('Failed to toggle task');
    }
  }
}
