import 'package:flutter/material.dart';
import 'package:todo_do_app/logic/firestore_service.dart';

class AddTaskForm extends StatefulWidget {
  const AddTaskForm({super.key});

  @override
  State<AddTaskForm> createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<AddTaskForm> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          const _Label(),
          _NameTextField(nameController: nameController),
          _Description(descriptionController: descriptionController),
          _AddButton(
            nameController: nameController,
            descriptionController: descriptionController,
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Text(
        'Add a new task',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}

class _NameTextField extends StatelessWidget {
  const _NameTextField({required this.nameController});

  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: TextField(
        controller: nameController,
        decoration: const InputDecoration(
          labelText: 'Name',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}

class _Description extends StatelessWidget {
  const _Description({required this.descriptionController});

  final TextEditingController descriptionController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: TextField(
        controller: descriptionController,
        decoration: const InputDecoration(
          labelText: 'Description',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({
    required this.nameController,
    required this.descriptionController,
  });

  final TextEditingController nameController;
  final TextEditingController descriptionController;

  Future<void> _addTask(BuildContext context) async {
    // We create a variable to handle navigation after using an async method.
    // If we don't do this, we can have difficulties diagnosing crashes.
    final navigator = Navigator.of(context);

    await FirestoreService.addTask(
      name: nameController.text,
      description: descriptionController.text,
    );

    // We call pop so we can close the modal after adding/editing a task.
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _addTask(context),
      child: const Text('Add task'),
    );
  }
}
