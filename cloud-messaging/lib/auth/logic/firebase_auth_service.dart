import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_do_app/storage/logic/firebase_storage_service.dart';

class FirebaseAuthService {
  static final _auth = FirebaseAuth.instance;

  static Future<User?> createAccount({
    required String name,
    required String password,
    required String email,
    required File profileImage,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final userCredential = await login(email, password);
      final imageUrl = await _saveImage(profileImage, userCredential!.uid);
      await userCredential.updateDisplayName(name);
      await userCredential.updatePhotoURL(imageUrl);
      return userCredential;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  static Future<User?> login(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  static Future<String> _saveImage(File file, String userId) async {
    return await FirebaseStorageService.uploadProfileImage(file, userId);
  }

  static Future<void> logout() async {
    await _auth.signOut();
  }

  static User? get currentUser {
    return _auth.currentUser;
  }

  static String get getProfileImage {
    return _auth.currentUser!.photoURL!;
  }
}
