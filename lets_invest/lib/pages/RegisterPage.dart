// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:lets_invest/api/BuilderAPI.dart';
import 'package:lottie/lottie.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 6, 6, 6),
      body: Column(
        children: [

          Align(
            alignment: FractionalOffset.topCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 10.0, top: height * 0.15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.insert_chart_outlined_outlined, color: Colors.white, size: 40),
                    SizedBox(width: 10),
                    BuilderAPI.buildText(text: "Lets Invest", color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)
                  ],
                )
            ),
          ),

          Align(
            alignment: FractionalOffset.topCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 10.0, top: height * 0.06),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BuilderAPI.buildText(text: "Hello 👋", color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
                    BuilderAPI.buildText(text: "and welcome to Lets Invest", color: Color.fromARGB(255, 160, 160, 160), fontSize: 20, fontWeight: FontWeight.bold),
                    SizedBox(height: height * 0.01),
                    BuilderAPI.buildText(text: "register and learn today how to invest", color: Color.fromARGB(255, 160, 160, 160), fontSize: 15, fontWeight: FontWeight.bold),
                  ],
                )
            ),
          ),

          SizedBox(height: height * 0.06),

          BuilderAPI.buildTextField(text: "Email"),
          SizedBox(height: 10),
          BuilderAPI.buildTextField(text: "Password"),
          SizedBox(height: 10),
          BuilderAPI.buildTextField(text: "Confirm Password"),
          SizedBox(height: 10),
          buildLogoutButton(context),
        ],
      ),
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
        onPressed: () {  },
        child: Text(
          'Sign up',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}