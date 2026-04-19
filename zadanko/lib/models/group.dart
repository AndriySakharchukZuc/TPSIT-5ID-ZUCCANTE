class Group {
  final String id;
  final String name;
  final String createdBy;
  final String inviteCode;
  final DateTime createdAt;

  Group({
    required this.id,
    required this.name,
    required this.createdBy,
    required this.inviteCode,
    required this.createdAt,
  });

  factory Group.fromJson(Map<String, dynamic> json) => Group(
    id: json['id'],
    name: json['name'],
    createdBy: json['created_by'],
    inviteCode: json['invite_code'],
    createdAt: DateTime.parse(json['created_at']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'created_by': createdBy,
    'invite_code': inviteCode,
    'created_at': createdAt.toIso8601String(),
  };
}
