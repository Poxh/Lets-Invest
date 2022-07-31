import 'dart:convert';
import 'dart:developer';

import 'package:lets_invest/data/Search.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebsocketAPI {
  final bool _shouldReconnect = true;
  late WebSocketChannel webSocketChannel;
  static List<Search> searchResults = [];

  void sendMessageToWebSocket(String message) {
    print(message);
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
          validateSearch(dataJson);
        }
      },
      onDone: () => reconnect(),
      onError: (_) => reconnect(),
    );

    sendMessageToWebSocket('connect 22 {"locale":"en","platformId":"webtrading","platformVersion":"chrome - 96.0.4664","clientId":"app.traderepublic.com","clientVersion":"6513"}');
  }

  validateSearch(dataJson) {
    if (isResponseSearch(dataJson)) {
      clearSearchList();
      for (var i = 0; i < dataJson["results"].length; i++) {
        Search search = Search.fromJSON(dataJson, i);  
        if(!doesSearchResultExists(search)) {
          searchResults.add(search);
        }
      }
      return;
    }
  }

  isResponseSearch(dataJson) {
    return dataJson["results"] != null;
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

  static clearSearchList() {
    searchResults.clear();
  }
}