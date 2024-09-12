import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:todo_do_app/to_do_list/logic/firestore_service.dart';
import 'package:todo_do_app/to_do_list/widgets/edit_task.form.dart';

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
        leading: task['imageUrl'] == null
            ? const CircleAvatar()
            : CachedNetworkImage(
                imageUrl: task['imageUrl'],
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
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
