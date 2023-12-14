import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sandesh/utils/Colors.dart';
import 'package:sandesh/utils/TextAll.dart';
import 'SignUpScreen.dart';

class WelcomScreen extends StatefulWidget{
  const WelcomScreen({super.key});

  @override
  State<WelcomScreen> createState() => _WelcomScreenState();
}

class _WelcomScreenState extends State<WelcomScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var h = size.height;
    var w = size.width;

    return Scaffold(
      backgroundColor: color,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: (h * 0.05),),
            Image.asset('assets/images/chat_icon2.png',width: (w * .55),height: (h * .3)),
            SizedBox(height: (h * 0.03),),
            Text("Welcom \n To \n Sandesh",
                textAlign: TextAlign.center,
                style: TextStyle(height: 1.1,fontSize: (h * 0.05), fontWeight: FontWeight.bold)),
            SizedBox(
              height: (h * 0.02),
            ),
            Text(
              welcome_txt,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: (h * 0.026)),
            ),
            SizedBox(height: (h * 0.16),),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUpScreen(),
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    "Start",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 26,
                        fontWeight: FontWeight.bold),
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }
}
