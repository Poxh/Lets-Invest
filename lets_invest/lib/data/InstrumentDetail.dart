class InstrumentDetail {
  String name;
  String isin;
  String wkn;
  String shortName;
  String homeSymbol;
  String intlSymbol;

  InstrumentDetail({required this.name, required this.isin, required this.wkn, required this.shortName, required this.homeSymbol, required this.intlSymbol});

  static InstrumentDetail fromJson(json) {
    var name = json["name"];
    var isin = json["isin"];
    var wkn = json["wkn"];
    var shortName = json["shortName"];
    var homeSymbol = json["homeSymbol"];
    var intlSymbol = json["intlSymbol"];
    if(intlSymbol == null) {intlSymbol = "NO DATA";}
    return InstrumentDetail(name: name, isin: isin, wkn: wkn, shortName: shortName, homeSymbol: homeSymbol, intlSymbol: intlSymbol);
  } 
}