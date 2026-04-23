import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../db/database_helper.dart';
import '../models/group.dart';
import '../models/task.dart';
import '../models/group_member.dart';

class ApiService {
  static const _uuid = Uuid();
  final _db = DatabaseHelper();

  Future<String> get _baseUrl async {
    final url = await _db.getSession('endpoint');
    return url ?? 'http://192.168.1.4:8080';
  }

  Future<Map<String, String>> _headers({bool auth = true}) async {
    final headers = {'Content-Type': 'application/json'};
    if (auth) {
      final token = await _db.getSession('token');
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  void _check(http.Response res, List<int> ok) {
    if (!ok.contains(res.statusCode)) {
      throw Exception('HTTP ${res.statusCode}: ${res.body}');
    }
  }

  Future<void> register(String username, String email, String password) async {
    final res = await http.post(
      Uri.parse('${await _baseUrl}/auth/register'),
      headers: await _headers(auth: false),
      body: jsonEncode({
        'id': _uuid.v4(),
        'username': username,
        'email': email,
        'password': password,
      }),
    );
    _check(res, [200, 201]);
  }

  Future<void> login(String email, String password) async {
    final res = await http.post(
      Uri.parse('${await _baseUrl}/auth/login'),
      headers: await _headers(auth: false),
      body: jsonEncode({'email': email, 'password': password}),
    );
    _check(res, [200]);

    final data = jsonDecode(res.body);
    final token = data['token'] as String;
    await _db.saveSession('token', token);

    final payload = jsonDecode(
      utf8.decode(base64Url.decode(base64Url.normalize(token.split('.')[1]))),
    );
    await _db.saveSession('user_id', payload['sub']);
  }

  Future<String?> getCurrentUserId() => _db.getSession('user_id');

  Future<List<Group>> getGroups() async {
    final res = await http.get(
      Uri.parse('${await _baseUrl}/groups'),
      headers: await _headers(),
    );
    _check(res, [200]);
    return (jsonDecode(res.body) as List)
        .map((e) => Group.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> createGroup(String name) async {
    final res = await http.post(
      Uri.parse('${await _baseUrl}/groups'),
      headers: await _headers(),
      body: jsonEncode({'id': _uuid.v4(), 'name': name}),
    );
    _check(res, [200, 201]);
  }

  Future<void> joinGroup(String inviteCode) async {
    final res = await http.post(
      Uri.parse('${await _baseUrl}/groups/join'),
      headers: await _headers(),
      body: jsonEncode({'id': _uuid.v4(), 'invite_code': inviteCode}),
    );
    _check(res, [200, 201]);
  }

  Future<void> leaveGroup(String groupId, String userId) async {
    final res = await http.delete(
      Uri.parse('${await _baseUrl}/groups/$groupId/members/$userId'),
      headers: await _headers(),
    );
    _check(res, [200]);
  }

  Future<List<Task>> getTasks(String groupId) async {
    final res = await http.get(
      Uri.parse('${await _baseUrl}/groups/$groupId/tasks'),
      headers: await _headers(),
    );
    _check(res, [200]);
    return (jsonDecode(res.body) as List)
        .map((e) => Task.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> createTask(String groupId, String title) async {
    final res = await http.post(
      Uri.parse('${await _baseUrl}/groups/$groupId/tasks'),
      headers: await _headers(),
      body: jsonEncode({'id': _uuid.v4(), 'title': title, 'description': ''}),
    );
    _check(res, [200, 201]);
  }

  Future<void> updateTaskStatus(String taskId, String status) async {
    final res = await http.patch(
      Uri.parse('${await _baseUrl}/tasks/$taskId'),
      headers: await _headers(),
      body: jsonEncode({'status': status}),
    );
    _check(res, [200]);
  }

  Future<void> deleteTask(String taskId) async {
    final res = await http.delete(
      Uri.parse('${await _baseUrl}/tasks/$taskId'),
      headers: await _headers(),
    );
    _check(res, [200, 204]);
  }

  Future<List<GroupMember>> getMembers(String groupId) async {
    final res = await http.get(
      Uri.parse('${await _baseUrl}/groups/$groupId/members'),
      headers: await _headers(),
    );
    _check(res, [200]);
    return (jsonDecode(res.body) as List)
        .map((e) => GroupMember.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
