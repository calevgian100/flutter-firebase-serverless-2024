import 'package:flutter/material.dart';
import 'package:todo_do_app/auth/logic/firebase_auth_service.dart';
import 'package:todo_do_app/auth/screen/login_screen.dart';
import 'package:todo_do_app/to_do_list/widgets/add_task_form.dart';
import 'package:todo_do_app/to_do_list/widgets/task_list.dart';

class ToDoScreen extends StatelessWidget {
  const ToDoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuthService.currentUser!;
    print(user);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Welcome ${user.displayName}'),
        actions: [
          IconButton(
            onPressed: () => showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) => const AddTaskForm(),
            ),
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () async {
              await FirebaseAuthService.logout();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              }
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: const TaskList(),
    );
  }
}
