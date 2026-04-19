class Task {
  final String id;
  final String groupId;
  final String createdBy;
  final String? assignedTo;
  final String title;
  final String description;
  final String status;
  final bool isDeleted;
  final DateTime? dueAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  String syncStatus;
  String syncAction;

  Task({
    required this.id,
    required this.groupId,
    required this.createdBy,
    this.assignedTo,
    required this.title,
    this.description = '',
    this.status = 'todo',
    this.isDeleted = false,
    this.dueAt,
    required this.createdAt,
    required this.updatedAt,
    this.syncStatus = 'synced',
    this.syncAction = 'none',
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'],
    groupId: json['group_id'],
    createdBy: json['created_by'],
    assignedTo: json['assigned_to'],
    title: json['title'],
    description: json['description'] ?? '',
    status: json['status'],
    isDeleted: json['is_deleted'] ?? false,
    dueAt: json['due_at'] != null ? DateTime.parse(json['due_at']) : null,
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'group_id': groupId,
    'created_by': createdBy,
    'assigned_to': assignedTo,
    'title': title,
    'description': description,
    'status': status,
    'is_deleted': isDeleted,
    'due_at': dueAt?.toIso8601String(),
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}
