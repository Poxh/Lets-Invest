// ignore_for_file: unrelated_type_equality_checks, avoid_print

import 'dart:collection';
import 'dart:convert';
import 'dart:math';
import 'package:lets_invest/data/Aggregate.dart';
import 'package:lets_invest/data/PerformanceData.dart';
import 'package:lets_invest/data/Search.dart';
import 'package:lets_invest/data/Stock.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:developer' as developer;

import '../data/Crypto.dart';

class WebsocketAPI {
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
  static List<Test> stockList = [];
  static List<Test> cryptoList = [];

  static int randomNumber() {
    var rng = Random();
    return rng.nextInt(1000);
  }

  void sendMessageToWebSocket(String message) {
    messageList.add(message);
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
      (data) {
        if (data == "connected") {
          return;
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

          if (isPerformanceRequest(dataJson)) {
            var responseIdentifier = data.toString().split(" ")[0];

            for (var i = 0; i < messageList.length; i++) {
              var message = messageList[i];
              if (message.contains(responseIdentifier)) {
                var replaceMessageEndIndex = message.indexOf(" {");
                var messageReplaced =
                    message.replaceRange(0, replaceMessageEndIndex, "");
                var isinObject =
                    json.decode(messageReplaced)["id"].toString().split(".");
                PerformanceData performance =
                    PerformanceData.fromJson(dataJson);
                var bid = performance.bid;
                var type = isinObject[isinObject.length - 1];
                Test test = Test(isin: isinObject[0], bid: bid, type: type);

                if (type == "LSX") {
                  if (stockList.isEmpty) stockList.add(test);

                  if (!stockList.map((item) => item.isin).contains(test.isin)) {
                    stockList.add(test);
                  }

                  for (var item in stockList) {
                    if (item.isin == test.isin) {
                      if (item.bid["price"] != test.bid["price"]) {
                        stockList.remove(item);
                        stockList.add(test);
                        latestPrice = test.bid["price"];
                      }
                    }
                  }
                } else if (type == "BHS") {
                  if (cryptoList.isEmpty) cryptoList.add(test);

                  if (!cryptoList
                      .map((item) => item.isin)
                      .contains(test.isin)) {
                    cryptoList.add(test);
                  }

                  for (var item in cryptoList) {
                    if (item.isin == test.isin) {
                      if (item.bid["price"] != test.bid["price"]) {
                        cryptoList.remove(item);
                        cryptoList.add(test);
                        latestPrice = test.bid["price"];
                      }
                    }
                  }
                }
              }
            }
          }
        }
      },
      onDone: () => reconnect(),
      onError: (_) => reconnect(),
    );

    sendMessageToWebSocket(
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

  isPerformanceRequest(dataJson) {
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
      List<Crypto> cryptoList = [];
      List<Test> testList = WebsocketAPI.cryptoList;
      Crypto crypto1 = Crypto(
          name: "Bitcoin",
          isin: "XF000BTC0017",
          bid: null,
          quantity: 0.0023,
          boughtAT: 22940);
      Crypto crypto2 = Crypto(
          name: "Ethereum",
          isin: "XF000ETH0019",
          bid: null,
          quantity: 0.0281,
          boughtAT: 1597);
      Crypto crypto3 = Crypto(
          name: "XRP",
          isin: "XF000XRP0018",
          bid: null,
          quantity: 1239,
          boughtAT: 0.21);
      cryptoList.add(crypto1);
      cryptoList.add(crypto2);
      cryptoList.add(crypto3);

      for (var i = 0; i < cryptoList.length; i++) {
        Crypto crypto = cryptoList[i];
        for (var k = 0; k < testList.length; k++) {
          Test test = testList[k];
          if (crypto.isin == test.isin) {
            crypto.bid = test.bid;
          }
        }
      }
      cryptoList.sort((a, b) => b.bid["price"].compareTo(a.bid["price"]));
      return cryptoList;
    });
  }

  static Stream<List<Stock>?> getStockValueStream() async* {
    yield* Stream.periodic(Duration(seconds: 1), (int a) {
      List<Stock> stockList = [];
      List<Test> testList = WebsocketAPI.stockList;
      Stock stock1 = Stock(
          name: "Core MSCI World USD (Acc)",
          isin: "IE00B4L5Y983",
          bid: null,
          quantity: 1.0652,
          boughtAT: 75.08,
          type: "Stocks");
      Stock stock2 = Stock(
          name: "Apple",
          isin: "US0378331005",
          bid: null,
          quantity: 0.0663,
          boughtAT: 150.68,
          type: "Stocks");
      Stock stock3 = Stock(
          name: "Amazon",
          isin: "US0231351067",
          bid: null,
          quantity: 1.36,
          boughtAT: 117.32,
          type: "Stocks");
      stockList.add(stock1);
      stockList.add(stock2);
      stockList.add(stock3);

      for (var i = 0; i < stockList.length; i++) {
        Stock stock = stockList[i];
        for (var k = 0; k < testList.length; k++) {
          Test test = testList[k];
          if (stock.isin == test.isin) {
            stock.bid = test.bid;
          }
        }
      }

      stockList.sort((a, b) => b.bid["price"].compareTo(a.bid["price"]));
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
