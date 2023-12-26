import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sandesh/Custom_item/Custom_widgets.dart';
import 'package:sandesh/Screens/HomeScreen.dart';
import 'package:sandesh/utils/Colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? map;

  @override
  void initState() {
    super.initState();
    if(_auth.currentUser != null) getCurrentUserDetails();
    Future.delayed(
      Duration(seconds: 3),
      () {
        if (_auth.currentUser != null) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> HomeScreen(currentUserData: map!),),);
        } else {
          Navigator.pushReplacementNamed(context, 'welcome');
        }
      },
    );
  }

  void getCurrentUserDetails() {
     _firestore.collection('users').doc('${_auth.currentUser?.uid}').get().then((value){
      map = value.data();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: color1,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            Image.asset('assets/images/chat_icon.png',
                width: (size.width) * .36),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Sandesh',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
