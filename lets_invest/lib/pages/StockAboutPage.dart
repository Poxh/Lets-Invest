// ignore_for_file: override_on_non_overriding_member, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lets_invest/api/BuilderAPI.dart';
import 'package:lets_invest/api/CalculationAPI.dart';
import 'package:lets_invest/components/ChartFilter.dart';
import 'package:lets_invest/components/Summary.dart';
import 'package:lets_invest/components/TabBarPage.dart';
import 'package:lets_invest/data/Aggregate.dart';
import 'package:lets_invest/data/InstrumentDetail.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:readmore/readmore.dart';

import '../api/WebsocketAPI.dart';
import '../data/StockDetail.dart';

class StockAboutPage extends StatefulWidget {
  const StockAboutPage({Key? key}) : super(key: key);

  @override
  State<StockAboutPage> createState() => _StockAboutPageState();
}

class _StockAboutPageState extends State<StockAboutPage> {
  BuilderAPI builderAPI = BuilderAPI();
  WebsocketAPI websocketAPI = WebsocketAPI();
  Icon icon =
      Icon(Icons.star_border_outlined, color: Colors.white, size: 30.sp);
  bool isFavorite = false;
  bool hasMadeLost = CalculationAPI.hasMadeLost(
      WebsocketAPI.getCurrentStockValue(), WebsocketAPI.getStartStockValue());

