import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lets_invest/api/BuilderAPI.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class GetStartedPage extends StatefulWidget {
  const GetStartedPage({ Key? key }) : super(key: key);

  @override
  State<GetStartedPage> createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {
  PageController controller = PageController();
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            children: [
              Container(
                color: Colors.blue,
              ),
              Container(
                color: Colors.red,
              ),
              Container(
                color: Colors.yellow,
              )
            ],
          ),

          Container(
            alignment: Alignment(0, 0.75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  child: BuilderAPI.buildText(
                    text: "Skip", color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.bold),
                  onTap: () {
                    controller.animateToPage(
                      2, 
                      duration: Duration(milliseconds: 1000),
                      curve: Curves.easeIn
                    );
                  },
                ),
                SmoothPageIndicator(controller: controller, count: 3),

                onLastPage
                ? GestureDetector(
                  child: BuilderAPI.buildText(
                    text: "Done", color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.bold),
                  onTap: () {
                    controller.nextPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeIn
                    );  
                  },
                )
                : GestureDetector(
                  child: BuilderAPI.buildText(
                    text: "Next", color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.bold),
                  onTap: () {
                    controller.nextPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeIn
                    );  
                  },
                )
              ],
            )
          )
        ],
      )
    );
  }
}