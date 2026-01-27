class Task {
  Task({
    required this.id,
    required this.name,
    required this.cardId,
    this.completed = false,
  });

  final int? id;
  final int cardId;
  String name;
  bool completed;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cardId': cardId,
      'name': name,
      'completed': completed ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      cardId: map['cardId'],
      name: map['name'],
      completed: map['completed'] == 1,
    );
  }
}
