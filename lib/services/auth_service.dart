import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseAuth get auth => _auth;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential> signIn(String email, String password) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);

  Future<UserCredential> register(String email, String password) =>
      _auth.createUserWithEmailAndPassword(email: email, password: password);

  // anonymous sign-in removed to enforce authenticated logins only

  Future<void> signOut() => _auth.signOut();
}
