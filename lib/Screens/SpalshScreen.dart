import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1),(){
      if(_auth.currentUser != null){
        Navigator.pushReplacementNamed(context, 'home');
      }
      else
      {
        Navigator.pushNamed(context, 'signup');
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/chat_icon.png',width: 200,height: 200,),
      ),
    );
  }
}
