import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_do_app/auth/logic/firebase_auth_service.dart';
import 'package:todo_do_app/storage/logic/firebase_storage_service.dart';

class FirestoreService {
  static final _firestore = FirebaseFirestore.instance;

  static Future<void> addTask({
    required String name,
    required String description,
    required File image,
  }) async {
    final task = await _firestore.collection('tasks').add({
      'name': name,
      'description': description,
      'create_at': DateTime.now(),
      'user_id': FirebaseAuthService.currentUser!.uid,
    });

    final imageUrl =
        await FirebaseStorageService.uploadTaskImage(image, task.id);

    await updateTaskImage(id: task.id, imageUrl: imageUrl);
  }

  // This method allows us to modify an existing task or to add one with
  // the ID that we want.
  // static Future<void> addTask({
  //   required String name,
  //   required String description,
  // }) async {
  //   await _firestore.collection('tasks').doc('testing').set({
  //   'name': name,
  //   'description': description,
  //   'created_at': DateTime.now().toIso8601String(),
  // });
  // }

  static Future<List<Map<String, dynamic>>> getTasks() async {
    final tasks = await _firestore.collection('tasks').get();
    return tasks.docs.map((docSnap) {
      final task = docSnap.data();
      task['id'] = docSnap.id;
      return task;
    }).toList();
  }

  static Future<void> deleteTask(String id) async {
    await FirebaseStorageService.deleteImage(id);
    await _firestore.collection('tasks').doc(id).delete();
  }

  // Obtain a single task
  static Future<Map<String, dynamic>?> getTask(String id) async {
    final task = await _firestore.collection('tasks').doc(id).get();
    return task.data();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> listenTasks() {
    return _firestore
        .collection('tasks')
        .where('user_id', isEqualTo: FirebaseAuthService.currentUser!.uid)
        .snapshots();
  }

  static Future<void> updateTask({
    required String id,
    required String name,
    required String description,
  }) async {
    await _firestore.collection('tasks').doc(id).update({
      'name': name,
      'description': description,
    });
  }

  static Future<void> updateTaskImage({
    required String id,
    required String imageUrl,
  }) async {
    await _firestore.collection('tasks').doc(id).update({
      'imageUrl': imageUrl,
    });
  }
}
