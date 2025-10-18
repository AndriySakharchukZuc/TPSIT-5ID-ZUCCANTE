import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

List<Color> POSSIBLE_COLORS = [
  Colors.deepPurpleAccent,
  Colors.cyanAccent,
  Colors.amberAccent,
  Colors.pinkAccent,
  Colors.grey,
];
List<int> ASSIGNED_COLORS = [];

List<Widget> checksOnButtons = [];

void main() {
  colorsInit(ASSIGNED_COLORS);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

void colorsInit(List<int> assignedColors) {
  for (var i = 0; i < 4; i++) {
    assignedColors.add(Random.secure().nextInt(3));
  }

  checksOnButtons.clear();
  for (int i = 0; i < ASSIGNED_COLORS.length; i++) {
    checksOnButtons.add(Text("Inizio Gioco"));
  }
  print(assignedColors);
}

void changeButtonColor() {}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int> buttonCounter = [4, 4, 4, 4];

  void showMyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Giusto!!!"),
          content: Text("Hai indovinato i colori!!!!!!!!!!!!!!!!"),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> buttons = [];

    for (int i = 0; i < buttonCounter.length; i++) {
        buttons.add(
          FloatingActionButton(
            backgroundColor: POSSIBLE_COLORS[buttonCounter[i]],
            onPressed: () {
              setState(() {
                buttonCounter[i]++;
                if (buttonCounter[i] >= 4) {
                  buttonCounter[i] = 0;
                }
                print(buttonCounter);
              });
            },
          ),
        );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child:
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: buttons,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: checksOnButtons,
                )
              ]
            ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (listEquals(ASSIGNED_COLORS, buttonCounter)) {
            showMyDialog();
            setState(() {
              for (int i = 0; i < buttonCounter.length; i++) {
                buttonCounter[i] = 4;
              }
              ASSIGNED_COLORS.clear();
              colorsInit(ASSIGNED_COLORS);
            });
          } else {
            setState(() {
            for(int i = 0; i<checksOnButtons.length; i++){
                checksOnButtons[i] =
                    buttonCounter.elementAt(i) == ASSIGNED_COLORS.elementAt(i)
                    ? Text("Giusto")
                    :  Text("Sbagliato");
            }
            });
          }
        },
      ),
    );
  }
}