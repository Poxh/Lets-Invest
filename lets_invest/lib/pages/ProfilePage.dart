// ignore_for_file: unnecessary_null_comparison, prefer_const_constructors, unused_local_variable, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lets_invest/api/BuilderAPI.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String url = FirebaseAuth.instance.currentUser!.photoURL.toString() != null
      ? "https://cdn.discordapp.com/attachments/887791666847690764/1032375975402537073/unknown.png"
      : FirebaseAuth.instance.currentUser!.photoURL.toString();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Container(
      width: width,
      color: Color.fromARGB(255, 8, 8, 8),
      height: height,
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.only(top: height * 0.2),
              child: BuilderAPI.buildCircleAvatar(url, height * 0.07)),
          Padding(
            padding: EdgeInsets.only(top: height * 0.03),
            child: BuilderAPI.buildText(
                text: "User129213834",
                color: Colors.white,
                fontSize: 22.sp,
                fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: width * 0.1, right: width * 0.1, top: height * 0.03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BuilderAPI.buildProfileInfo(height, "245", "Followers"),
                BuilderAPI.buildProfileInfo(height, "153", "Following"),
                BuilderAPI.buildProfileInfo(height, "53", "Activities")
              ],
            ),
          )
        ],
      ),
    ));
  }
}
