import 'dart:convert';
import 'dart:math';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lets_invest/data/ChartPointData.dart';
import 'package:lets_invest/data/Search.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:developer' as developer;

class WebsocketAPI {
  final bool _shouldReconnect = true;
  late WebSocketChannel webSocketChannel;
  static List<Search> searchResults = [];
  static List<ChartPointData> chartResults = [];
  static bool loadedSearch = false;
  static var latestStockDetail;
  static var latestInstrumentDetail;

  static int randomNumber() {
    var rng = Random();
    return rng.nextInt(1000);
  }

  void sendMessageToWebSocket(String message) {
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

    webSocketChannel.stream.listen((data) {
        if (data == "connected") {
          developer.log('connected');
          return; 
        }

        var replaceEndIndex = data.toString().indexOf(" {");
        if(replaceEndIndex != -1) {
          var dataJson = json.decode(data.toString().replaceRange(0, replaceEndIndex, ""));  
          if(isResponseSearch(dataJson)) {addDataToSearchResults(dataJson);}

          if(isChartRequest(dataJson)) {
            addDataToChartResults(dataJson);
            developer.log("Chart request send");
          }

          if(isStockDetailsRequest(dataJson)) {
            developer.log(dataJson.toString());
            setStockDetailsData(dataJson);
            developer.log("Stock details request send");
          } else {
            developer.log("asdad");
          }

          if(isInstrumentDetailsRequest(dataJson)) {
            setInstrumentDetailsData(dataJson);
            developer.log("Instrument request send");
          }
        }
      },
      onDone: () => reconnect(),
      onError: (_) => reconnect(),
    );

    sendMessageToWebSocket('connect 22 {"locale":"en","platformId":"webtrading","platformVersion":"chrome - 96.0.4664","clientId":"app.traderepublic.com","clientVersion":"6513"}');
  }

  isResponseSearch(dataJson) {
    return dataJson["results"] != null;
  }

  addDataToSearchResults(dataJson) {
    clearSearchList();
    for (var i = 0; i < dataJson["results"].length; i++) {
      Search search = Search.fromJSON(dataJson, i);  
      if(!doesSearchResultExists(search)) {
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

  addDataToChartResults(dataJson) {
    if(isChartRequest(dataJson)) {
      clearSearchList();
      for (var i = 0; i < dataJson["aggregates"].length; i++) {
        var chartPointJson = dataJson["aggregates"][i];
        ChartPointData chartPoint = ChartPointData.fromJson(chartPointJson);
        chartResults.add(chartPoint);
      } 
    }
  }

  bool doesSearchResultExists(Search search) {
    bool found = false;
    for (var i = 0; i < searchResults.length; i++) {
      Search searchFromList = searchResults[i];
      if(searchFromList.name == search.name) {
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

  static clearSearchList() {
    chartResults.clear();
    searchResults.clear();
  }
}