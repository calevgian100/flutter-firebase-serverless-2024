import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  static final _auth = FirebaseAuth.instance;

  static Future<User?> createAccount({
    required String name,
    required String password,
    required String email,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final userCredential = await login(email, password);
      userCredential!.updateDisplayName(name);
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

  static Future<void> logout() async {
    await _auth.signOut();
  }

  static User? get currentUser {
    return _auth.currentUser;
  }
}
