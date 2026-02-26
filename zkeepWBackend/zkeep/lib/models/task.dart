class Task {
  Task({
    required this.id,
    this.serverId,
    required this.name,
    required this.cardId,
    this.serverCardId,
    this.completed = false,
  });

  int? id;
  int cardId;
  int? serverId;
  int? serverCardId;
  String name;
  bool completed;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'server_id': serverId,
      'card_id': cardId,
      'server_card_id': serverCardId,
      'name': name,
      'completed': completed ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      serverId: map['server_id'],
      cardId: map['card_id'],
      serverCardId: map['server_card_id'],
      name: map['name'],
      completed: map['completed'] == 1,
    );
  }
}
