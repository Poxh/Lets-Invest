// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lets_invest/api/BuilderAPI.dart';

class ChartFilter extends StatelessWidget {
  final VoidCallback? onTap;

  ChartFilter({this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
              onTap: onTap, child: buildInterval("1T", Colors.transparent)),
          GestureDetector(
              onTap: onTap, child: buildInterval("1W", Colors.transparent)),
          GestureDetector(
              onTap: onTap, child: buildInterval("1M", Colors.transparent)),
          GestureDetector(
              onTap: onTap, child: buildInterval("1J", Colors.transparent)),
          GestureDetector(
              onTap: onTap,
              child: buildInterval("MAX", Color.fromARGB(255, 27, 27, 35))),
        ],
      ),
    );
  }

  Widget buildInterval(String text, Color color) {
    return Container(
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(3.sp)),
      child: Padding(
        padding:
            EdgeInsets.only(top: 7.h, bottom: 7.h, left: 15.w, right: 15.w),
        child: BuilderAPI.buildText(
            text: text,
            color: Colors.white,
            fontSize: 15.sp,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
