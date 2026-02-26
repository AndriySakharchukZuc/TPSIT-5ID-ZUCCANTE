import 'task.dart';

class CardModel {
  CardModel({
    required this.id,
    required this.title,
    this.serverId,
    List<Task>? tasks,
  }) : tasks = tasks ?? [];

  int id;
  int? serverId;
  String title;
  List<Task> tasks;
  int? taskLenght;

  Map<String, dynamic> toMap() {
    return {'id': id, 'server_id': serverId, 'title': title};
  }

  factory CardModel.fromMap(Map<String, dynamic> map) {
    return CardModel(
      id: map['id'],
      serverId: map['server_id'],
      title: map['title'],
      tasks: [],
    );
  }
}
