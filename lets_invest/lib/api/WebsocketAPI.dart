import 'dart:convert';
import 'dart:math';
import 'package:lets_invest/data/Aggregate.dart';
import 'package:lets_invest/data/PerformanceData.dart';
import 'package:lets_invest/data/Search.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:developer' as developer;

class WebsocketAPI {
  final bool _shouldReconnect = true;
  late WebSocketChannel webSocketChannel;
  static List<Search> searchResults = [];
  static List<Aggregate> aggregates = [];
  static bool loadedSearch = false;
  static var latestStockDetail;
  static var latestInstrumentDetail;

  static List<String> messageList = [];
  static List<Test> stockList = [];

  static int randomNumber() {
    var rng = Random();
    return rng.nextInt(1000);
  }

  void sendMessageToWebSocket(String message) {
    messageList.add(message);
    developer.log(message);
    webSocketChannel.sink.add(message);
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
                var isin =
                    json.decode(messageReplaced)["id"].toString().split(".")[0];

                PerformanceData performance =
                    PerformanceData.fromJson(dataJson);
                var bid = performance.bid;
                Test test = Test(isin: isin, bid: bid);
                if (stockList.isEmpty) stockList.add(test);

                if (!stockList.map((item) => item.isin).contains(test.isin)) {
                  stockList.add(test);
                }

                for (var item in stockList) {
                  if (item.isin == test.isin) {
                    if (item.bid["price"] != test.bid["price"]) {
                      stockList.remove(item);
                      stockList.add(test);
                      developer.log(test.isin +
                          " has a price of " +
                          test.bid["price"].toString());
                      developer.log(" ");
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
    if (isChartRequest(dataJson)) {
      clearSearchList();
      for (var i = 0; i < dataJson["aggregates"].length; i++) {
        var aggregateJson = dataJson["aggregates"][i];
        Aggregate aggregate = Aggregate.fromJson(aggregateJson);
        var filteredAggregate =
            aggregates.where((e) => e.time == aggregate.time).length;
        if (filteredAggregate < 1) {
          aggregates.add(aggregate);
        }
      }
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
}

class Test {
  String isin;
  dynamic bid;

  Test({required this.isin, required this.bid});
}
