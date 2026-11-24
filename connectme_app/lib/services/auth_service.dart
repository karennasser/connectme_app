import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService(this.auth);
  final FirebaseAuth auth;

  User? get currentUser => auth.currentUser;
  Stream<User?> get authChanges => auth.authStateChanges();

  Future<UserCredential> login(String email, String password) =>
      auth.signInWithEmailAndPassword(email: email, password: password);

  Future<UserCredential> signUp(String email, String password) =>
      auth.createUserWithEmailAndPassword(email: email, password: password);

  Future<void> logout() => auth.signOut();
}
