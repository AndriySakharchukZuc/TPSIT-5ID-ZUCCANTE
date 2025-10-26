import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

Stream<int> orologio(Stream<int> oscillatore) async* {
  int seconds = 0;
  await for (final s in oscillatore) {
    yield seconds += 30;
  }
}

Stream<int> ticker(Duration interval) async* {
  while (true) {
    await Future.delayed(interval);
    yield 1;
  }
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum StatoOrologio { START, STOP, RESET }

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  StreamSubscription<int>? _subscription;

  StatoOrologio _statoOrologio1 = StatoOrologio.RESET;

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _modificaStatoOrologio1() {
    setState(() {
      switch (_statoOrologio1) {
        case StatoOrologio.START:
          _statoOrologio1 = StatoOrologio.STOP;
          _subscription?.cancel();
          _subscription = null;
          break;
        case StatoOrologio.STOP:
          _statoOrologio1 = StatoOrologio.RESET;
          _subscription?.cancel();
          _subscription = null;
          _counter = 0;
          break;
        case StatoOrologio.RESET:
          _statoOrologio1 = StatoOrologio.START;
          final stream = orologio(ticker(const Duration(seconds: 1)));
          _subscription = stream.listen((seconds) {
            setState(() {
              _counter = seconds;
            });
          });
          break;
      }
    });
  }

  Widget _iconaOrologio1() {
    switch (_statoOrologio1) {
      case StatoOrologio.START:
        return const Icon(Icons.stop);
      case StatoOrologio.STOP:
        return const Icon(Icons.refresh);
      case StatoOrologio.RESET:
        return const Icon(Icons.play_arrow);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Orologio:'),
            Text('Ore: ${_counter ~/ 3600} Minuti: ${(_counter ~/ 60) % 60} Secondi: ${_counter % 60}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _modificaStatoOrologio1,
        tooltip: _statoOrologio1.name,
        child: _iconaOrologio1(),
      ),
    );
  }
}