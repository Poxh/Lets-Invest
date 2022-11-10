import 'dart:convert';
import 'dart:developer' as developer;

import 'package:http/http.dart';
import 'package:lets_invest/data/Stock.dart';
import 'package:lets_invest/services/HttpService.dart';

class StockService {
  static Future<List<Stock>> GetUserStocks(String displayName) async {
    List<Stock> stocks = [];
    Response response = await HttpService.GET("/api/Stock", {"DisplayName": displayName});
    var stocksJson = json.decode(response.body) as List;
    stocksJson.forEach((cryptoRes) {
      Stock crypto = Stock(name: cryptoRes["name"], isin: cryptoRes["isin"], price: 0.0, quantity: cryptoRes["quantity"], 
      boughtAT: 1.0); 
      stocks.add(crypto);
    });
    return stocks;
  } 

  static Future<Response> BuyStock(int portfolioId, String name, String isin, double quantity) async {
    return await HttpService.POST("/api/Stock", {
      "portfolioId": portfolioId,
      "name": name,
      "isin": isin,
      "quantity": quantity,
      "boughtAt": "2022-11-08T21:48:49.801Z"
    });
  }
}