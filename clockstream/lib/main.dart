import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

late final Stream<int> _orologioStream;

Stream<int> orologio(Stream<int> oscillatore) async* {
  int seconds = 0;
  await for (final s in oscillatore) {
    yield seconds++;
  }
}

Stream<int> ticker(Duration interval) async* {
  while (true) {
    await Future.delayed(interval);
    yield 1;
  }
}

int ciao() {
  return 1;
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

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  var stream = ticker(const Duration(seconds: 1));

  void initState() {
    super.initState();
    final tickerStream = ticker(const Duration(seconds: 1));
    _orologioStream = orologio(tickerStream);
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
            const Text('You have pushed the button this many times:'),
            StreamBuilder<int>(
              stream: _orologioStream,
              initialData: 0,
              builder: (context, snapshot) {
                final int counter = snapshot.data ?? 0;
                return Text(
                  '$counter',
                  style: Theme.of(context).textTheme.headlineMedium,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
