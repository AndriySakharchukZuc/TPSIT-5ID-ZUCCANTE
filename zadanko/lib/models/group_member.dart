import 'user.dart';

class GroupMember {
  final String id;
  final String groupId;
  final String userId;
  final String role;
  final DateTime joinedAt;
  final User? user;

  GroupMember({
    required this.id,
    required this.groupId,
    required this.userId,
    required this.role,
    required this.joinedAt,
    this.user,
  });

  factory GroupMember.fromJson(Map<String, dynamic> json) => GroupMember(
    id: json['id'],
    groupId: json['group_id'],
    userId: json['user_id'],
    role: json['role'],
    joinedAt: DateTime.parse(json['joined_at']),
    user: json['user'] != null ? User.fromJson(json['user']) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'group_id': groupId,
    'user_id': userId,
    'role': role,
    'joined_at': joinedAt.toIso8601String(),
  };
}
