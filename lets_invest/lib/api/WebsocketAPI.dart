import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

class WebsocketAPI {
  final bool _shouldReconnect = true;
  late WebSocketChannel webSocketChannel;
  static List<Stock> stocks = [];

  void _sendMessageToWebSocket(String message) {
    print("Send websocket message: " + message);
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

        var dataJson = json.decode(data.toString().replaceAll("1 A ", ""));
        Stock stock = Stock.fromJSON(dataJson);
        stocks.add(stock);
      },
      onDone: () => reconnect(),
      onError: (_) => reconnect(),
    );

    _sendMessageToWebSocket('connect 22 {"locale":"en","platformId":"webtrading","platformVersion":"chrome - 96.0.4664","clientId":"app.traderepublic.com","clientVersion":"6513"}');
    
    Future.delayed(const Duration(seconds: 2), (){
  
      _sendMessageToWebSocket('sub 1 {"type":"stockDetails","id":"US0378331005","jurisdiction":"DE"}');  
    });
  }
}

class Stock {
  String isin;
  String name;

  static fromJSON(dynamic json) {
    return Stock(isin: json["isin"], name: json["company"]["name"]);
  }
  
  Stock({required this.isin, required this.name});
}