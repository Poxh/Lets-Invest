class Stock {
  String name;
  String isin;
  dynamic bid;
  double quantity;
  double boughtAT;
  String type;
  Stock(
      {required this.name,
      required this.isin,
      required this.bid,
      required this.quantity,
      required this.boughtAT,
      required this.type});
}
