// ignore_for_file: unrelated_type_equality_checks, avoid_print, prefer_collection_literals

import 'dart:collection';
import 'dart:convert';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lets_invest/data/Aggregate.dart';
import 'package:lets_invest/data/PerformanceData.dart';
import 'package:lets_invest/data/Search.dart';
import 'package:lets_invest/data/Stock.dart';
import 'package:lets_invest/services/CryptoService.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:developer' as developer;

import '../data/Crypto.dart';

class WebsocketAPI {
  int latestID = 0;
  var messages = HashMap(); 

  final bool _shouldReconnect = true;
  late WebSocketChannel webSocketChannel;
  static List<Search> searchResults = [];
  static List<Aggregate> aggregates = [];
  static bool loadedSearch = false;
  static var latestStockDetail;
  static var latestInstrumentDetail;
  static var latestNeonNews = [];
  static double latestPrice = 0.0;

  static List<String> messageList = [];
  static List<Stock> stockList = [];
  static List<Crypto> cryptoList = [];

  int getlatestID() {
    latestID++;
    return latestID;
  }

  void sendMessageToWebSocket(String messageContent) {
    String message = "sub " + getlatestID().toString() + messageContent;
    if(message.contains("ticker")) messages[latestID.toString()] = message.toString();
    developer.log(message);
    webSocketChannel.sink.add(message);
  }

  GetDataFromMessage(String message) {
    int startIndex = message.indexOf('{');
    return startIndex < 0 ? null : message.substring(startIndex, message.length);  
  }

  GetIDFromMessage(String message) {
    return message.substring(0, message.indexOf(' A'));
  }

  GetIsinFromMessage(String message) {
    String jsonString = message.substring(message.indexOf('{'), message.length);
    String isinRaw = json.decode(jsonString)["id"];
    String type = isinRaw.substring(isinRaw.indexOf('.'), isinRaw.length);
    return isinRaw.replaceAll(type, "");
  }

  GetTypeFromMessage(String message) {
    String jsonString = message.substring(message.indexOf('{'), message.length);
    String isinRaw = json.decode(jsonString)["id"];
    return isinRaw.substring(isinRaw.indexOf('.'), isinRaw.length).replaceAll(".", "");  
  }

  void initializeConnection() {
    void reconnect() {
      developer.log('Lost connection to api');
      if (_shouldReconnect) {
        developer.log('Trying to reconnect');
        initializeConnection();
      }
    }

    webSocketChannel = WebSocketChannel.connect(
      Uri.parse("wss://api.traderepublic.com/"),
    );

    webSocketChannel.stream.listen(
      (data) async {
        if (data == "connected") {
          return;
        }

        if (GetDataFromMessage(data.toString()) == null) return;
        dynamic jsonData = json.decode(GetDataFromMessage(data.toString()));

        if(isTickerRequest(jsonData)) {
          String message = messages[GetIDFromMessage(data.toString())];
          String isin = GetIsinFromMessage(message);
          double latestPrice = jsonData["last"]["price"];

          switch (GetTypeFromMessage(message)) {
            case "BHS":
              var cryptoListNew = cryptoList.where((cryptoElement) => cryptoElement.isin == isin);
              List<Crypto> cryptos = await CryptoService.GetUserCryptos(FirebaseAuth.instance.currentUser!.displayName.toString());
              Crypto crypto = cryptos.where((cryptoRes) => cryptoRes.isin == isin).first;
              crypto.price = latestPrice;
              crypto.boughtAT = 100.10;
              if(cryptoListNew.isEmpty) {
                cryptoList.add(crypto);
              } else {
                if(crypto.price.compareTo(cryptoListNew.first.price) < 0 || crypto.price.compareTo(cryptoListNew.first.price) > 0) {
                  cryptoList[cryptoList.indexWhere((element) => element.isin == crypto.isin)] = crypto;     
                }
              }
              break;
            case "LSX":
              var stockListNew = stockList.where((stockElement) => stockElement.isin == isin);
              Stock stock = Stock(name: "", isin: isin, price: latestPrice, quantity: 1.1, boughtAT: 100.10);
              if(stockListNew.isEmpty) {
                stockList.add(stock);
              } else {
                if(stock.price.compareTo(stockListNew.first.price) < 0 || stock.price.compareTo(stockListNew.first.price) > 0) {
                  stockList[stockList.indexWhere((element) => element.isin == stock.isin)] = stock; 
                }
              }
              break;  
            default:
          }
        }

        var replaceIndex1 = data.toString().indexOf(" [");
        if (replaceIndex1 != -1) {
          var jsonResult =
              json.decode(GetDataFromMessage(data.toString()));
          if (jsonResult.length > 0) {
            if (isNeonNewsRequest(jsonResult)) {
              setLatestNeonNews(jsonResult);
            }
          }
        }

        var replaceEndIndex = data.toString().indexOf(" {");
        if (replaceEndIndex != -1) {
          var dataJson =
              json.decode(data.toString().replaceRange(0, replaceEndIndex, ""));
          if (isResponseSearch(dataJson)) {
            addDataToSearchResults(dataJson);
          }

          if (isChartRequest(dataJson)) {
            addDataToaggregates(dataJson);
          }

          if (isStockDetailsRequest(dataJson)) {
            setStockDetailsData(dataJson);
          }

          if (isInstrumentDetailsRequest(dataJson)) {
            setInstrumentDetailsData(dataJson);
          }
        }
      },
      onDone: () => reconnect(),
      onError: (_) => reconnect(),
    );

    webSocketChannel.sink.add(
        'connect 22 {"locale":"en","platformId":"webtrading","platformVersion":"chrome - 96.0.4664","clientId":"app.traderepublic.com","clientVersion":"6513"}');
  }

