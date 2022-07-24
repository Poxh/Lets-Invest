// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:lets_invest/api/BuilderAPI.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 6, 6, 6),
      body: Column(
        children: [
          BuilderAPI.buildTextField(text: "Email"),
          SizedBox(height: 10),
          BuilderAPI.buildTextField(text: "Password"),
          SizedBox(height: 10),
          BuilderAPI.buildTextField(text: "Confirm Password"),
          buildLogoutButton(context)
        ],
      ),
    );
  }

  Widget buildLogoutButton(BuildContext context)   {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size.fromHeight(50),
        ),
        onPressed: () {  },
        child: Text(
          'Logout',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}