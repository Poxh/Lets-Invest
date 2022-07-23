// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:lets_invest/api/AuthenticateAPI.dart';
import 'package:lets_invest/main.dart';
import 'package:lets_invest/pages/Success.dart';
import 'package:local_auth/local_auth.dart';

class HomePage extends StatelessWidget {
	const HomePage({ Key? key }) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: Container(
				padding: EdgeInsets.all(32),
				child: Center(
					child: Column(
						mainAxisAlignment: MainAxisAlignment.center,
						children: [
							buildAvailability(context),
							SizedBox(height: 24),
                			buildAuthenticate(context),
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
				final isAvailable = await AuthenticationAPI.hasBiometrics();
				final biometrics = await AuthenticationAPI.getBiometrics();
				final hasFingerprint = biometrics.contains(BiometricType.fingerprint);

				showDialog(
					context: context, 
					builder: (context) => AlertDialog(
						title: Text('Availability'),
						content: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							mainAxisSize: MainAxisSize.min,
							children: [
								buildBiometricInfo("Biometrics", isAvailable),
								buildBiometricInfo("Fingerprints", hasFingerprint)
							],
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


	Widget buildBiometricInfo(String text, bool hasBiometric) {
		return Container(
			margin: EdgeInsets.symmetric(vertical: 8),
			child: Row(
				children: [
					hasBiometric
						? Icon(Icons.check, color: Colors.green, size: 25)
						: Icon(Icons.close, color: Colors.red, size: 25),
					SizedBox(width: 12),
					Text(text)	
				],
			),
		);
	}

	Widget buildButton({required String text, required IconData icon, required VoidCallback onClicked}) {
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
}