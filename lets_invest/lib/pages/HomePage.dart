// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:lets_invest/pages/RegisterPage.dart';
import 'package:lets_invest/pages/StockPage.dart';

import '../api/WebsocketAPI.dart';
import 'SearchPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WebsocketAPI websocketAPI = WebsocketAPI();

  @override
  void initState() {
    super.initState();
    websocketAPI.initializeConnection();
  }

  int _selectedIndex = 0;
  static TextStyle optionStyle =
      TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w600, color: Colors.white);
  static List<Widget> _widgetOptions = <Widget>[
    StockPage(),
    SearchPage(),
    RegisterPage(),
    Text(
      'Profile',
      style: optionStyle,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 6, 6, 6),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 6, 6, 6),
          boxShadow: [
            BoxShadow(
              blurRadius: 20.sp,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.white,
              iconSize: 20.sp,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Color.fromARGB(255, 12, 12, 12),
              tabBorderRadius: 10.sp,
              color: Colors.white,
              tabs: [
                GButton(
                  icon: Icons.dashboard,
                  text: 'Portfolio',
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 10.sp
                  ),
                ),
                GButton(
                  icon: Icons.search,
                  text: 'Search',
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 10.sp
                  ),
                ),
                 GButton(
                  icon: Icons.info,
                  text: 'Infos',
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 10.sp
                  ),
                ),
                GButton(
                  icon: Icons.people_sharp,
                  text: 'Profile',
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 10.sp
                  ),
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}