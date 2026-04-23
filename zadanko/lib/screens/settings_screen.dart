import 'package:flutter/material.dart';
import '../db/database_helper.dart';

class SettingsScreen extends StatefulWidget {
  final Widget nextScreen;
  const SettingsScreen({super.key, required this.nextScreen});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _controller = TextEditingController();
  final _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadEndpoint();
  }

  void _loadEndpoint() async {
    final saved = await _dbHelper.getSession('endpoint');
    if (saved != null) _controller.text = saved;
  }

  void _save() async {
    final value = _controller.text.trim();
    if (value.isEmpty) return;
    await _dbHelper.saveSession('endpoint', value);
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => widget.nextScreen),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Server Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Server URL',
                hintText: 'http://192.168.1.4:8080',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _save, child: const Text('Save')),
          ],
        ),
      ),
    );
  }
}
