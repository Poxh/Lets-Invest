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
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 70.h),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(255, 30, 30, 30)
              ),
              style: TextStyle(
                color: Colors.white
              ),
              onChanged: (value) {
                websocketAPI.sendMessageToWebSocket('sub 868 {"type":"neonSearch","data":{"q":"$value","page":1,"pageSize":50,"filter":[{"key":"type","value":"stock"},{"key":"jurisdiction","value":"DE"}]}}');
                setState(() {});
              },
            ),
          ),

          Container(
            height: 305.h,
            child: ListView.builder(
              itemCount: WebsocketAPI.searchResults.length,
              itemBuilder: (context, index) {
                final searchResult = WebsocketAPI.searchResults[index];
                return buildSearchResult(searchResult);
              }
            ),
          ),
          BuilderAPI.buildText(text: WebsocketAPI.searchResults.length.toString(),
           color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.normal)
        ],
      ),
    );
  }
}

Widget buildSearchResult(Search searchResult) {
  return Padding(
    padding: EdgeInsets.only(left: 25.w, top: 25.h, right: 25.w),
    child: Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 36, 35, 42),
        borderRadius: BorderRadius.circular(10.sp)
      ),
      child: Padding(
        padding: EdgeInsets.all(8.0.sp),
        child: Row(
          children: [
            BuilderAPI.buildStockPicture(searchResult.isin),
            Padding(
              padding: EdgeInsets.only(left: 15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BuilderAPI.buildText(text:searchResult.name, color: Colors.white, fontSize: 17.h, fontWeight: FontWeight.bold),
                  BuilderAPI.buildText(text: searchResult.searchDescription, color: Colors.grey, fontSize: 13.h, fontWeight: FontWeight.bold)
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}