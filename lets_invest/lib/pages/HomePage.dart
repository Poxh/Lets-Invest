// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lets_invest/api/BuilderAPI.dart';
import 'package:lets_invest/pages/RegisterPage.dart';
import 'package:lottie/lottie.dart';
import 'package:slide_to_act/slide_to_act.dart';

import '../api/WebsocketAPI.dart';

class HomePage extends StatefulWidget {
	const HomePage({ Key? key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    WebsocketAPI websocketAPI = new WebsocketAPI();
    websocketAPI.initializeConnection();
  }

	@override
	Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
		return Scaffold(
      backgroundColor: Color.fromARGB(255, 6, 6, 6),
			body: Container(
				padding: EdgeInsets.all(32),
				child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Align(
              alignment: FractionalOffset.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10.0, top: height * 0.15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.insert_chart_outlined_outlined, color: Colors.white, size: 40),
                      SizedBox(width: 10),
                      BuilderAPI.buildText(text: "Lets Invest", color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)
                    ],
                  )
              ),
            ),

            Center(
              child: Lottie.asset('assets/lottiefiles/27637-welcome.json', width: 300),
            ),

            BuilderAPI.buildText(
              text: "Welcome to Lets Invest. Slide the icon all over the right to get started", 
              color: Colors.white, 
              fontSize: 21, 
              fontWeight: FontWeight.bold
            ),

            Align(
              alignment: FractionalOffset.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: height * 0.05),
                  child: buildSlideButton(context)
              ),
            ),
          ],
        ),
			),
		);
	}

  Widget buildSlideButton(BuildContext context) {
    return SlideAction(
      borderRadius: 12,
      elevation: 0,
      outerColor: Colors.white,
      innerColor: Color.fromARGB(255, 6, 6, 6),
      sliderButtonIcon: Icon(
        Icons.lock_open_rounded,
        color: Colors.white,
      ),
      text: "Get started",
      textStyle: TextStyle(
        color: Color.fromARGB(255, 6, 6, 6),
        fontWeight: FontWeight.bold,
        fontSize: 23
      ),
      onSubmit: () {
        Navigator.of(context).pushReplacement(
					MaterialPageRoute(builder: (context) => RegisterPage()),
				);
      },
    );
  }
}