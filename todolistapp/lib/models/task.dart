class Task {
  final int id;
  final String title;
  final String descriprion;
  bool completed;

  Task({
    required this.id,
    required this.title,
    required this.descriprion,
    required this.completed,
  });

  @override
  String toString() {
    return "$id $title $descriprion $completed";
  }
}

