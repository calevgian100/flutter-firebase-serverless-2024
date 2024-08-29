import 'package:flutter/material.dart';
import 'package:todo_do_app/logic/firestore_service.dart';
import 'package:todo_do_app/widgets/edit_task.form.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({required this.task, super.key});

  final Map<String, dynamic> task;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => EditTaskForm(task: task),
      ),
      child: ListTile(
        leading: const CircleAvatar(),
        title: Text(task['name'] as String),
        subtitle: Text(task['description'] as String),
        trailing: InkWell(
          onTap: () => FirestoreService.deleteTask(task['id']),
          child: const Icon(Icons.delete),
        ),
      ),
    );
  }
}
