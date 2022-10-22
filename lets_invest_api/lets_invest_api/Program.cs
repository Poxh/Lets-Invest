using WebSocketSharp;
using System.Text.Json;
using System.Text.Json.Serialization;

class Programm
{
    static async Task Main(string[] args)
    {
        WebSocket webSocket = new WebSocket("wss://api.traderepublic.com/");
        webSocket.OnOpen += (_, _) =>
        {
            ConnectClient(webSocket);
        };

        webSocket.OnMessage += OnMessage;
        webSocket.Connect();
        await Task.Delay(1000 * 60);
    }

    static void log(string message)
    {
        Console.WriteLine(message);
    } 

    static void ConnectClient(WebSocket webSocket)
    {
        Console.WriteLine("Connected to Trade Republic API");
        webSocket.Send("connect 26 {\"locale\":\"en\",\"platformId\":\"webtrading\",\"platformVersion\":\"opera - 91.0.4516\",\"clientId\":\"app.traderepublic.com\",\"clientVersion\":\"1.16.0\"}");
        SendMessage(webSocket, "sub 29 {\"type\":\"ticker\",\"id\":\"XF000ETH0019.BHS\"}");
    }

    static void OnMessage(Object sender, MessageEventArgs e)
    {
        log(e.Data);
    }

    static void SendMessage(WebSocket webSocket, string message)
    {
        webSocket.Send(message);
    }
}