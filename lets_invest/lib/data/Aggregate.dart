class Aggregate {
  int time;
  double open;
  double high;
  double low;
  double close;
  int volume;

  Aggregate(
      {required this.time,
      required this.open,
      required this.high,
      required this.low,
      required this.close,
      required this.volume});

  static Aggregate fromJson(aggregateJson) {
    var time = aggregateJson["time"];
    double open = aggregateJson["open"];
    double high = aggregateJson["high"];
    double low = aggregateJson["low"];
    double close = aggregateJson["close"];
    int volume = aggregateJson["volume"];

    return Aggregate(
        time: time,
        open: open,
        high: high,
        low: low,
        close: close,
        volume: volume);
  }
}
