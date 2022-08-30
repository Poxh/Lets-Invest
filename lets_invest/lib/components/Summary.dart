import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lets_invest/data/Aggregate.dart';

import '../api/BuilderAPI.dart';
import '../api/CalculationAPI.dart';
import '../api/WebsocketAPI.dart';

class Summary extends StatefulWidget {
  const Summary({ Key? key }) : super(key: key);

  @override
  State<Summary> createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  Aggregate aggregate = WebsocketAPI.aggregates[0];
  bool hasMadeLost = CalculationAPI.hasMadeLost(WebsocketAPI.aggregates[0].close, WebsocketAPI.aggregates[0].open);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 10.h, bottom: 15.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 15.h, bottom: 15.h),
            child: BuilderAPI.buildText(text: "Summary", color: Colors.white, fontSize: 25.sp, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stat(title: "Open", value: aggregate.open.toStringAsFixed(2) + "€", hasMadeLost: hasMadeLost),
              Container(width: 30.w),
              Stat(title: "Close", value: aggregate.close.toStringAsFixed(2) + "€", hasMadeLost: hasMadeLost),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stat(title: "High", value: aggregate.high.toStringAsFixed(2)+ "€", hasMadeLost: hasMadeLost),
              Container(width: 30.w),
              Stat(title: "Low", value: aggregate.low.toStringAsFixed(2) + "€", hasMadeLost: hasMadeLost),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stat(
                  title: "Volume",
                  value: aggregate.volume.toString() + "€", hasMadeLost: hasMadeLost),
              Container(width: 30.w),
              Stat(
                  title: "Change",
                  value: CalculationAPI.calculateProfitLostInPercentage(aggregate.close, aggregate.open).toStringAsFixed(2).replaceAll("-", "") 
                  + "%", hasMadeLost: hasMadeLost),
            ],
          ),
        ],
      ),
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
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(bottom: 10.h, top: 10.h),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          BuilderAPI.buildText(text: title, color: Colors.grey, fontSize: 14.sp, fontWeight: FontWeight.normal),

          title != "Change" 
          ? BuilderAPI.buildText(text: value, color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold)
          : Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 30, 30, 31),
              borderRadius: BorderRadius.circular(5.sp)
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 7.w, right: 7.w, top: 1.h, bottom: 1.h),
              child: Row(
                children: [
                  BuilderAPI.buildText(text: value, color: hasMadeLost ? Colors.red : Colors.green, 
                  fontSize: 14.sp, fontWeight: FontWeight.bold),
                  SizedBox(width: 5.w),
                  Icon(
                    hasMadeLost
                        ? Icons.arrow_downward
                        : Icons.arrow_upward,
                    color: hasMadeLost
                        ? Colors.red
                        : Colors.green,
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