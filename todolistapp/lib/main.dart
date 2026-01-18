import 'package:flutter/material.dart';
import 'package:todolistapp/models/task.dart';
import 'package:todolistapp/utils/notifier.dart';
import 'package:provider/provider.dart';
import 'package:todolistapp/widgets/todo_item.dart';

void main() {
  runApp(const MyApp());
}

List<Task> tasks = [];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: ChangeNotifierProvider(
        create: (notifier) => TasksListNotifier(),
        child: const MyHomePage(title: 'Tasks list'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final TasksListNotifier notifier = context.watch<TasksListNotifier>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10),
          itemCount: notifier.length,
          itemBuilder: (context, index) {
            Task task = notifier.getTask(index);
            return TaskItem(task: task);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => notifier.addTask(),
        tooltip: 'Add task',
        child: const Icon(Icons.add),
      ),
    );
  }
}
