import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthDataSource {
  final FirebaseAuth _auth;

  FirebaseAuthDataSource(this._auth);

  Future<User> login(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user!;
  }

  Future<User> register(String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user!;
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }
}
