import 'task.dart';

class CardModel {
  CardModel({required this.id, required this.title, List<Task>? tasks})
    : tasks = tasks ?? [];

  final int id;
  String title;
  List<Task> tasks;

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title};
  }

  factory CardModel.fromMap(Map<String, dynamic> map) {
    return CardModel(id: map['id'], title: map['title'], tasks: []);
  }
}
