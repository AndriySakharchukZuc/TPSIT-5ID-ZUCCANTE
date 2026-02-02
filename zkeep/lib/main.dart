import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'utils/notifier.dart';
import 'db/helper.dart';
import 'widgets/task_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZKeep',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final notifier = CardsNotifier();

  @override
  initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await DatabaseHelper.init();
    _updateCards();
  }

  void _updateCards() {
    DatabaseHelper.getCards().then((cards) async {
      for (var card in cards) {
        card.tasks = await DatabaseHelper.getTasks(card.id);
      }
      setState(() {
        notifier.cards.clear();
        notifier.cards.addAll(cards);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ZKeep'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: notifier.cards.isEmpty
          ? const Center(child: Text('Tap + to add a card'))
          : MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        padding: const EdgeInsets.all(8),
        itemCount: notifier.cards.length,
        itemBuilder: (context, index) {
          return TaskCard(
            card: notifier.cards[index],
            notifier: notifier,
            onChanged: () => setState(() {}),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          notifier.addCard();
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}