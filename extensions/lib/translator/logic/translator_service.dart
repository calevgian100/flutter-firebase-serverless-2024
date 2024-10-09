import 'package:cloud_firestore/cloud_firestore.dart';

class TranslatorService {
  static final _firestore = FirebaseFirestore.instance;

  static Future<void> translateText(String textToTranslate) async {
    await _firestore
        .collection('translations')
        .doc('XCwvlbWayNZMYTQEeYPU')
        .set({
      'input': textToTranslate,
    });
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> listenToTranslations() {
    return _firestore
        .collection('translations')
        .doc('XCwvlbWayNZMYTQEeYPU')
        .snapshots();
  }
}
