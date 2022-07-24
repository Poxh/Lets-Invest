// ignore_for_file: prefer_final_fields

import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthenticationAPI {
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    Future<User?> signIn({required String email, required String password}) async {
      User? user;
      try {
        UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
        print("Email: " + email);
        print("Password: " + password);
        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        print(e);
      }
      return user;
    }

    Future<String?> signUp({required String email, required String password}) async {
      try {
        await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
        return "Signed in";
      } on FirebaseAuthException catch (e) {
        return e.message;
      }
    }
}