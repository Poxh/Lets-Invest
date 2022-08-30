// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../components/Summary.dart';
import '../api/BuilderAPI.dart';

class TabBarPage extends StatefulWidget {
  const TabBarPage({ Key? key }) : super(key: key);

  @override
  State<TabBarPage> createState() => _TabBarPageState();
}

class _TabBarPageState extends State<TabBarPage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: 240.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TabBar(
              isScrollable: true,
              unselectedLabelColor: Colors.white,
              labelColor: Color.fromARGB(200, 72, 96, 238),
              tabs: [
                Tab(
                  text: 'Summary',
                ),
                Tab(
                  text: 'Dividenden',
                ),
                Tab(
                  text: 'News',
                )
              ],
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  buildOpenCloseInformation(),
                  Text('Person'),
                  Text('sadad'),
                ],
                controller: _tabController,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget buildOpenCloseInformation() {
    return Container(
      color: Color.fromARGB(255, 22, 22, 23),
      child: Summary()
    );
  }
}