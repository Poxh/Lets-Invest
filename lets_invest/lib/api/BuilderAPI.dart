// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lets_invest/api/WebsocketAPI.dart';
import 'package:lets_invest/data/Aggregate.dart';
import 'package:lets_invest/pages/StockAboutPage.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shimmer/shimmer.dart';
import 'CalculationAPI.dart';

class BuilderAPI {
  static String getLocale(context) {
    return Localizations.localeOf(context).languageCode;
  }

  static buildToolTipText(
      {required String text,
      required Color color,
      required double fontSize,
      required FontWeight fontWeight,
      int maxLines = 1}) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }

  static Widget buildText(
      {required String text,
      required Color color,
      required double fontSize,
      required FontWeight fontWeight,
      int maxLines = 1}) {
    TextStyle style = TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
    );

    return AutoSizeText(text,
        maxLines: maxLines,
        style: style,
        overflowReplacement: Tooltip(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 22, 21, 21),
            borderRadius: BorderRadius.circular(8),
          ),
          message: text,
          child: buildToolTipText(
              text: text,
              color: color,
              fontSize: fontSize,
              fontWeight: fontWeight),
        ));
  }

  static Widget buildTextFormField(
      {required text,
      required TextEditingController controller,
      required bool obscureText}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        obscureText: obscureText,
        autofocus: false,
        decoration: InputDecoration(
            enabledBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            hintText: text,
            hintStyle: TextStyle(color: Colors.white),
            fillColor: Color.fromARGB(255, 20, 23, 41),
            filled: true),
      ),
    );
  }

  static Widget buildTitle(double height) {
    return Align(
      alignment: FractionalOffset.topCenter,
      child: Padding(
          padding: EdgeInsets.only(bottom: 10.0, top: height * 0.15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.insert_chart_outlined_outlined,
                  color: Colors.white, size: 40),
              SizedBox(width: 10),
              BuilderAPI.buildText(
                  text: "Lets Invest",
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold)
            ],
          )),
    );
  }

  static Widget buildStockPicture(isin, double height, double width) {
    return Container(
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 21, 20, 20), shape: BoxShape.circle),
        height: height.h,
        width: width.w,
        child: Image.network(
            'https://assets.traderepublic.com/img/logos/' + isin + '/dark.png',
            errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.question_mark, color: Colors.white, size: 15.sp);
        }));
  }

  static Widget buildStock(BuildContext context, isin, type, stockName,
      String quantity, currentPrice, boughtPrice, websocketAPI) {
    return Padding(
      padding: EdgeInsets.only(left: 25.w, right: 25.w),
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: (() {
          openDetailedInformations(websocketAPI, isin, type, context);
        }),
        child: Container(
          width: 350.w,
          height: 60.h,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 14, 14, 14),
            borderRadius: BorderRadius.circular(20.sp),
          ),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: buildStockPicture(isin, 35.h, 35.w),
              ),
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 2.h),
                        child: SizedBox(
                          width: 100.w,
                          child: BuilderAPI.buildText(
                              text: stockName,
                              color: Colors.white,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(2.sp),
                            child: BuilderAPI.buildText(
                                text: quantity,
                                color: Colors.grey,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                  padding:
                      EdgeInsets.only(bottom: 12.h, right: 15.w, top: 15.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      BuilderAPI.buildText(
                          text: currentPrice.toStringAsFixed(2) + "€",
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold),
                      SizedBox(height: 3.h),
                      Row(
                        children: [
                          Icon(
                            CalculationAPI.hasMadeLost(
                                    currentPrice, boughtPrice)
                                ? Icons.arrow_downward
                                : Icons.arrow_upward,
                            color: CalculationAPI.hasMadeLost(
                                    currentPrice, boughtPrice)
                                ? Colors.red
                                : Colors.green,
                            size: 11.sp,
                          ),
                          SizedBox(width: 3.w),
                          BuilderAPI.buildText(
                              text: CalculationAPI.calculateProfitLostInEUR(
                                          currentPrice, boughtPrice)
                                      .toStringAsFixed(2)
                                      .replaceAll("-", "") +
                                  "€ • " +
                                  CalculationAPI
                                          .calculateProfitLostInPercentage(
                                              currentPrice, boughtPrice)
                                      .toStringAsFixed(2)
                                      .replaceAll("-", "") +
                                  " %",
                              color: CalculationAPI.hasMadeLost(
                                      currentPrice, boughtPrice)
                                  ? Colors.red
                                  : Colors.green,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold),
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

  static Widget buildPortolioDiversity(BuildContext context, isin, type,
      stockName, quantity, currentPrice, boughtPrice, websocketAPI) {
    return Padding(
      padding: EdgeInsets.only(left: 25.w, right: 25.w),
      child: Container(
        width: 350,
        height: 60.h,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 14, 14, 14),
          borderRadius: BorderRadius.circular(20.sp),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: buildStockPicture(isin, 35.h, 35.w),
            ),
            Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 2.h),
                      child: SizedBox(
                        width: 100.w,
                        child: BuilderAPI.buildText(
                            text: stockName,
                            color: Colors.white,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(2.sp),
                          child: BuilderAPI.buildText(
                              text: quantity.toString() + " Shares",
                              color: Colors.grey,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(bottom: 12.h, right: 15.w, top: 15.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    BuilderAPI.buildText(
                        text:
                            (quantity * currentPrice).toStringAsFixed(2) + "€",
                        color: Colors.white,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold),
                    SizedBox(height: 3.h),
                    Row(
                      children: [
                        Icon(
                          CalculationAPI.hasMadeLost(currentPrice, boughtPrice)
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                          color: CalculationAPI.hasMadeLost(
                                  currentPrice, boughtPrice)
                              ? Colors.red
                              : Colors.green,
                          size: 11.sp,
                        ),
                        SizedBox(width: 3.w),
                        BuilderAPI.buildText(
                            text: CalculationAPI.calculateProfitLostInEUR(
                                        currentPrice, boughtPrice)
                                    .toStringAsFixed(2)
                                    .replaceAll("-", "") +
                                "€ • " +
                                CalculationAPI.calculateProfitLostInPercentage(
                                        currentPrice, boughtPrice)
                                    .toStringAsFixed(2)
                                    .replaceAll("-", "") +
                                " %",
                            color: CalculationAPI.hasMadeLost(
                                    currentPrice, boughtPrice)
                                ? Colors.red
                                : Colors.green,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold),
                      ],
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }

  static Widget buildSearch(
      BuildContext context, isin, type, stockName, description, websocketAPI) {
    return Padding(
      padding: EdgeInsets.only(left: 10.w, right: 10.w),
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        onTap: (() {
          openDetailedInformations(websocketAPI, isin, type, context);
        }),
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 6, 6, 6),
            borderRadius: BorderRadius.circular(20.sp),
          ),
          child: Row(
            children: [
              Padding(
                  padding: EdgeInsets.only(
                      top: 7.h, bottom: 7.h, left: 7.w, right: 12.w),
                  child: BuilderAPI.buildStockPicture(isin, 40, 40)),
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 2.h),
                        child: BuilderAPI.buildText(
                            text: stockName,
                            color: Colors.white,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(2.sp),
                            child: BuilderAPI.buildText(
                                text: description,
                                color: Colors.grey,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void openDetailedInformations(
      WebsocketAPI websocketAPI, isin, type, context) {
    websocketAPI.sendMessageToWebSocket(' {"type":"aggregateHistoryLight","range":"1d","id":"$isin.$type"}');
    websocketAPI.sendMessageToWebSocket(' {"type":"stockDetails","id":"$isin","jurisdiction":"DE"}');
    websocketAPI.sendMessageToWebSocket(' {"type":"instrument","id":"$isin","jurisdiction":"DE"}');
    websocketAPI.sendMessageToWebSocket(' {"type":"ticker","id":"$isin.$type"}');
    websocketAPI.sendMessageToWebSocket(' {"type":"neonNews","isin":"$isin"}');
    Future.delayed(const Duration(milliseconds: 250), () {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => StockAboutPage()),
      );
    });
  }

  static double randomValue() {
    var random = Random();
    int randomInt = random.nextInt(100);
    return random.nextDouble() * randomInt;
  }

  static Widget buildTranslatedText(
      context, text, color, fontSize, fontWeight) {
    return BuilderAPI.buildText(
        text: text, color: color, fontSize: fontSize, fontWeight: fontWeight);
  }

  static Widget buildChart(BuildContext context, double height, double width,
      aggregates, bool hasMadeLost) {
    return SizedBox(
      height: height.h,
      width: width.w,
      child: LineChart(
        LineChartData(
          extraLinesData: ExtraLinesData(
            horizontalLines: [
              HorizontalLine(
                y: WebsocketAPI.aggregates[0].close,
                color: Colors.white,
                strokeWidth: 2,
                dashArray: [3, 10],
              ),
            ],
          ),
          lineTouchData: lineTouchData, // Customize touch points
          gridData: gridData,
          titlesData: titlesData, // Customize grid
          borderData: borderData, // Customize border
          lineBarsData: [
            LineChartBarData(
                isCurved: false,
                color: hasMadeLost
                    ? Color.fromARGB(255, 231, 9, 28)
                    : Color.fromARGB(255, 18, 200, 121),
                barWidth: 2.w,
                dotData: FlDotData(show: false),
                spots: loadChartData(aggregates),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: hasMadeLost
                        ? [
                            Color.fromARGB(255, 181, 12, 23).withOpacity(0.5),
                            Color.fromARGB(255, 231, 9, 28).withOpacity(0.1)
                          ]
                        : [
                            Color.fromARGB(255, 16, 113, 71).withOpacity(0.5),
                            Color.fromARGB(255, 39, 201, 131).withOpacity(0.1)
                          ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ))
          ],
        ),
      ),
    );
  }

  static LineTouchData get lineTouchData => LineTouchData(
      enabled: true,
      touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {},
      touchTooltipData: LineTouchTooltipData(
        tooltipBgColor: Color.fromARGB(255, 27, 27, 35),
        tooltipRoundedRadius: 5.sp,
        showOnTopOfTheChartBoxArea: true,
        fitInsideHorizontally: true,
        tooltipMargin: 5.h,
        getTooltipItems: (value) {
          return value
              .map((e) => LineTooltipItem(
                  "${e.y.toStringAsFixed(2)} € \n ${DateFormat('dd.MM.yyyy hh:mm').format(DateTime.fromMillisecondsSinceEpoch(e.x.toInt()))}",
                  TextStyle(color: Colors.white, fontSize: 10.sp)))
              .toList();
        },
      ),
      getTouchedSpotIndicator:
          (LineChartBarData barData, List<int> indicators) {
        return indicators.map(
          (int index) {
            final line = FlLine(
                color: Color.fromARGB(255, 255, 255, 255), strokeWidth: 1);
            return TouchedSpotIndicatorData(
              line,
              FlDotData(show: false),
            );
          },
        ).toList();
      },
      getTouchLineEnd: (_, __) => double.infinity);

  static FlTitlesData get titlesData => FlTitlesData(
        show: false,
      );

  static FlGridData get gridData => FlGridData(
        show: false,
      );

  static FlBorderData get borderData => FlBorderData(show: false);

  static List<FlSpot> loadChartData(aggregates) {
    final List<FlSpot> result = [];

    for (var i = 0; i < aggregates.length; i++) {
      Aggregate aggregate = aggregates[i];
      result.add(
        FlSpot(aggregate.time.toDouble(), aggregate.close),
      );
    }
    return result;
  }

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

  static Widget buildSearchSkeleton() {
    return Padding(
      padding: EdgeInsets.only(left: 15.w, bottom: 10.h),
      child: Shimmer.fromColors(
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 33, 33, 33),
                    shape: BoxShape.circle),
                height: 40.h,
                width: 40.w,
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 21, 21, 21),
                        borderRadius: BorderRadius.circular(5.sp)),
                    height: 15.h,
                    width: 180.w,
                  ),
                  SizedBox(height: 5.h),
                  Container(
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 21, 21, 21),
                        borderRadius: BorderRadius.circular(5.sp)),
                    height: 15.h,
                    width: 65.w,
                  ),
                ],
              )
            ],
          ),
          baseColor: Color.fromARGB(255, 13, 13, 13),
          highlightColor: Color.fromARGB(255, 20, 20, 20)),
    );
  }

  static Widget buildCircularPercentIndicator(
      double radius, double width, double percent, Color color) {
    return CircularPercentIndicator(
      radius: radius.sp,
      lineWidth: width.h,
      percent: percent,
      progressColor: color,
      circularStrokeCap: CircularStrokeCap.round,
    );
  }

  static Widget buildTab() {
    return DefaultTabController(
        length: 5,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            height: 40.5.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TabBar(
                  overlayColor:
                      MaterialStateProperty.all<Color>(Colors.transparent),
                  isScrollable: true,
                  indicator: BoxDecoration(
                      color: Color.fromARGB(255, 67, 11, 165),
                      borderRadius: BorderRadius.circular(7.sp)),
                  unselectedLabelColor: Colors.white,
                  labelColor: Colors.white,
                  tabs: [
                    Padding(
                      padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
                      child: Container(
                        child: BuilderAPI.buildText(
                            text: "1D",
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
                      child: Container(
                        child: BuilderAPI.buildText(
                            text: "1W",
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
                      child: Container(
                        child: BuilderAPI.buildText(
                            text: "1M",
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
                      child: Container(
                        child: BuilderAPI.buildText(
                            text: "1J",
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
                      child: Container(
                        child: BuilderAPI.buildText(
                            text: "MAX",
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                  indicatorSize: TabBarIndicatorSize.tab,
                ),
                // Expanded(
                //   child: TabBarView(
                //     children: [
                //       Text('Person'),
                //       Text('ddd'),
                //       Text('sadad'),
                //       Text('sadad'),
                //       Text('sadad'),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ));
  }

  static Widget buildCircleAvatar(url, radius) {
    return CircleAvatar(
      backgroundImage: NetworkImage(url),
      radius: radius,
    );
  }

  static Widget buildProfileInfo(height, value, text) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: height * 0.01),
          child: BuilderAPI.buildText(
              text: value,
              color: Colors.white,
              fontSize: 17.sp,
              fontWeight: FontWeight.bold),
        ),
        BuilderAPI.buildText(
            text: text,
            color: Colors.grey,
            fontSize: 15.sp,
            fontWeight: FontWeight.normal)
      ],
    );
  }

  static String getMonthName(int month) {
    List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month];
  }
}
