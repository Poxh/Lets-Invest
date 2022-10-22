using WebSocketSharp;
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
        SendMessage(webSocket, $"sub 1 {messageContent}");

        string isin2 = "XF000BTC0017.BHS";
        string messageContent2 = "{\"type\":\"ticker\",\"id\":\"" + isin2 + "\"}";
        SendMessage(webSocket, $"sub 2 {messageContent2}");
    }

    static void OnMessage(Object sender, MessageEventArgs e)
    {
        int ID = GetIDFromMessage(e.Data);
        string jsonString = GetDataFromMessage(e.Data);
        if (jsonString == null)  return;
        JObject json = JObject.Parse(jsonString);
        log("Price: " + json.GetValue("last")["price"].ToString() + " | ID: " + ID);
    }

    static void SendMessage(WebSocket webSocket, string message)
    {
        lastMessage = message;
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

    static private int GetIDFromMessage(string message)
    {
        try
        {
            return int.Parse(message[..message.IndexOf(' ')]);
        }
        catch (Exception e)
        {
            log(e.Message);
            return -1;
        }
    }
}