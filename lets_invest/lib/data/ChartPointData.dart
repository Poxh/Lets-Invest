import 'package:intl/intl.dart';

class ChartPointData {
  String isin;
  String name;
  double date;
  double close;

  ChartPointData({required this.isin, required this.name, required this.date, required this.close});

  static ChartPointData fromJson(chartPoint) {
    var date = chartPoint["time"];
    double close = chartPoint["close"];
    return ChartPointData(isin: "TEST!321", name: "TEST", date: date.toDouble(), close: close);
  }
}