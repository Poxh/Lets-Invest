// ignore_for_file: prefer_final_fields

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthenticationAPI {
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    Future<User?> signIn({required String email, required String password}) async {
      User? user;
      try {
        UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        print(e);
      }
      return user;
    }

    Future<Map<Object, dynamic>?> signUp({required String email, required String password}) async {
      User? user;
      try {
        UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
        user = userCredential.user;
        Map<Object, dynamic> res = jsonDecode('{"message": "Register successfull", "user": ${user}}');
      } on FirebaseAuthException catch (e) {
        Map<Object, dynamic> res = jsonDecode('{"message": "${e.message}", "user": ${null}}');
        return res;
      }
    }
}