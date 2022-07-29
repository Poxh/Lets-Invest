// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class BuilderAPI {

  static Widget buildText({required String text, required Color color, required double fontSize, required FontWeight fontWeight}) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }   

  static Widget buildTextFormField({required text, required TextEditingController controller, required bool obscureText}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        obscureText: obscureText,
        autofocus: false,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(12)
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
            borderRadius: BorderRadius.circular(12)
          ),
          hintText: text,
          hintStyle: TextStyle(color: Colors.white),
          fillColor: Color.fromARGB(255, 15, 15, 15),
          filled: true
        ),
      ),
    );
  }

  static Widget buildTitle(double height) {
    return Align(
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
    );
  } 
}