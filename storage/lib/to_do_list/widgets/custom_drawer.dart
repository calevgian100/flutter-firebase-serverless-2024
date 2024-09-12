import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:todo_do_app/auth/logic/firebase_auth_service.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: FirebaseAuthService.getProfileImage,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            const SizedBox(height: 20),
            const Text('Option 1'),
            const Text('Option 2'),
            const Text('Option 3'),
            const Text('Option 4'),
          ],
        ),
      ),
    );
  }
}
