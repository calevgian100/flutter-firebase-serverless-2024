import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_do_app/auth/logic/firebase_auth_service.dart';
import 'package:todo_do_app/to_do_list/screens/todo_do_screen.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  File? _profileImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Create account'),
                if (_profileImage == null)
                  _imagePicker()
                else
                  Image.file(_profileImage!),
                const SizedBox(height: 20),
                _nameField(),
                const SizedBox(height: 20),
                _emailField(),
                const SizedBox(height: 20),
                _passwordField(),
                const SizedBox(height: 20),
                _createAccountButton(context),
                const SizedBox(height: 20),
                _alreadyHaveAnAccount(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _imagePicker() {
    return InkWell(
      onTap: () => _pickImage(),
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: Text('Upload image'),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _profileImage = File(pickedFile!.path);
    });
  }

  Widget _nameField() {
    return TextField(
      controller: _nameController,
      decoration: const InputDecoration(
        label: Text('Name'),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget _emailField() {
    return TextField(
      controller: _emailController,
      decoration: const InputDecoration(
        label: Text('Email'),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget _passwordField() {
    return TextField(
      controller: _passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        label: Text('Password'),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget _createAccountButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await FirebaseAuthService.createAccount(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          profileImage: _profileImage!,
        );

        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ToDoScreen(),
            ),
          );
        }
      },
      child: const Text('Create Account'),
    );
  }

  Widget _alreadyHaveAnAccount(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.of(context).pop(),
      child: const Text("Already have an account?"),
    );
  }
}
