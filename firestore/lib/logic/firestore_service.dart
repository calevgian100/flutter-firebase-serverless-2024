import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static final _firestore = FirebaseFirestore.instance;

  static Future<void> addTask({
    required String name,
    required String description,
  }) async {
    await _firestore.collection('tasks').add({
      'name': name,
      'description': description,
      'create_at': DateTime.now(),
    });
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
    await _firestore.collection('tasks').doc(id).delete();
  }

  // Obtain a single task
  static Future<Map<String, dynamic>?> getTask(String id) async {
    final task = await _firestore.collection('tasks').doc(id).get();
    return task.data();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> listenTasks() {
    return _firestore.collection('tasks').snapshots();
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
}
