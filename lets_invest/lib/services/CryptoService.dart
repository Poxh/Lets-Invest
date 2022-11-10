import 'dart:convert';
import 'dart:developer' as developer;

import 'package:http/http.dart';
import 'package:lets_invest/data/Crypto.dart';
import 'package:lets_invest/services/HttpService.dart';

class CryptoService {
  static Future<List<Crypto>> GetUserCryptos(String displayName) async {
    List<Crypto> cryptos = [];
    Response response = await HttpService.GET("/api/Crypto", {"DisplayName": displayName});
    var cryptosJson = json.decode(response.body) as List;
    cryptosJson.forEach((cryptoRes) {
      Crypto crypto = Crypto(name: cryptoRes["name"], isin: cryptoRes["isin"], price: 0.0, quantity: cryptoRes["quantity"], 
      boughtAT: 1.0); 
      cryptos.add(crypto);
    });
    return cryptos;
  } 

  static Future<Response> BuyCrypto(int portfolioId, String name, String isin, double quantity) async {
    return await HttpService.POST("/api/Crypto", {
      "portfolioId": portfolioId,
      "name": name,
      "isin": isin,
      "quantity": quantity,
      "boughtAt": DateTime.now()
    });
  }
}