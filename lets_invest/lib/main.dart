// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';
import 'package:lets_invest/pages/HomePage.dart';
import 'package:lets_invest/pages/RegisterPage.dart';
import 'package:lets_invest/pages/SignInPage.dart';
import 'package:lottie/lottie.dart';
import 'package:dio/dio.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var dio = Dio();
  await dio.get('https://5b5f-2a02-8108-1540-3d68-e83c-cae5-826d-3652.eu.ngrok.io/api/Crypto?DisplayName=Poxh').then((value) => print(value.data));

  await Firebase.initializeApp();
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
    return ScreenUtilInit(builder: (BuildContext context, Widget? child) {
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: AnimatedSplashScreen(
              splashIconSize: 1000,
              duration: 3000,
              splash: buildSplashScreen(),
              nextScreen: FirebaseAuth.instance.currentUser != null
                  ? HomePage()
                  : SignInPage(),
              splashTransition: SplashTransition.fadeTransition,
              backgroundColor: Color.fromARGB(255, 6, 6, 6)));
    });
  }

  Widget buildSplashScreen() {
    return Container(
      color: Color.fromARGB(255, 6, 6, 6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.insert_chart_outlined_outlined,
                  color: Colors.white, size: 40.sp),
              SizedBox(width: 10.w),
              Text("Lets Invest",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 40.sp))
            ],
          ),
          Lottie.asset('assets/lottiefiles/93344-money-investment.json',
              width: 300),
        ],
      ),
    );
  }
}
