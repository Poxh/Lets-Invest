// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lets_invest/api/BuilderAPI.dart';
import 'package:lets_invest/api/WebsocketAPI.dart';

class StockPage extends StatefulWidget {
  @override
  State<StockPage> createState() => _StockPageState();

   static List<FlSpot> generateSampleData() {
    final List<FlSpot> result = [];
    final numPoints = 35;
    final maxY = 6;

    double prev = 0;

    for (int i = 0; i < numPoints; i++) {
      final next = prev +
          Random().nextInt(3).toDouble() % -1000 * i +
          Random().nextDouble() * maxY / 10;

      prev = next;

      result.add(
        FlSpot(i.toDouble(), next),
      );
    }

    return result;
  }
}

class _StockPageState extends State<StockPage> {
  static WebsocketAPI websocketAPI = WebsocketAPI();  
  String portfolioValue = "";

  @override
  void initState() {
    super.initState();
    websocketAPI.initializeConnection();
    websocketAPI.sendMessageToWebSocket('sub ' +
              WebsocketAPI.randomNumber().toString() +
              ' {"type":"ticker","id":"XF000BTC0017.BHS"}');
  }

  List<String> stocks = ["TEST", "WWW", "dsadasda"];
  DateTime date = DateTime.fromMillisecondsSinceEpoch(1659418200000);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 6, 6, 6),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 50.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 25.w),
                child: BuilderAPI.buildText(text: date.toString(), color: Colors.white, fontSize: 28.sp, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.only(left: 25.w),
                child: BuilderAPI.buildText(text: portfolioValue, color: Colors.white, fontSize: 30.sp, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.only(left: 25.w),
                child: Row(
                  children: [
                    Icon(Icons.arrow_upward, color: Colors.green, size: 12.sp),
                    SizedBox(width: 5.w),
                    BuilderAPI.buildText(text: "0,32€", color: Colors.green, fontSize: 12.sp, fontWeight: FontWeight.bold), 
                    SizedBox(width: 5.w),
                    BuilderAPI.buildText(text: "(0,15%)", color: Colors.green, fontSize: 12.sp, fontWeight: FontWeight.bold), 
                    SizedBox(width: 10.w),
                    BuilderAPI.buildTranslatedText(context, "Heute", Colors.grey, 12.sp, FontWeight.bold)
                  ],
                )
              ),
              
              Padding(
                padding: EdgeInsets.only(bottom: 10.h, left: 25.w),
                child: BuilderAPI.buildText(text: "Investments", color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
              Container(
                height: 300.h,
                child: Column(
                  children: [
                    BuilderAPI.buildStock(context, "IE00B4L5Y983", "Core MSCI World USD (Acc)", "x 1,0638", BuilderAPI.randomValue(), BuilderAPI.randomValue(), 40, 40), 
                    BuilderAPI.buildStock(context, "XF000BTC0017", "Bitcoin", "x 0,0023", BuilderAPI.randomValue(), BuilderAPI.randomValue(), 40, 40),
                    BuilderAPI.buildStock(context, "XF000ETH0019", "Ethereum", "x 0,0281", BuilderAPI.randomValue(), BuilderAPI.randomValue(), 40, 40),
                    BuilderAPI.buildStock(context, "US0378331005", "Apple", "x 0,0663", BuilderAPI.randomValue(), BuilderAPI.randomValue(), 40, 40),
                  ],
                ),
              ),
              StreamBuilder(
                stream: WebsocketAPI.getStockValueStream(),
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting) {
                    return BuilderAPI.buildText(text: "Waiting", 
                    color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.normal);
                  } else if(snapshot.hasData) {
                    return BuilderAPI.buildText(text: snapshot.data.toString(), 
                  color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.normal);
                  } else {
                    return BuilderAPI.buildText(text: "NOOOOO", 
                  color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.normal);
                  }
                }
              )
            ],
          ),
        ),
      )
    );
  }

  String ammount = "";
}

