// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChartPage extends StatefulWidget {

  static String portfolioValue = "";

  static getPortfolioValue() {
    return portfolioValue;
  }

  final Color lineColor;
  // List of cartesian coordinates
  final List<FlSpot>? data;

  const ChartPage({required this.lineColor, required this.data});

  @override
  State<ChartPage> createState() => _ChartPageState();

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

class _ChartPageState extends State<ChartPage> {
  String ammount = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.h,
      child: LineChart(
        lineChartData,
        swapAnimationDuration: const Duration(milliseconds: 250),
      ),
    );
  }

  LineChartData get lineChartData => LineChartData(
        lineTouchData: lineTouchData, // Customize touch points
        gridData: gridData,
        
        titlesData: titlesData, // Customize grid
        borderData: borderData, // Customize border
        lineBarsData: [
          lineChartBarData,
        ],
      );

  LineTouchData get lineTouchData => LineTouchData(
        handleBuiltInTouches: true,
        touchCallback: (FlTouchEvent touchResponse, LineTouchResponse? lineTouchResponse) {
          final value = lineTouchResponse?.lineBarSpots![0].y;
          setState(() {
            ChartPage.portfolioValue = "LOL";
          });
        },
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Color.fromARGB(255, 26, 26, 26).withOpacity(0.8),
          getTooltipItems: (value) {
            return value
                .map((e) => LineTooltipItem(
                    "${e.y.toStringAsFixed(2)} € \n 2 Jan, 12:42",
                    TextStyle(color: Colors.white, fontSize: 10.sp)))
                .toList();
          },
        ),
      );

  FlTitlesData get titlesData => FlTitlesData(show: false);

  FlGridData get gridData => FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(show: false);

  LineChartBarData get lineChartBarData => LineChartBarData(
    isCurved: true,
    color: this.widget.lineColor,
    barWidth: 2,
    dotData: FlDotData(show: false),
    spots: widget.data ?? ChartPage.generateSampleData(),
    belowBarData: BarAreaData(
      show: true,
      color: Colors.green.withOpacity(0.1),
      spotsLine: BarAreaSpotsLine(
        flLineStyle: FlLine(
          color: Colors.grey,
          strokeWidth: 2.0
        )
      )
    ),
  );
}
