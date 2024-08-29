import 'package:flutter/material.dart';
import 'package:todo_do_app/widgets/add_task_form.dart';
import 'package:todo_do_app/widgets/task_list.dart';

class ToDoScreen extends StatelessWidget {
  const ToDoScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
        actions: [
          IconButton(
            onPressed: () => showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) => const AddTaskForm(),
            ),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: const TaskList(),
    );
  }
}
