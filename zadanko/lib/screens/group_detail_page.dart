import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../models/group.dart';
import '../models/task.dart';
import '../models/group_member.dart';

class GroupDetailPage extends StatefulWidget {
  final Group group;
  const GroupDetailPage({super.key, required this.group});

  @override
  State<GroupDetailPage> createState() => _GroupDetailPageState();
}

class _GroupDetailPageState extends State<GroupDetailPage> {
  final _api = ApiService();
  List<Task> _tasks = [];
  List<GroupMember> _members = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        _api.getTasks(widget.group.id),
        _api.getMembers(widget.group.id),
      ]);
      setState(() {
        _tasks = results[0] as List<Task>;
        _members = results[1] as List<GroupMember>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showError(e.toString());
    }
  }

  Future<void> _leaveGroup() async {
    final userId = await _api.getCurrentUserId();
    if (userId == null) return;
    try {
      await _api.leaveGroup(widget.group.id, userId);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      _showError(e.toString());
    }
  }

  void _showAddTaskDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New Task'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Title'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (controller.text.trim().isEmpty) return;
              await _api.createTask(widget.group.id, controller.text.trim());
              if (mounted) Navigator.pop(context);
              _refresh();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.group.name),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Tasks'),
              Tab(text: 'Members'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              tooltip: 'Leave group',
              onPressed: _leaveGroup,
            ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(children: [_buildTaskList(), _buildMemberList()]),
        floatingActionButton: FloatingActionButton(
          onPressed: _showAddTaskDialog,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildTaskList() {
    if (_tasks.isEmpty) return const Center(child: Text('No tasks yet'));
    return ListView.builder(
      itemCount: _tasks.length,
      itemBuilder: (_, i) {
        final task = _tasks[i];
        final done = task.status == 'done';
        return ListTile(
          leading: Checkbox(
            value: done,
            onChanged: (val) async {
              await _api.updateTaskStatus(task.id, val! ? 'done' : 'todo');
              _refresh();
            },
          ),
          title: Text(
            task.title,
            style: TextStyle(
              decoration: done ? TextDecoration.lineThrough : null,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () async {
              await _api.deleteTask(task.id);
              _refresh();
            },
          ),
        );
      },
    );
  }

  Widget _buildMemberList() {
    if (_members.isEmpty) return const Center(child: Text('No members'));
    return ListView.builder(
      itemCount: _members.length,
      itemBuilder: (_, i) {
        final m = _members[i];
        return ListTile(
          leading: const Icon(Icons.person),
          title: Text(m.user?.username ?? m.userId),
          subtitle: Text(m.role),
        );
      },
    );
  }
}
