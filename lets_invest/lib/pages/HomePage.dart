// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:lets_invest/api/AuthenticateAPI.dart';
import 'package:lets_invest/main.dart';
import 'package:lets_invest/pages/Success.dart';
import 'package:local_auth/local_auth.dart';
import 'package:slide_to_act/slide_to_act.dart';

class HomePage extends StatelessWidget {
	const HomePage({ Key? key }) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return Scaffold(
      backgroundColor: Color.fromARGB(255, 18, 18, 18),
			body: Container(
				padding: EdgeInsets.all(32),
				child: Center(
					child: Column(
						mainAxisAlignment: MainAxisAlignment.center,
						children: [
							buildAvailability(context),
							SizedBox(height: 24),
              buildAuthenticate(context),
              SizedBox(height: 24),        
              buildSlideButton(context)        
						],
					),
				),
			),
		);
	}

	Widget buildAvailability(BuildContext context) {
		return buildButton(
			text: 'Check Availability', 
			icon: Icons.event_available, 
			onClicked: () async {
				final isDeviceSupported = await AuthenticationAPI.isDeviceSuppoerted();

				showDialog(
					context: context, 
					builder: (context) => AlertDialog(
						backgroundColor: Color.fromARGB(255, 18, 18, 18),
						title: Center(child: Text('Device supported?', style: TextStyle(color: Colors.white))),
						content: Center(
							heightFactor: 1.0,
							child: buildIsDeviceSupported("Is device supported", isDeviceSupported),
						),
					)
				);
			}
		);
	}

	Widget buildAuthenticate(BuildContext context) => buildButton(
        text: 'Authenticate',
        icon: Icons.lock_open,
        onClicked: () async {
			final isAuthenticated = await AuthenticationAPI.authenticate();

			if (isAuthenticated) {
				Navigator.of(context).pushReplacement(
					MaterialPageRoute(builder: (context) => Success()),
				);
			}
        },
    );


	Widget buildIsDeviceSupported(String text, bool isDeviceSupported) {
		return Row(
			crossAxisAlignment: CrossAxisAlignment.center,
			children: [
				isDeviceSupported
				? Row(
					children: [
						Icon(Icons.close, color: Colors.red, size: 36),
						Text("Your device does not support this feature!",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: TextStyle(
                color: Colors.white, 
                fontSize: 15.0
              )
            )
					],
				)
				: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
					children: [
						Icon(Icons.check, color: Colors.green, size: 36),
						SizedBox(width: 10),
						Text("Your device does support this feature!",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: TextStyle(
                color: Colors.white, 
                fontSize: 15.0
              )
            ) 
					],
				)
			],
		);
	}

	Widget buildButton({required String text, required IconData icon, required, required VoidCallback onClicked}) {
		return ElevatedButton.icon(
			style: ElevatedButton.styleFrom(
				minimumSize: Size.fromHeight(50)
			),
			icon: Icon(icon, size: 26),
			label: Text(
				text,
				style: TextStyle(fontSize: 20),
			),
			onPressed: onClicked
		);
	}

  Widget buildSlideButton(BuildContext context) {
    return SlideAction(
      borderRadius: 12,
      elevation: 0,
      outerColor: Colors.white,
      innerColor: Colors.black87,
      sliderButtonIcon: Icon(
        Icons.lock_open_rounded,
        color: Colors.white,
      ),
      text: "Get started",
      textStyle: TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
        fontSize: 23
      ),
      onSubmit: () {
        Navigator.of(context).pushReplacement(
					MaterialPageRoute(builder: (context) => Success()),
				);
      },
    );
  }
}