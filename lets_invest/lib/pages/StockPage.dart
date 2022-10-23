// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lets_invest/api/BuilderAPI.dart';
import 'package:lets_invest/api/WebsocketAPI.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../api/CalculationAPI.dart';

import '../data/Crypto.dart';
import '../data/Stock.dart';

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
    websocketAPI.sendMessageToWebSocket(' {"type":"ticker","id":"XF000BTC0017.BHS"}');
    websocketAPI.sendMessageToWebSocket(' {"type":"ticker","id":"XF000ETH0019.BHS"}');
    websocketAPI.sendMessageToWebSocket(' {"type":"ticker","id":"XF000XRP0018.BHS"}');
    websocketAPI.sendMessageToWebSocket(' {"type":"ticker","id":"US0378331005.LSX"}');
    websocketAPI.sendMessageToWebSocket(' {"type":"ticker","id":"US0231351067.LSX"}');
    websocketAPI.sendMessageToWebSocket(' {"type":"ticker","id":"IE00B4L5Y983.LSX"}');
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Color.fromARGB(255, 14, 14, 14),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 50.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 5.h, top: 55, left: 25.w),
                  child: BuilderAPI.buildText(
                      text: "Current value",
                      color: Colors.grey,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.normal),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 5.h, left: 25.w),
                  child: BuilderAPI.buildText(
                      text: "982,44€",
                      color: Colors.white,
                      fontSize: 35.sp,
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 50.h, left: 25.w),
                  child: Row(
                    children: [
                      Icon(
                        CalculationAPI.hasMadeLost(982.44, 392.12)
                            ? Icons.arrow_downward
                            : Icons.arrow_upward,
                        color: CalculationAPI.hasMadeLost(982.44, 392.12)
                            ? Colors.red
                            : Colors.green,
                        size: 15.sp,
                      ),
                      SizedBox(width: 3.w),
                      BuilderAPI.buildText(
                          text: CalculationAPI.calculateProfitLostInEUR(
                                      982.44, 392.12)
                                  .toStringAsFixed(2)
                                  .replaceAll("-", "") +
                              "€ • " +
                              CalculationAPI.calculateProfitLostInPercentage(
                                      982.44, 392.12)
                                  .toStringAsFixed(2)
                                  .replaceAll("-", "") +
                              " %",
                          color: CalculationAPI.hasMadeLost(982.44, 392.12)
                              ? Colors.red
                              : Colors.green,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10.h, left: 25.w),
                  child: BuilderAPI.buildText(
                      text: "Stocks & ETF's",
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold),
                ),
                StreamBuilder(
                    stream: WebsocketAPI.getStockValueStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return BuilderAPI.buildSearchSkeleton();
                      } else if (snapshot.hasData) {
                        List<Stock> stockList = (snapshot.data as List<Stock>);

                        return SizedBox(
                          height: 170.h,
                          child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: stockList.length,
                              itemBuilder: (context, index) {
                                Stock stock = stockList[index];
                                return BuilderAPI.buildStock(
                                    context,
                                    stock.isin,
                                    "LSX",
                                    stock.name,
                                    stock.quantity > 1.0 
                                    ? stock.quantity.toString() + " Stocks"
                                    : stock.quantity.toString() + " Stock",
                                    stock.quantity * stock.price,
                                    stock.quantity * stock.boughtAT,
                                    websocketAPI);
                              }),
                        );
                      } else {
                        return BuilderAPI.buildText(
                            text: "NOOOOO",
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.normal);
                      }
                    }),
                Padding(
                  padding: EdgeInsets.only(bottom: 10.h, top: 50.h, left: 25.w),
                  child: BuilderAPI.buildText(
                      text: "Cryptos",
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 50.h),
                  child: StreamBuilder(
                      stream: WebsocketAPI.getCryptoValueStream(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return BuilderAPI.buildSearchSkeleton();
                        } else if (snapshot.hasData) {
                          List<Crypto> cryptoList =
                              (snapshot.data as List<Crypto>);
                          return SizedBox(
                            height: 170.h,
                            child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemCount: cryptoList.length,
                                itemBuilder: (context, index) {
                                  Crypto crypto = cryptoList[index];
                                  return BuilderAPI.buildStock(
                                      context,
                                      crypto.isin,
                                      "BHS",
                                      crypto.name,
                                      crypto.quantity.toString() + " Cryptos",
                                      crypto.quantity * crypto.price,
                                      crypto.quantity * crypto.boughtAT,
                                      websocketAPI);
                                }),
                          );
                        } else {
                          return BuilderAPI.buildText(
                              text: "NOOOOO",
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.normal);
                        }
                      }),
                ),
              ],
            ),
          ),
        ));
  }

  @override
  void dispose() {
    websocketAPI.webSocketChannel.sink.close();
    print("Disosed");
    super.dispose();
  }

  String ammount = "";
}
