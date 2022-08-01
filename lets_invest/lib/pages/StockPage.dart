// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lets_invest/api/BuilderAPI.dart';
import 'package:lets_invest/api/CalculationAPI.dart';
import 'package:lets_invest/api/WebsocketAPI.dart';
import 'package:lets_invest/components/ChartPage.dart';

class StockPage extends StatefulWidget {
  
  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {

  static WebsocketAPI websocketAPI = new WebsocketAPI();

  @override
  void initState() {
    super.initState();
    websocketAPI.initializeConnection();
  }

  List<String> stocks = ["TEST", "WWW", "dsadasda"];

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
                child: BuilderAPI.buildText(text: "Portfolio", color: Colors.white, fontSize: 28.sp, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.only(left: 25.w),
                child: BuilderAPI.buildText(text: "193,47€", color: Colors.white, fontSize: 30.sp, fontWeight: FontWeight.bold),
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
                    BuilderAPI.buildText(text: "Heute", color: Colors.grey, fontSize: 12.sp, fontWeight: FontWeight.bold), 
                  ],
                )
              ),
              
              Padding(
                padding: EdgeInsets.only(top: 20.h, bottom: 20.h),
                child: ChartPage(lineColor: Colors.green, data: ChartPage.generateSampleData()),
              ),
              
              Padding(
                padding: EdgeInsets.only(bottom: 10.h, left: 25.w),
                child: BuilderAPI.buildText(text: "Investments", color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
              Container(
                height: 300.h,
                child: Column(
                  children: [
                    BuilderAPI.buildStock(context, "IE00B4L5Y983", "Core MSCI World USD (Acc)", "x 1,0638", BuilderAPI.randomValue(), BuilderAPI.randomValue()), 
                    BuilderAPI.buildStock(context, "XF000BTC0017", "Bitcoin", "x 0,0023", BuilderAPI.randomValue(), BuilderAPI.randomValue()),
                    BuilderAPI.buildStock(context, "XF000ETH0019", "Ethereum", "x 0,0281", BuilderAPI.randomValue(), BuilderAPI.randomValue()),
                    BuilderAPI.buildStock(context, "US0378331005", "Apple", "x 0,0663", BuilderAPI.randomValue(), BuilderAPI.randomValue()),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 12.h, bottom: 10.h, left: 30.w),
                child: Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: BuilderAPI.buildText(text: "Nicht-investierter-Betrag", color: Colors.white, fontSize: 17.sp, fontWeight: FontWeight.bold)
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 25.w),
                        child: BuilderAPI.buildText(text: "2,57€", color: Colors.white, fontSize: 17.sp, fontWeight: FontWeight.bold)
                      ),
                    ],
                  ),
                )
              ),
              Padding(
                padding: EdgeInsets.only(left: 30.w, right: 25.w),
                child: Divider(
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}

