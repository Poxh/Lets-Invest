// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lets_invest/pages/HomePage.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const String title = 'Biometric Authentication';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        splashIconSize: 150,
        duration: 3000,
        splash: buildSplashScreen(),
        // splash: Image.network("https://i.ibb.co/JcdfHkg/lets-invest-logo-removebg-preview.png"),
        nextScreen: HomePage(),
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: Color.fromARGB(255, 6, 6, 6)
      )
    );
  }

  Widget buildSplashScreen() {
    return Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.insert_chart_outlined_outlined, color: Colors.white, size: 40),
              SizedBox(width: 10),
              Text("Lets Invest", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 40))
            ],
          ),
          SizedBox(height: 20),
          CircularProgressIndicator(
            color: Colors.white,
          )
        ],
      ),
    );
  }
}
