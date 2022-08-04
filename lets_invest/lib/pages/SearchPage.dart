// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lets_invest/api/BuilderAPI.dart';
import 'package:lets_invest/api/WebsocketAPI.dart';
import 'package:lets_invest/pages/StockPage.dart';

import '../data/Search.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({ Key? key }) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  WebsocketAPI websocketAPI = WebsocketAPI();

  @override
  void initState() {
    super.initState();
    websocketAPI.initializeConnection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 6, 6, 6),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 70.h, bottom: 30.h),
              child: Padding(
                padding: EdgeInsets.only(left: 15.w, right: 15.w),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    hintText: "Suche Aktien, ETF's, Cryptos, Derivate Kathegorien",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold
                    ),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0.sp),
                      borderSide: BorderSide.none
                    ),
                    fillColor: Color.fromARGB(255, 30, 30, 30),
                  ),
                  style: TextStyle(
                    color: Colors.white
                  ),
                  onChanged: (value) {
                    websocketAPI.sendMessageToWebSocket('sub 868 {"type":"neonSearch","data":{"q":"$value","page":1,"pageSize":5,"filter":[{"key":"type","value":"stock"},{"key":"jurisdiction","value":"DE"}]}}');
                    Future.delayed(const Duration(milliseconds: 250), (){
                      setState(() {});
                    });
                  },
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(left: 18.w, bottom: 10.h),
              child: BuilderAPI.buildTranslatedText(context, "Aktie", Colors.white, 18.sp, FontWeight.bold)
            ),
            
            Container(
              height: 305.h,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: WebsocketAPI.searchResults.length,
                itemBuilder: (context, index) {
                  final searchResult = WebsocketAPI.searchResults[index];
                  return BuilderAPI.buildSearch(context, searchResult.isin, searchResult.name, 
                  searchResult.searchDescription);
                }
              ),
            ),
          ],
        ),
      )
    );
  }
}