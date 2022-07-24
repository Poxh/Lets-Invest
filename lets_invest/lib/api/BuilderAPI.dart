// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BuilderAPI {

  static Widget buildText({required String text, required Color color, required double fontSize, required FontWeight fontWeight}) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight
      ),
    );
  }   

  static Widget buildTextField({required text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        style: TextStyle(color: Colors.white),
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
}