// ignore_for_file: prefer__ructors, prefer__literals_to_create_immutables, unnecessary_cast, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lets_invest/api/AuthenticationAPI.dart';
import 'package:lets_invest/api/BuilderAPI.dart';
import 'package:lets_invest/api/FirebaseAuthenticationAPI.dart';
import 'package:lets_invest/pages/RegisterPage.dart';
import 'package:lets_invest/pages/StockPage.dart';
import 'package:lets_invest/pages/Success.dart';
import 'package:lottie/lottie.dart';

class SignInPage extends StatefulWidget {
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final FirebaseAuthenticationAPI firebaseAuthenticationAPI =
      FirebaseAuthenticationAPI();
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 6, 6, 6),
        body: Column(
          children: [
            BuilderAPI.buildTitle(height),
            SizedBox(height: 45),
            BuilderAPI.buildTextFormField(
                text: "Email", controller: emailController, obscureText: false),
            SizedBox(height: 20),
            BuilderAPI.buildTextFormField(
                text: "Password",
                controller: passwordController,
                obscureText: true),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext buildContext) {
                      return Container(
                          height: 200.h,
                          color: Colors.red,
                          child: Lottie.network(
                              "https://assets1.lottiefiles.com/packages/lf20_jbrw3hcz.json",
                              width: 300,
                              height: 300));
                    });
              },
              child: Padding(
                padding: EdgeInsets.only(right: 25.w, top: 15.h, bottom: 15.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    BuilderAPI.buildText(
                        text: "Forgot Password?",
                        color: Color.fromARGB(255, 67, 11, 165),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.normal)
                  ],
                ),
              ),
            ),
            buildSignUpButton(context),
            Padding(
              padding: EdgeInsets.only(
                  left: 25.w, right: 25.w, top: 15.h, bottom: 15.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BuilderAPI.buildText(
                      text: "Don't have an account?",
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold),
                  GestureDetector(
                    onTap: (() {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    }),
                    child: Padding(
                      padding: EdgeInsets.only(left: 5.w),
                      child: BuilderAPI.buildText(
                          text: "Sign up",
                          color: Color.fromARGB(255, 67, 11, 165),
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }

  Widget buildSignUpButton(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Color.fromARGB(255, 67, 11, 165)),
              minimumSize: MaterialStateProperty.all<Size>(Size.fromHeight(50)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)))),
          onPressed: () async {
            String message = await firebaseAuthenticationAPI.signIn(
                email: emailController.text,
                password: passwordController.text) as String;
            User? user = auth.currentUser;
            if (user != null) {
              if (!message.contains("successfull")) {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext buildContext) {
                      return Container(
                          height: 200.h,
                          color: Color.fromARGB(255, 20, 23, 41),
                          child: Column(
                            children: [
                              Lottie.network(
                                  "https://assets1.lottiefiles.com/packages/lf20_nfojqrzy.json",
                                  width: 110.w,
                                  height: 110.h),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.w, right: 25.w, bottom: 10.h),
                                  child: BuilderAPI.buildText(
                                      text: "Warning",
                                      color: Colors.red,
                                      fontSize: 21.sp,
                                      fontWeight: FontWeight.bold)),
                              Padding(
                                  padding:
                                      EdgeInsets.only(left: 25.w, right: 25.w),
                                  child: BuilderAPI.buildText(
                                      text: message,
                                      color: Colors.white,
                                      fontSize: 21.sp,
                                      fontWeight: FontWeight.bold))
                            ],
                          ));
                    });
              } else {
                AuthenticationAPI authenticationAPI = AuthenticationAPI();
                bool isAuthenticated = await authenticationAPI.authenticate();
                if (isAuthenticated) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => StockPage()),
                  );
                }
              }
            } else {
              if (!message.contains("successfull")) {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext buildContext) {
                      return Container(
                          height: 200.h,
                          color: Color.fromARGB(255, 20, 23, 41),
                          child: Column(
                            children: [
                              Lottie.network(
                                  "https://assets1.lottiefiles.com/packages/lf20_nfojqrzy.json",
                                  width: 110.w,
                                  height: 110.h),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.w, right: 25.w, bottom: 10.h),
                                  child: BuilderAPI.buildText(
                                      text: "Warning",
                                      color: Colors.red,
                                      fontSize: 21.sp,
                                      fontWeight: FontWeight.bold)),
                              Padding(
                                  padding:
                                      EdgeInsets.only(left: 25.w, right: 25.w),
                                  child: BuilderAPI.buildText(
                                      text: message,
                                      color: Colors.white,
                                      fontSize: 21.sp,
                                      fontWeight: FontWeight.bold))
                            ],
                          ));
                    });
              }
            }
          },
          child: Text(
            'Sign in',
            style: TextStyle(fontSize: 20),
          ),
        ));
  }
}
