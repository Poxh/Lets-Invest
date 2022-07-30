import 'package:flutter/material.dart';
import 'package:lets_invest/api/BuilderAPI.dart';
import 'package:lets_invest/api/WebsocketAPI.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({ Key? key }) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView.builder(
        itemCount: WebsocketAPI.stocks.length,
        itemBuilder: (context, index) {
          final stock = WebsocketAPI.stocks[index];
          return BuilderAPI.buildText(
            text: stock.name, color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold);
        }
      ), 
    );
  }
}