  @override
  void initState() {
    websocketAPI.initializeConnection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var tag = WebsocketAPI.latestInstrumentDetail;
    bool isIntlSymbolNull = tag["intlSymbol"] == null;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 14, 14, 14),
        elevation: 0,
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
      body: Container(
        decoration: BoxDecoration(color: Color.fromARGB(255, 14, 14, 14)),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: EdgeInsets.only(bottom: 60.h),
              child: Container(
                height: 400.h,
                child: Column(
                  children: [
                    buildHeader(
                        CalculationAPI.hasMadeLost(
                            WebsocketAPI.getCurrentStockValue(),
                            WebsocketAPI.getStartStockValue()),
                        tag,
                        isIntlSymbolNull),
                    Padding(
                      padding: EdgeInsets.only(top: 40.h, bottom: 30.h),
                      child: SizedBox(
                        height: 215.h,
                        child: StreamBuilder(
                            stream: WebsocketAPI.getChartDataStream(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return BuilderAPI.buildSearchSkeleton();
                              } else if (snapshot.hasData) {
                                List<Aggregate> aggregates =
                                    snapshot.data as List<Aggregate>;
                                return BuilderAPI.buildChart(
                                    context,
                                    100.w,
                                    700.h,
                                    aggregates,
                                    CalculationAPI.hasMadeLost(
                                        WebsocketAPI.getCurrentStockValue(),
                                        WebsocketAPI.getStartStockValue()));
                              } else {
                                return BuilderAPI.buildText(
                                    text: "NOOOOO",
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.normal);
                              }
                            }),
                      ),
                    ),
                    buildIntervalSelection(websocketAPI)
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 25.w, right: 25.w, bottom: 5.h),
              child: BuilderAPI.buildText(
                  text: "Position",
                  color: Colors.white,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold),
            ),
            BuilderAPI.buildPortolioDiversity(
                context,
                StockDetail.fromJson(WebsocketAPI.latestStockDetail).isin,
                "stock",
                tag["exchanges"][0]["nameAtExchange"],
                12.51,
                WebsocketAPI.getCurrentStockValue(),
                146.34,
                websocketAPI),
            buildPortfolioDiversity(2.39),
            Padding(
              padding: EdgeInsets.only(left: 25.w, right: 25.w, bottom: 10.h),
              child: BuilderAPI.buildText(
                  text: "About Company",
                  color: Colors.white,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.only(left: 25.w, right: 25.w, bottom: 50.h),
              child: ReadMoreText(
                StockDetail.fromJson(WebsocketAPI.latestStockDetail)
                    .description,
                trimLines: 2,
                preDataTextStyle: TextStyle(fontWeight: FontWeight.w500),
                style: TextStyle(color: Colors.white),
                colorClickableText: Colors.grey,
                trimMode: TrimMode.Line,
                trimCollapsedText: ' show more',
                trimExpandedText: ' show less',
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget buildPortfolioDiversity(quantity) {
    var allShares = quantity + 2.39 + 4.12 + 12.87 + 6.12;
    var allSharesPercentage = 100;
    var percentage = allSharesPercentage / allShares * quantity / 100;
    return Padding(
        padding:
            EdgeInsets.only(left: 25.w, right: 25.w, bottom: 30.h, top: 5.h),
        child: Row(
          children: [
            CircularPercentIndicator(
                radius: 15.sp,
                percent: percentage,
                progressColor: Color.fromARGB(255, 17, 214, 24),
                backgroundColor: Color.fromARGB(255, 34, 32, 32),
                circularStrokeCap: CircularStrokeCap.round),
            Padding(
                padding: EdgeInsets.only(left: 15.w),
                child: BuilderAPI.buildText(
                    text: "Portfolio diversity " +
                        (percentage * 100).roundToDouble().toString() +
                        " %",
                    color: Colors.grey,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.normal))
          ],
        ));
  }

  Widget buildTag(index) {
    var tag = WebsocketAPI.latestInstrumentDetail["tags"][index];
    return Container(
      width: double.maxFinite,
      height: 5.h,
      decoration: BoxDecoration(color: Color.fromARGB(255, 12, 12, 15)),
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

  Widget buildIntervalSelection(WebsocketAPI websocketAPI) {
    return Padding(
      padding: EdgeInsets.only(top: 15.h),
      child: Padding(
        padding: EdgeInsets.only(left: 25.w, right: 25.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            DefaultTabController(
              length: 6,
              child: TabBar(
                onTap: (value) {
                  switch (value) {
                    case 0:
                      setState(() {
                        print("Updated to 1 day");
                        updateChart("1d");
                      });
                      break;
                    case 1:
                      setState(() {
                        print("Updated to 5 days");
                        updateChart("5d");
                      });
                      break;
                    default:
                  }
                },
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
                          text: "1w",
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
                    child: Container(
                      child: BuilderAPI.buildText(
                          text: "1m",
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
                    child: Container(
                      child: BuilderAPI.buildText(
                          text: "6m",
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
                    child: Container(
                      child: BuilderAPI.buildText(
                          text: "1Y",
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
                    child: Container(
                      child: BuilderAPI.buildText(
                          text: "5Y",
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                indicatorSize: TabBarIndicatorSize.tab,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateChart(timeStamp) {
    String isin = StockDetail.fromJson(WebsocketAPI.latestStockDetail).isin;
    websocketAPI.sendMessageToWebSocket('sub ' +
        WebsocketAPI.randomNumber().toString() +
        ' {"type":"aggregateHistoryLight","range":"$timeStamp","id":"$isin.LSX"}');
  }

  Widget buildIntervalItem(text, onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          height: 30.h,
          decoration: BoxDecoration(
              color: Color.fromARGB(100, 255, 255, 255),
              borderRadius: BorderRadius.circular(13.sp)),
          child: TextButton(
              onPressed: () {},
              child: BuilderAPI.buildText(
                  text: text,
                  color: Colors.white,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold))),
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
                                  fontWeight: FontWeight.normal),
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
                          text: WebsocketAPI.getCurrentStockValue()
                                  .toStringAsFixed(2) +
                              " €",
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold),
                      SizedBox(height: 3.h),
                      Row(
                        children: [
                          FittedBox(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(250, 35, 35, 35),
                                  borderRadius: BorderRadius.circular(4.sp)),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 5.w,
                                    right: 5.w,
                                    top: 3.h,
                                    bottom: 3.h),
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
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
