import 'package:flutter/material.dart';
import 'package:sandesh/Custom_item/Custom_widgets.dart';
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
    var size = MediaQuery.of(context).size;
    var h = size.height;
    var w = size.width;

    return Scaffold(
      backgroundColor: color1,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(),
            Column(
              children: [
                Image.asset('assets/images/chat_icon2.png',
                    width: (w * .5), height: (h * .3)),
                SizedBox(
                  height: (h * 0.1),
                ),
                Text("Welcom \n To \n Sandesh",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        height: 1.1,
                        fontSize: (h * 0.05),
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: (h * 0.02),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    welcome_txt,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: (h * 0.026)),
                  ),
                ),
              ],
            ),
            customButton(() {
              Navigator.pushReplacementNamed(context, 'signup');
            }, 'Start',(h * .04),),
          ],
        ),
      ),
    );
  }
}
