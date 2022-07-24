import 'package:web_socket_channel/web_socket_channel.dart';

class WebsocketAPI {
  final bool _shouldReconnect = true;
  late WebSocketChannel webSocketChannel;

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

    webSocketChannel.stream.listen(
      (messageAsDynamic) => print(messageAsDynamic),
      onDone: () => reconnect(),
      onError: (_) => reconnect(),
    );

    _sendMessageToWebSocket('connect 22 {"locale":"en","platformId":"webtrading","platformVersion":"chrome - 96.0.4664","clientId":"app.traderepublic.com","clientVersion":"6513"}');
    
    // Future.delayed(const Duration(seconds: 2), (){
    //   _sendMessageToWebSocket('sub 88 {"type":"ticker","id":"XF000BTC0017.BHS"}');  
    // });
  }
}