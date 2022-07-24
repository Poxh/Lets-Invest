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
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(12)
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
            borderRadius: BorderRadius.circular(12)
          ),
          hintText: text,
          fillColor: Colors.grey[300],
          filled: true
        ),
      ),
    );
  } 
}