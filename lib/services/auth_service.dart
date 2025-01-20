import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    if (password.length < 6) {
      print("Password is too short: less than 6 characters");
      return null;
    }

    try {
      print("Creating user with email: $email");
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      assert(result.user != null, "User value cannot be null");
      print("User created successfully: ${result.user!.email}");

      if (result.additionalUserInfo != null) {
        print("Additional user info: ${result.additionalUserInfo!.profile}");
      }
      return result.user;
    } catch (e) {
      print("Error creating user: ${e.toString()}");
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      assert(result.user != null, "User value cannot be null");
      print("User signed in successfully: ${result.user!.email}");
      return result.user;
    } catch (e) {
      print("Error signing in user: ${e.toString()}");
      throw e;  // Propagate the error
    }
  }
}
