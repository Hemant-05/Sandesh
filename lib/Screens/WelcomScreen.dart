import 'package:flutter/material.dart';
import 'package:sandesh/Screens/LoginScreen.dart';
import 'package:sandesh/utils/Colors.dart';
import 'package:sandesh/utils/TextAll.dart';

import 'SignUpScreen.dart';

class WelcomScreen extends StatefulWidget {
  const WelcomScreen({super.key});

  @override
  State<WelcomScreen> createState() => _WelcomScreenState();
}

class _WelcomScreenState extends State<WelcomScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Welcom \n To \n Sandesh",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
          SizedBox(
            height: 20,
          ),
          Text(
            welcome_txt,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22),
          ),
          Align(
            alignment: Alignment.bottomCenter ,
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUpScreen(),
                      ));
                },
                child: Text("Start",
                    style:
                        TextStyle(fontSize: 36, fontWeight: FontWeight.bold))),
          ),
        ],
      )),
    );
  }
}
