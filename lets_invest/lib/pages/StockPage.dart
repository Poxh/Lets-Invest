// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lets_invest/api/BuilderAPI.dart';
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
                    buildStock(context, "IE00B4L5Y983", "Core MSCI World USD (Acc)", "80,07", "75,14", "0,08", false),
                    buildStock(context, "XF000BTC0017", "Bitcoin", "0,0023", "53,42", "0,70", false),
                    buildStock(context, "XF000ETH0019", "Ethereum", "0,0281", "46,27", "1,40", false),
                    buildStock(context, "US0378331005", "Apple", "0,0663", "10,57", "0,58", false),
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

Widget buildStock(BuildContext context, isin, stockName, quantity, price, changePrice, lostMoney) {
  return Padding(
    padding: EdgeInsets.only(left: 10.w, right: 10.w),
    child: Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 6, 6, 6),
        borderRadius: BorderRadius.circular(20.sp),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 7.h, bottom: 7.h, left: 7.w, right: 12.w),
            child: BuilderAPI.buildStockPicture(isin)
          ),
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 2.h),
                    child: BuilderAPI.buildText(text: stockName, color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(2.sp),
                        child: BuilderAPI.buildText(text: "x " + quantity, color: Colors.grey, fontSize: 13.sp, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 12.h, right: 15.w, top: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                BuilderAPI.buildText(text: price + "€", color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.bold),
                SizedBox(height: 3.h),  
                Row(
                  children: [
                    BuilderAPI.buildText(text: "+ " + price + "€ • 4.76%", color: Colors.green, fontSize: 11.sp, fontWeight: FontWeight.bold), 
                  ],
                )
              ],
            )
          ),
        ],
      ),
    ),
  );
}


