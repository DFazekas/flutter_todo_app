import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth auth;

  Auth({this.auth});

  // Gets the user whenever there's a state change.
  Stream<User> get user => auth.authStateChanges();

  /// Create user account in Firebase.
  Future<String> createAccount({String email, String password}) async {
    try {
      // Create a Firebase user, trimming the username and password.
      await auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      return "Success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      rethrow;
    }
  }

  /// Sign user into Firebase.
  Future<String> signIn({String email, String password}) async {
    try {
      // Create a Firebase user, trimming the username and password.
      await auth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      return "Success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      rethrow;
    }
  }

  /// Sign user out of Firebase.
  Future<String> signOut() async {
    try {
      // Create a Firebase user, trimming the username and password.
      await auth.signOut();
      return "Success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      rethrow;
    }
  }
}
