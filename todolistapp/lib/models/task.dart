class Task {
  Task({required this.id, required this.name, this.completed = false});
  final int? id;
  String name;
  bool completed;
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'completed': completed ? 1 : 0};
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      name: map['name'],
      completed: map['completed'] == 1,
    );
  }
}
