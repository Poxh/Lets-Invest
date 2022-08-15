// ignore_for_file: override_on_non_overriding_member, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lets_invest/api/BuilderAPI.dart';
import 'package:lets_invest/api/CalculationAPI.dart';
import 'package:lets_invest/components/ChartFilter.dart';
import 'package:lets_invest/data/InstrumentDetail.dart';

import '../api/WebsocketAPI.dart';
import '../data/StockDetail.dart';

class StockAboutPage extends StatefulWidget {
  const StockAboutPage({Key? key}) : super(key: key);

  @override
  State<StockAboutPage> createState() => _StockAboutPageState();
}

class _StockAboutPageState extends State<StockAboutPage> {
  BuilderAPI builderAPI = BuilderAPI();
  Icon icon =
      Icon(Icons.star_border_outlined, color: Colors.white, size: 30.sp);
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var tag = WebsocketAPI.latestInstrumentDetail;
    bool isIntlSymbolNull = tag["intlSymbol"] == null;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Padding(
          padding: EdgeInsets.only(left: 25.w),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: BuilderAPI.buildStockPicture(
                    StockDetail.fromJson(WebsocketAPI.latestStockDetail).isin,
                    30.w,
                    30.h),
              ),
              BuilderAPI.buildText(
                  text: isIntlSymbolNull ? "No data" : tag["intlSymbol"],
                  color: Colors.white,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold),
            ],
          ),
        ),
        backgroundColor: Color.fromARGB(255, 8, 8, 15),
        elevation: 1,
        actions: [
          IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              iconSize: 1.sp,
              splashRadius: 5.sp,
              onPressed: () {
                setState(() {
                  if (isFavorite) {
                    isFavorite = false;
                    icon = Icon(Icons.star_border_outlined,
                        color: Colors.white, size: 30.sp);
                  } else {
                    isFavorite = true;
                    icon = Icon(Icons.star, color: Colors.yellow, size: 30.sp);
                  }
                });
              },
              icon: icon),
          SizedBox(width: 25.w)
        ],
      ),
      backgroundColor: Color.fromARGB(255, 8, 8, 15),
      body: Padding(
        padding: EdgeInsets.only(top: 10.h),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Divider(
              color: Color.fromARGB(50, 255, 255, 255),
              thickness: 3.h,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.h),
              child: Container(
                color: Color.fromARGB(255, 8, 8, 15),
                child: Column(
                  children: [
                    buildHeader(
                        CalculationAPI.hasMadeLost(
                            WebsocketAPI.getCurrentStockValue(),
                            WebsocketAPI.getStartStockValue()),
                        tag,
                        isIntlSymbolNull),
                    Padding(
                      padding: EdgeInsets.only(top: 40.h, bottom: 50.h),
                      child: SizedBox(
                        height: 300.h,
                        child: builderAPI.buildChart(context),
                      ),
                    ),
                    ChartFilter(onTap: (() {
                      print("HELLO");
                    })),
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

  Widget buildTag(index) {
    var tag = WebsocketAPI.latestInstrumentDetail["tags"][index];
    return Container(
      width: double.maxFinite,
      height: 5.h,
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 12, 12, 15),
          borderRadius: BorderRadius.circular(12.sp)),
      child: Row(
        children: [
          SizedBox(
            width: 25.w,
            height: 25.h,
            child: Image.network(tag["icon"]),
          ),
          BuilderAPI.buildText(
              text: tag["name"],
              color: Colors.white,
              fontSize: 15.sp,
              fontWeight: FontWeight.bold)
        ],
      ),
    );
  }

  Widget buildIntervalSelection() {
    return Padding(
      padding: EdgeInsets.only(top: 15.h),
      child: Padding(
        padding: EdgeInsets.only(left: 25.w, right: 25.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
                child: TextButton(
                    onPressed: () {},
                    child: BuilderAPI.buildText(
                        text: "1T",
                        color: Colors.white,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold))),
            Container(
                child: TextButton(
                    onPressed: () {},
                    child: BuilderAPI.buildText(
                        text: "1W",
                        color: Colors.white,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold))),
            Container(
                child: TextButton(
                    onPressed: () {},
                    child: BuilderAPI.buildText(
                        text: "1M",
                        color: Colors.white,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold))),
            Container(
                child: TextButton(
                    onPressed: () {},
                    child: BuilderAPI.buildText(
                        text: "1J",
                        color: Colors.white,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold))),
            Container(
                height: 30.h,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 0, 0),
                    borderRadius: BorderRadius.circular(3.sp)),
                child: TextButton(
                    onPressed: () {},
                    child: BuilderAPI.buildText(
                        text: "MAX",
                        color: Colors.white,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold))),
            SizedBox(width: 0.w)
          ],
        ),
      ),
    );
  }

  Widget buildStockTitle() {
    var tag = WebsocketAPI.latestInstrumentDetail;
    return Padding(
      padding: EdgeInsets.only(left: 25.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              BuilderAPI.buildStockPicture(
                  StockDetail.fromJson(WebsocketAPI.latestStockDetail).isin,
                  30.w,
                  30.h),
              SizedBox(width: 10.w),
              SizedBox(
                width: 270.w,
                child: BuilderAPI.buildText(
                    text: tag["intlSymbol"],
                    color: Colors.white,
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          BuilderAPI.buildText(
              text: tag["exchanges"][0]["nameAtExchange"],
              color: Colors.white,
              fontSize: 15.sp,
              fontWeight: FontWeight.bold),
          SizedBox(height: 5.h),
          buildProfitLost(CalculationAPI.hasMadeLost(
              WebsocketAPI.getCurrentStockValue(),
              WebsocketAPI.getStartStockValue()))
        ],
      ),
    );
  }

  Widget buildEvent(index) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(
        WebsocketAPI.latestStockDetail["events"][index]["timestamp"]);

    return Padding(
      padding: EdgeInsets.only(right: 20.w),
      child: Container(
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 35, 35, 35),
            borderRadius: BorderRadius.circular(5.sp)),
        child: Padding(
          padding:
              EdgeInsets.only(left: 20.w, right: 20.w, top: 12.h, bottom: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  BuilderAPI.buildText(
                      text: date.day.toString(),
                      color: Colors.white,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold),
                  Padding(
                    padding: EdgeInsets.only(left: 40.w, top: 20.h),
                    child: BuilderAPI.buildText(
                        text: WebsocketAPI.latestStockDetail["events"][index]
                            ["title"],
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.normal),
                  )
                ],
              ),
              BuilderAPI.buildText(
                  text: BuilderAPI.getMonthName(date.month - 1),
                  color: Colors.white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.normal,
                  maxLines: 1),
              SizedBox(height: 10.h),
              SizedBox(
                width: 250.w,
                child: BuilderAPI.buildText(
                    text: WebsocketAPI.latestStockDetail["events"][index]
                        ["description"],
                    color: Colors.grey,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.normal,
                    maxLines: 5),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfitLost(bool hasMadeLost) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 5.h),
          child: BuilderAPI.buildText(
              text: CalculationAPI.calculateProfitLostInEUR(
                          WebsocketAPI.getCurrentStockValue(),
                          WebsocketAPI.getStartStockValue())
                      .toStringAsFixed(2)
                      .replaceAll("-", "") +
                  "€",
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold),
        ),
        Container(
          width: 100.w,
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 35, 35, 35),
              borderRadius: BorderRadius.circular(7.sp)),
          child: Padding(
            padding:
                EdgeInsets.only(left: 5.w, right: 5.w, top: 7.h, bottom: 7.h),
            child: Row(
              children: [
                BuilderAPI.buildText(
                    text: CalculationAPI.calculateProfitLostInPercentage(
                                WebsocketAPI.getCurrentStockValue(),
                                WebsocketAPI.getStartStockValue())
                            .toStringAsFixed(2)
                            .replaceAll("-", "") +
                        "%",
                    color: hasMadeLost ? Colors.red : Colors.green,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold),
                Icon(hasMadeLost ? Icons.arrow_downward : Icons.arrow_upward,
                    color: hasMadeLost ? Colors.red : Colors.green,
                    size: 15.sp),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildBuyButton() {
    return Padding(
      padding: EdgeInsets.only(left: 25.w, right: 25.w),
      child: ElevatedButton(
          onPressed: () {},
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
            minimumSize: MaterialStateProperty.all<Size>(Size.fromHeight(50)),
          ),
          child: BuilderAPI.buildText(
              text: "Kaufen",
              color: Colors.white,
              fontSize: 13.sp,
              fontWeight: FontWeight.bold)),
    );
  }

  Widget buildChartFooterInformation(title, value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          BuilderAPI.buildText(
              text: title,
              color: Colors.grey,
              fontSize: 13.sp,
              fontWeight: FontWeight.bold),
          SizedBox(width: 10.w),
          SizedBox(
            width: 90.w,
            child: BuilderAPI.buildText(
                text: value,
                color: Colors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  static Widget buildHeader(hasMadeLost, tag, isIntlSymbolNull) {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 10.w),
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        onTap: (() {}),
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 6, 6, 6),
            borderRadius: BorderRadius.circular(20.sp),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 2.h),
                        child: Row(
                          children: [
                            BuilderAPI.buildStockPicture(
                                StockDetail.fromJson(
                                        WebsocketAPI.latestStockDetail)
                                    .isin,
                                30.w,
                                30.h),
                            SizedBox(width: 10.w),
                            SizedBox(
                              width: 100.w,
                              child: BuilderAPI.buildText(
                                  text: isIntlSymbolNull
                                      ? "No data"
                                      : tag["intlSymbol"],
                                  color: Colors.white,
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(2.sp),
                            child: SizedBox(
                              width: 210.w,
                              child: BuilderAPI.buildText(
                                  text: tag["exchanges"][0]["nameAtExchange"],
                                  color: Colors.white,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                  padding:
                      EdgeInsets.only(bottom: 12.h, right: 15.w, top: 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      BuilderAPI.buildText(
                          text: CalculationAPI.calculateProfitLostInEUR(
                                      WebsocketAPI.getCurrentStockValue(),
                                      WebsocketAPI.getStartStockValue())
                                  .toStringAsFixed(2)
                                  .replaceAll("-", "") +
                              "€",
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold),
                      SizedBox(height: 3.h),
                      Row(
                        children: [
                          FittedBox(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 35, 35, 35),
                                  borderRadius: BorderRadius.circular(7.sp)),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 5.w,
                                    right: 5.w,
                                    top: 7.h,
                                    bottom: 7.h),
                                child: Row(
                                  children: [
                                    BuilderAPI.buildText(
                                        text: CalculationAPI
                                                    .calculateProfitLostInPercentage(
                                                        WebsocketAPI
                                                            .getCurrentStockValue(),
                                                        WebsocketAPI
                                                            .getStartStockValue())
                                                .toStringAsFixed(2)
                                                .replaceAll("-", "") +
                                            "%",
                                        color: hasMadeLost
                                            ? Colors.red
                                            : Colors.green,
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold),
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
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
