import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../api/BuilderAPI.dart';

class Summary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stat(title: "Open", value: "74,50€", hasMadeLost: false),
            Container(width: 30.w),
            Stat(title: "Close", value: "74,50€", hasMadeLost: false),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stat(title: "High", value: "74,50€", hasMadeLost: false),
            Container(width: 30.w),
            Stat(title: "Low", value: "7411,50€", hasMadeLost: false),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stat(
                title: "Average",
                value: "74,50€", hasMadeLost: false),
            Container(width: 30.w),
            Stat(
                title: "Change",
                value: "74,50€", hasMadeLost: false),
          ],
        ),
      ],
    );
  }
}

class Stat extends StatelessWidget {
  final String title;
  final String value;
  final bool hasMadeLost;

  Stat({required this.title, required this.value, required this.hasMadeLost});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: Container(
        padding: EdgeInsets.only(bottom: 10.h, top: 10.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: theme.dividerColor,
              width: 1.0.w,
            ),
          ),
        ),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          BuilderAPI.buildText(text: title, color: Colors.grey, fontSize: 14.sp, fontWeight: FontWeight.normal),

          title != "Change" 
          ? BuilderAPI.buildText(text: value, color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold)
          : Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 16, 16, 30),
              borderRadius: BorderRadius.circular(5.sp)
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 7.w, right: 7.w, top: 5.h, bottom: 5.h),
              child: Row(
                children: [
                  BuilderAPI.buildText(text: value, color: hasMadeLost ? Colors.green : Colors.red, 
                  fontSize: 14.sp, fontWeight: FontWeight.bold),
                  SizedBox(width: 5.w),
                  Icon(
                    hasMadeLost
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                    color: hasMadeLost
                        ? Colors.green
                        : Colors.red,
                    size: 15.sp),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}