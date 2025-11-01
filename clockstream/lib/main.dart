import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}
enum StatoOrologio { START, STOP, RESET }
bool _isPaused = false;
Stream<int> orologio(Stream<int> oscillatore) async* {
  int seconds = 0;
    await for (final s in oscillatore) {
      if(!_isPaused) {
        yield seconds += 1;
      }
  }
}

Stream<int> ticker(Duration interval) async* {
  while (true) {
    await Future.delayed(interval);
    print(1);
    yield 1;
  }
}
final Stream<int> finalTicker = ticker(const Duration(seconds: 1)).asBroadcastStream();
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Andriy Sakharchuk',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Andriy Sakharchuk clockstream'),
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
  int _counter = 0;
  StreamSubscription<int>? _subscription;

  StatoOrologio _statoOrologio1 = StatoOrologio.RESET;

  void _modificaStatoOrologio1() {
    setState(() {
      switch (_statoOrologio1) {
        case StatoOrologio.START:
          _isPaused = false;
          _statoOrologio1 = StatoOrologio.STOP;
          _subscription?.cancel();
          _subscription = null;
          break;
        case StatoOrologio.STOP:
          _isPaused = false;
          _statoOrologio1 = StatoOrologio.RESET;
          _subscription?.cancel();
          _subscription = null;
          _counter = 0;
          break;
        case StatoOrologio.RESET:
          _isPaused = false;
          _statoOrologio1 = StatoOrologio.START;
          final stream = orologio(finalTicker);
          _subscription = stream.listen((seconds) {
            setState(() {
              _counter = seconds;
            });
          });
          break;
      }
    });
  }

  void _modificaStatoPauseResume(){
    if (_statoOrologio1 != StatoOrologio.START) return;
    setState(() {
      _isPaused = !_isPaused;

      if(_isPaused){
        _subscription?.pause();
      } else {
        _subscription?.resume();
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
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _modificaStatoOrologio1,
            child: _iconaOrologio1(),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: _modificaStatoPauseResume,
            child: _isPaused ? Icon(Icons.play_arrow) : Icon(Icons.pause),
            
          ),
        ],
      ),
    );
  }
}