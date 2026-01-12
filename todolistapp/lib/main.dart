import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

final _titleController = TextEditingController();
final _descController = TextEditingController();




class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
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
  void addTaskDialog(){

    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Text("Add new task"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Add a title"
                  ),
                ),
                TextField(
                  controller: _descController,
                  decoration: const InputDecoration(
                      border:  OutlineInputBorder(),
                      hintText: "Add a description"
                  ),
                )
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel"),
              ),
              TextButton(
                  onPressed: null, //TODO implement a saving (creating) a task with infos from text controllers
                  child: const Text("Save")
              ),
            ],
          );
        });
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
          mainAxisAlignment: .center,
          children: [
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTaskDialog,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}


