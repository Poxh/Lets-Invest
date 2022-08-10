class PerformanceData {

  dynamic bid;
  dynamic ask;
  dynamic last;
  dynamic pre;
  dynamic open;

  PerformanceData({required this.bid, required this.ask, required this.last, required this.pre, required this.open});

  static PerformanceData fromJson(json) {
    var bid = json["bid"];
    var ask = json["ask"];
    var last = json["last"];
    var pre = json["pre"];
    var open = json["open"];
    return PerformanceData(bid: bid, ask: ask, last: last, pre: pre, open: open);
  }
}