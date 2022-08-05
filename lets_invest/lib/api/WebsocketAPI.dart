import 'dart:convert';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lets_invest/data/ChartPointData.dart';
import 'package:lets_invest/data/Search.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebsocketAPI {
  final bool _shouldReconnect = true;
  late WebSocketChannel webSocketChannel;
  static List<Search> searchResults = [];
  static List<ChartPointData> chartResults = [];
  static var latestStockDetail;
  static var latestInstrumentDetail;

  void sendMessageToWebSocket(String message) {
    initializeDateFormatting();
    webSocketChannel.sink.add(message);
  }

  void initializeConnection() {
    void reconnect() {
      print("Lost connection to api");
      if (_shouldReconnect) {
        print("Trying to reconnect");
        initializeConnection();
      }
    }

    webSocketChannel = WebSocketChannel.connect(
      Uri.parse("wss://api.traderepublic.com/"),
    );

    webSocketChannel.stream.listen((data) {
        if (data == "connected") {
          return; 
        }

        var replaceEndIndex = data.toString().indexOf(" {");
        if(replaceEndIndex != -1) {
          var dataJson = json.decode(data.toString().replaceRange(0, replaceEndIndex, ""));  

          if(isResponseSearch(dataJson)) {addDataToSearchResults(dataJson);}
          if(isChartRequest(dataJson)) {addDataToChartResults(dataJson);}
          if(isStockDetailsRequest(dataJson)) {setStockDetailsData(dataJson);}
          if(isInstrumentDetailsRequest(dataJson)) {setInstrumentDetailsData(dataJson);}
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
    return dataJson["company"] != null;
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