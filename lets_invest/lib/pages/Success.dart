// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class Success extends StatelessWidget {
	const Success({ Key? key }) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: Container(
				child: Row(
					children: [
						Icon(Icons.check, color: Colors.green, size: 26),
						SizedBox(width: 10),
						Text("Successfully authenticated!")
					],
				),
			),	
		);
	}
}