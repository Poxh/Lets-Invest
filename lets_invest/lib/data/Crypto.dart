class Crypto {
  String name;
  String isin;
  dynamic bid;
  double quantity;
  double boughtAT;
  Crypto(
      {required this.name,
      required this.isin,
      required this.bid,
      required this.quantity,
      required this.boughtAT});
}
