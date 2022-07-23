import 'package:flutter/cupertino.dart';

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

}