  isNeonNewsRequest(dataJson) {
    return dataJson[0]["createdAt"] != null &&
        dataJson[0]["provider"] != null &&
        dataJson[0]["headline"] != null &&
        dataJson[0]["summary"] != null;
  }

  setLatestNeonNews(dataJson) {
    latestNeonNews = [];
    latestNeonNews = dataJson;
  }

  isResponseSearch(dataJson) {
    return dataJson["results"] != null;
  }

  addDataToSearchResults(dataJson) {
    clearSearchList();
    for (var i = 0; i < dataJson["results"].length; i++) {
      Search search = Search.fromJSON(dataJson, i);
      if (!doesSearchResultExists(search)) {
        searchResults.add(search);
      }
    }
    searchResults.sort((a, b) {
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
  }

  isChartRequest(dataJson) {
    return dataJson["aggregates"] != null;
  }

  addDataToaggregates(dataJson) {
    clearSearchList();
    aggregates.clear();
    for (var i = 0; i < dataJson["aggregates"].length; i++) {
      var aggregateJson = dataJson["aggregates"][i];
      Aggregate aggregate = Aggregate.fromJson(aggregateJson);
      aggregates.add(aggregate);
    }
  }

  bool doesSearchResultExists(Search search) {
    bool found = false;
    for (var i = 0; i < searchResults.length; i++) {
      Search searchFromList = searchResults[i];
      if (searchFromList.name == search.name) {
        found = true;
      }
    }
    return found;
  }

  isStockDetailsRequest(dataJson) {
    return dataJson["company"] != null && dataJson["analystRating"] != null;
  }

  setStockDetailsData(dataJson) {
    latestStockDetail = dataJson;
  }

  isInstrumentDetailsRequest(dataJson) {
    return dataJson["shortName"] != null;
  }

  setInstrumentDetailsData(dataJson) {
    latestInstrumentDetail = dataJson;
  }

  isTickerRequest(dataJson) {
    return dataJson["bid"] != null &&
        dataJson["bid"] != null &&
        dataJson["last"] != null;
  }

  static clearSearchList() {
    aggregates.clear();
    searchResults.clear();
  }

  static double getStartStockValue() {
    return aggregates.first.close;
  }

  static double getCurrentStockValue() {
    return aggregates.last.close;
  }

  static Stream<double?> getHorizontalValueStream() async* {
    yield* Stream.periodic(Duration(seconds: 1), (int a) {
      return Random().nextDouble() * (146.48 - 146.0) + 146.0;
    });
  }

  static Stream<List<Aggregate>?> getChartDataStream() async* {
    yield* Stream.periodic(Duration(milliseconds: 100), (int a) {
      return aggregates;
    });
  }

  static Stream<List<Crypto>?> getCryptoValueStream() async* {
    yield* Stream.periodic(Duration(seconds: 1), (int a) {
      cryptoList.sort((a, b) => b.price.compareTo(a.price));
      return cryptoList;
    });
  }

  static Stream<List<Stock>?> getStockValueStream() async* {
    yield* Stream.periodic(Duration(seconds: 1), (int a) {
      stockList.sort((a, b) => b.price.compareTo(a.price));
      return stockList;
    });
  }
}

class Test {
  String isin;
  dynamic bid;
  String type;

  Test({required this.isin, required this.bid, required this.type});
}
