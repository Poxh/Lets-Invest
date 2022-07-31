import 'dart:convert';

class Search {
  String isin;
  String name;
  String searchDescription;

  Search({required this.isin, required this.name, required this.searchDescription});

  static fromJSON(dynamic json, index) {
    var type = "";
    var length = json["results"][index]["tags"].length;

    switch (length) {
      case 6:
        type = json["results"][index]["tags"][4]["name"];     
        break;
      case 5:
        type = json["results"][index]["tags"][3]["name"];    
        break; 
      case 4:
        type = json["results"][index]["tags"][2]["name"];    
        break;  
      case 3:
        type = json["results"][index]["tags"][1]["name"];    
        break;   
    }

    return Search(isin: json["results"][index]["isin"], name: json["results"][index]["name"], 
    searchDescription: json["results"][index]["tags"][0]["name"] + ", " + type);
  }
}