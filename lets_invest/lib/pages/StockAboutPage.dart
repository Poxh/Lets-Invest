// ignore_for_file: override_on_non_overriding_member, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lets_invest/api/BuilderAPI.dart';
import 'package:lets_invest/data/InstrumentDetail.dart';

import '../api/WebsocketAPI.dart';
import '../data/StockDetail.dart';

class StockAboutPage extends StatefulWidget {
  const StockAboutPage({ Key? key }) : super(key: key);

  @override
  State<StockAboutPage> createState() => _StockAboutPageState();
}

class _StockAboutPageState extends State<StockAboutPage> {
  BuilderAPI builderAPI = BuilderAPI();
  Icon icon = Icon(Icons.star_border_outlined, color: Colors.white, size: 20.sp);
  bool isFavorite = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 8, 8, 15),
        elevation: 0,
        actions: [
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            iconSize: 1.sp,
            splashRadius: 5.sp,
            onPressed: () {
              setState(() {
                if(isFavorite) {
                  isFavorite = false;
                  icon = Icon(Icons.star_border_outlined, color: Colors.white, size: 20.sp);
                } else {
                  isFavorite = true;
                  icon = Icon(Icons.star, color: Colors.yellow, size: 20.sp);
                }
              });
            }, icon: icon
          ),

          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            iconSize: 5.sp,
            splashRadius: 5.sp,
            onPressed: () {}, 
            icon: Icon(Icons.more_horiz, color: Colors.white, size: 20.sp)
          ),

          SizedBox(width: 25.w)
        ],
      ),
      backgroundColor: Color.fromARGB(255, 8, 8, 15),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildStockTitle(),
            buildIntervalSelection(),
            Padding(
              padding: EdgeInsets.only(top: 40.h, bottom: 40.h),
              child: Container(
                height: 300.h,
                child: builderAPI.buildChart(context),
              ),
            ),
          
            IntrinsicHeight(
              child: Padding(
                padding: EdgeInsets.only(left: 30.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildChartFooterInformation(
                          "Name", InstrumentDetail.fromJson(WebsocketAPI.latestInstrumentDetail).name
                        ),
                        buildChartFooterInformation(
                          "Isin", InstrumentDetail.fromJson(WebsocketAPI.latestInstrumentDetail).isin
                        ),
                        buildChartFooterInformation(
                          "Wkn", InstrumentDetail.fromJson(WebsocketAPI.latestInstrumentDetail).wkn
                        )
                      ],
                    ),
                    VerticalDivider(
                      color: Colors.grey,
                    ),
                    SizedBox(width: 15.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildChartFooterInformation(
                          "Short", InstrumentDetail.fromJson(WebsocketAPI.latestInstrumentDetail).shortName
                        ),
                        buildChartFooterInformation(
                          "Symbol", InstrumentDetail.fromJson(WebsocketAPI.latestInstrumentDetail).homeSymbol
                        ),
                        buildChartFooterInformation(
                          "Intl", InstrumentDetail.fromJson(WebsocketAPI.latestInstrumentDetail).intlSymbol
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ]
        ),
      ),
    );
  }

  Widget buildIntervalSelection() {
    return Padding(
      padding: EdgeInsets.only(top: 30.h),
      child: Padding(
        padding: EdgeInsets.only(left: 25.w, right: 25.w),
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 11, 12, 21),
            borderRadius: BorderRadius.circular(10.sp)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                child: TextButton(
                  onPressed: () {}, 
                  child: BuilderAPI.buildText(
                    text: "1T", color: Colors.white, 
                    fontSize: 13.sp, fontWeight: FontWeight.bold
                  )
                )
              ),

              Container(
                child: TextButton(
                  onPressed: () {}, 
                  child: BuilderAPI.buildText(
                    text: "1W", color: Colors.white, 
                    fontSize: 13.sp, fontWeight: FontWeight.bold
                  )
                )
              ),

              Container(
                child: TextButton(
                  onPressed: () {}, 
                  child: BuilderAPI.buildText(
                    text: "1M", color: Colors.white, 
                    fontSize: 13.sp, fontWeight: FontWeight.bold
                  )
                )
              ),

              Container(
                child: TextButton(
                  onPressed: () {}, 
                  child: BuilderAPI.buildText(
                    text: "1J", color: Colors.white, 
                    fontSize: 13.sp, fontWeight: FontWeight.bold
                  )
                )
              ),

              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 9, 9, 44),
                  borderRadius: BorderRadius.circular(10.sp)
                ),
                child: TextButton(
                  onPressed: () {}, 
                  child: BuilderAPI.buildText(
                    text: "MAX", color: Colors.white, 
                    fontSize: 13.sp, fontWeight: FontWeight.bold
                  )
                )
              ),

              SizedBox(width: 0.w)
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStockTitle() {
    return Padding(
      padding: EdgeInsets.only(left: 25.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              BuilderAPI.buildStockPicture(StockDetail.fromJson(WebsocketAPI.latestStockDetail).isin, 30, 30),
              SizedBox(width: 10.w),
              BuilderAPI.buildText(text: StockDetail.fromJson(WebsocketAPI.latestStockDetail).name, 
              color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.bold),
            ],
          ),
          SizedBox(height: 5.h),
          Row(
            children: [
              BuilderAPI.buildText(text: "276,50€", 
              color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.normal),
              SizedBox(width: 5.w),
              Icon(Icons.arrow_upward, color: Colors.green, size: 12.sp),
              BuilderAPI.buildText(text: "215,32€ (351,96%)", 
              color: Colors.green, fontSize: 12.sp, fontWeight: FontWeight.normal),
              SizedBox(width: 5.w),
              BuilderAPI.buildText(text: "Seit Start", 
              color: Colors.grey, fontSize: 12.sp, fontWeight: FontWeight.normal),
            ],
          )
        ],
      ),
    );
  }

  Widget buildBuyButton() {
    return Padding(
      padding: EdgeInsets.only(left: 25.w, right: 25.w),
      child: ElevatedButton(
        onPressed: () {}, 
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
          Colors.green),
          minimumSize: MaterialStateProperty.all<Size>(Size.fromHeight(50)),
        ),
        child: 
        BuilderAPI.buildText(
          text: "Kaufen", color: Colors.white, 
          fontSize: 13.sp, fontWeight: FontWeight.bold
        )
      ),
    );
  }

  Widget buildChartFooterInformation(title, value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          BuilderAPI.buildText(
            text: title, color: Colors.grey, 
            fontSize: 13.sp, fontWeight: FontWeight.normal
          ),
          SizedBox(width: 10.w),
          SizedBox(
            width: 90.w,
            child: BuilderAPI.buildText(
              text: value, color: Colors.white, 
              fontSize: 13.sp, fontWeight: FontWeight.normal
            ),
          )
        ],
      ),
    );
  }
}

