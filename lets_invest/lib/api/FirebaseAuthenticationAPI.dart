// ignore_for_file: prefer_final_fields

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthenticationAPI {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "Login successfull";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  Future<String> signUp(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return "Register successfull";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }
}
