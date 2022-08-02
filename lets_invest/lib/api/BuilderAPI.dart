// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'CalculationAPI.dart';

class BuilderAPI {

  static Widget buildText({required String text, required Color color, required double fontSize, required FontWeight fontWeight}) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }   

  static Widget buildTextFormField({required text, required TextEditingController controller, required bool obscureText}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        obscureText: obscureText,
        autofocus: false,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(12)
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
            borderRadius: BorderRadius.circular(12)
          ),
          hintText: text,
          hintStyle: TextStyle(color: Colors.white),
          fillColor: Color.fromARGB(255, 15, 15, 15),
          filled: true
        ),
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
              Icon(Icons.insert_chart_outlined_outlined, color: Colors.white, size: 40),
              SizedBox(width: 10),
              BuilderAPI.buildText(text: "Lets Invest", color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)
            ],
          )
      ),
    );
  } 

  static Widget buildStockPicture(isin) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 21, 21, 21),
        borderRadius: BorderRadius.circular(10.sp)
      ),
      height: 45.h,
      width: 45.w,
      child: Image.network('https://assets.traderepublic.com/img/logos/' + isin + '/dark.png', errorBuilder: (context, error, stackTrace) {
        return Icon(Icons.question_mark, color: Colors.white, size: 15.sp); 
      })
    );
  }

  static Widget buildStock(BuildContext context, isin, stockName, quantity, currentPrice, boughtPrice) {
    return Padding(
      padding: EdgeInsets.only(left: 10.w, right: 10.w),
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
                            child: BuilderAPI.buildText(text: quantity, color: Colors.grey, fontSize: 13.sp, fontWeight: FontWeight.bold),
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
                    BuilderAPI.buildText(
                      text: currentPrice.toStringAsFixed(2) + "€", 
                      color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.bold
                    ),
                    SizedBox(height: 3.h),  
                    Row(
                      children: [
                        Icon(
                          hasMadeLost(currentPrice, boughtPrice) 
                          ? Icons.arrow_downward
                          : Icons.arrow_upward,
                          color: hasMadeLost(currentPrice, boughtPrice)
                          ? Colors.red
                          : Colors.green,
                          size: 11.sp,
                        ),
                        SizedBox(width: 3.w),
                        BuilderAPI.buildText(
                          text: CalculationAPI.calculateProfitLostInEUR(currentPrice, boughtPrice).toStringAsFixed(2)
                          .replaceAll("-", "") + "€ • " + CalculationAPI.calculateProfitLostInPercentage
                          (currentPrice, boughtPrice).toStringAsFixed(2).replaceAll("-", "") + " %", 
                          color: hasMadeLost(currentPrice, boughtPrice) ? Colors.red : Colors.green, 
                          fontSize: 11.sp, fontWeight: FontWeight.bold), 
                      ],
                    )
                  ],
                )
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget buildSearch(BuildContext context, isin, stockName, description) {
    return Padding(
      padding: EdgeInsets.only(left: 10.w, right: 10.w),
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
                            child: BuilderAPI.buildText(text: description, color: Colors.grey, fontSize: 13.sp, fontWeight: FontWeight.bold),
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

  static bool hasMadeLost(currentPrice, boughtPrice) {
    return CalculationAPI.calculateProfitLostInEUR(currentPrice, boughtPrice).toString().contains("-");  
  }

  static double randomValue() {
    var random = Random();
    int randomInt = random.nextInt(100);
    return random.nextDouble() * randomInt;
  }
}
