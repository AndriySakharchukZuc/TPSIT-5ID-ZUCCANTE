import 'package:flutter/cupertino.dart';
import 'package:todolistapp/models/task.dart';

class TodoList extends StatelessWidget{
  const TodoList({
    super.key,
    required this.task,
    required this.onChanged
});
  final Task task;
  final Function(bool?)? onChanged;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}