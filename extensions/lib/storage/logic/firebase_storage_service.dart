import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  static final _storage = FirebaseStorage.instance.ref();

  static Future<String> uploadProfileImage(File image, String userId) async {
    final userRef = _storage.child('users').child(userId);
    final userSnap = await userRef.putFile(image);
    return await userSnap.ref.getDownloadURL();
  }

  static Future<String> uploadTaskImage(File image, String taskId) async {
    final userRef = _storage.child('tasks').child(taskId);
    final userSnap = await userRef.putFile(image);
    return await userSnap.ref.getDownloadURL();
  }

  static Future<void> deleteImage(String taskId) async {
    await _storage.child('tasks').child(taskId).delete();
  }
}
