import 'package:flutter/material.dart';
import 'package:todolistapp/utils/notifier.dart';
import 'package:provider/provider.dart';
import 'package:todolistapp/widgets/todo_card.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo Cards App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ChangeNotifierProvider(
        create: (context) => TasksListNotifier(),
        child: const MyHomePage(title: 'Todo Cards'),
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
  @override
  Widget build(BuildContext context) {
    final TasksListNotifier notifier = context.watch<TasksListNotifier>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: notifier.cardsLength == 0
          ? Center(
              child: Text(
                'Tap + to add a card',
                style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
              ),
            )
          : MasonryGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              padding: const EdgeInsets.all(8.0),
              itemCount: notifier.cardsLength,
              itemBuilder: (context, index) {
                final card = notifier.getCard(index);
                return TaskCard(card: card);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => notifier.addCard(),
        tooltip: 'Add card',
        child: const Icon(Icons.add),
      ),
    );
  }
}
