// ignore_for_file: prefer_conditional_assignment

class StockDetail {
  String isin;
  String name;
  String description;
  String yearFounded;

  StockDetail({required this.isin, required this.name, required this.description, required this.yearFounded});

  static StockDetail fromJson(json) {
    print(json);
    var stockIsin = json["isin"];
    var stockName = json["company"]["name"];
    var stockDescription = json["company"]["description"];
    if(stockDescription == null) {stockDescription = "BRUH";}
    var stockYearFounded = json["company"]["yearFounded"];
    return StockDetail(isin: stockIsin, name: stockName, description: stockDescription, yearFounded: stockYearFounded.toString());
  } 
}