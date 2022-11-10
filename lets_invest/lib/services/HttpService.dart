import 'dart:convert';

import 'package:http/http.dart';
import 'package:lets_invest/services/Config.dart';

class HttpService {
  static Future<Response> POST(String endpoint, Map<String, dynamic> body) async {
    return await post(Uri.https(await Config.getValue("apiConnectionURL"), endpoint), body: json.encode(body), headers: 
    {
      "content-type" : "application/json",
      "accept" : "application/json",
    });
  } 

  static Future<Response> GET(String endpoint, Map<String, dynamic> headers) async {
    return await get(Uri.https(await Config.getValue("apiConnectionURL"), endpoint, headers)); 
  }
}