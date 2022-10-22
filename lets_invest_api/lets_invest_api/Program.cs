using WebSocketSharp;
using System.Text.Json;
using System.Text.Json.Serialization;
using System.Text.Json.Nodes;
using Newtonsoft.Json.Linq;

class Programm
{
    static int lastID = 0;

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

        string isin = "XF000ETH0019.BHS";
        string messageContent = "{\"type\":\"ticker\",\"id\":\"" + isin + "\"}";
        SendMessage(webSocket, $"sub {getLastID()} {messageContent}");
    }

    static void OnMessage(Object sender, MessageEventArgs e)
    {
        string jsonString = GetDataFromMessage(e.Data);
        if (jsonString == null)  return;
        JObject json = JObject.Parse(jsonString);
        log("Price: " + json.GetValue("last")["price"].ToString());
    }

    static void SendMessage(WebSocket webSocket, string message)
    {
        webSocket.Send(message);
    }

    static int getLastID()
    {
        lastID++;
        return lastID;
    }

    private static string GetDataFromMessage(string messageInput)
    {
        int index = messageInput.IndexOf('{') - 1;
        return index < 0 ? null : messageInput[index..];
    }
}