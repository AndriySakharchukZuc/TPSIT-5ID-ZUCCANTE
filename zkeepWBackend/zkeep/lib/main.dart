import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sqflite/sqflite.dart';
import 'package:zkeep/utils/api.dart';
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
  bool _isSyncing = false;
  bool _isAdding = false;

  @override
  initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await DatabaseHelper.init();
    _updateCards();
  }

  Future<void> _updateCards() async {
    var cards = await DatabaseHelper.getCards();
    for (var card in cards) {
      card.tasks = await DatabaseHelper.getTasks(card.id);
    }
    setState(() {
      notifier.cards.clear();
      notifier.cards.addAll(cards);
    });
  }

  Future<void> _syncCards() async {
    setState(() => _isSyncing = true);
    try {
      var serverCards = await ApiService.getCards();
      var serverTasks = await ApiService.getTasks();

      await DatabaseHelper.clearAllCards();

      Map<int, int> serverToLocalId = {};

      for (var card in serverCards) {
        int localId = await DatabaseHelper.insertCard(card);
        if (card.serverId != null) {
          serverToLocalId[card.serverId!] = localId;
        }
      }

      for (var task in serverTasks) {
        int? localCardId = serverToLocalId[task.serverCardId];
        if (localCardId != null) {
          await DatabaseHelper.insertTaskFromSrv(task, localCardId);
        }
      }

      _updateCards();
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() => _isSyncing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ZKeep'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (_isAdding || _isSyncing)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            IconButton(icon: const Icon(Icons.sync), onPressed: _syncCards),
        ],
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
        onPressed: () async {
          setState(() => _isAdding = true);
          await notifier.addCard();
          setState(() => _isAdding = false);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
