import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../db/database_helper.dart';
import '../models/group.dart';
import '../screens/login_page.dart';
import '../screens/group_detail_page.dart';

class GroupListPage extends StatefulWidget {
  const GroupListPage({super.key});

  @override
  State<GroupListPage> createState() => _GroupListPageState();
}

class _GroupListPageState extends State<GroupListPage> {
  final _api = ApiService();
  final _db = DatabaseHelper();
  List<Group> _groups = [];

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    try {
      final groups = await _api.getGroups();
      setState(() => _groups = groups);
    } catch (e) {
      _showError(e.toString());
    }
  }

  void _showInputDialog({
    required String title,
    required String hint,
    required Future<void> Function(String) onConfirm,
  }) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(hintText: hint),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (controller.text.trim().isEmpty) return;
              await onConfirm(controller.text.trim());
              if (mounted) Navigator.pop(context);
              _loadGroups();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    await _db.deleteSession('token');
    await _db.deleteSession('user_id');
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (_) => false,
      );
    }
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Groups'),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: ListView.builder(
        itemCount: _groups.length,
        itemBuilder: (_, i) {
          final group = _groups[i];
          return ListTile(
            title: Text(group.name),
            subtitle: Text('Code: ${group.inviteCode}'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => GroupDetailPage(group: group)),
            ).then((_) => _loadGroups()),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'create',
            onPressed: () => _showInputDialog(
              title: 'New Group',
              hint: 'Group name',
              onConfirm: _api.createGroup,
            ),
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'join',
            onPressed: () => _showInputDialog(
              title: 'Join Group',
              hint: 'Invite code',
              onConfirm: _api.joinGroup,
            ),
            child: const Icon(Icons.group_add),
          ),
        ],
      ),
    );
  }
}
