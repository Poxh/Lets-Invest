// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lets_invest/api/AuthenticationAPI.dart';
import 'package:lets_invest/api/BuilderAPI.dart';
import 'package:lets_invest/api/FirebaseAuthenticationAPI.dart';
import 'package:lets_invest/pages/Success.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final FirebaseAuthenticationAPI firebaseAuthenticationAPI = FirebaseAuthenticationAPI();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 6, 6, 6),
      body: Column(
        children: [
          BuilderAPI.buildTitle(height),
          SizedBox(height: 20),
          BuilderAPI.buildText(text: "Hello 👋", color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
          BuilderAPI.buildText(text: "and welcome to lets invest", color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold),
          BuilderAPI.buildText(text: "register today and learn how to invest", color: Colors.grey, fontSize: 15, fontWeight: FontWeight.bold),
          SizedBox(height: 45),
          BuilderAPI.buildTextFormField(text: "Email", controller: emailController),
          SizedBox(height: 20),
          BuilderAPI.buildTextFormField(text: "Password", controller: passwordController),
          SizedBox(height: 20),
          BuilderAPI.buildTextFormField(text: "Confirm Password", controller: confirmPasswordController),
          SizedBox(height: 20),
          buildLogoutButton(context)
        ],
      )
    );
  }

  Widget buildLogoutButton(BuildContext context)   {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 15, 15, 15)),
          minimumSize: MaterialStateProperty.all<Size>(Size.fromHeight(50)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.grey)
            )
          )
        ),
        onPressed: () async { 
          User? user = await firebaseAuthenticationAPI.signIn(email: emailController.text, password: passwordController.text);
          if (user != null) {
            AuthenticationAPI authenticationAPI = AuthenticationAPI();
            bool isAuthenticated = await authenticationAPI.authenticate();
            if(isAuthenticated) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Success()),
              );
            }
          }
        },
        child: Text(
          'Sign up',
          style: TextStyle(fontSize: 20),
        ),
      )
    );
  }
}