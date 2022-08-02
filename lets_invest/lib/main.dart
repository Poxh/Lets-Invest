// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lets_invest/pages/HomePage.dart';
import 'package:lottie/lottie.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const String title = 'Biometric Authentication';
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (BuildContext context, Widget? child) { 
        return  MaterialApp(
          debugShowCheckedModeBanner: false,
          home: AnimatedSplashScreen(
            splashIconSize: 1000,
            duration: 3000,
            splash: buildSplashScreen(),
            nextScreen: HomePage(),
            splashTransition: SplashTransition.fadeTransition,
            backgroundColor: Color.fromARGB(255, 6, 6, 6)
          )
        );
      }
    );
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
              Icon(Icons.insert_chart_outlined_outlined, color: Colors.white, size: 40.sp),
              SizedBox(width: 10.w),
              Text("Lets Invest", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 40.sp))
            ],
          ),
          Lottie.asset('assets/lottiefiles/93344-money-investment.json', width: 300),
        ],
      ),
    );
  }
}
