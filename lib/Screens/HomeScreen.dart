import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sandesh/Firebase_Services/Firebase_authMethod.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home screen'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: InkWell(
          child: Text('LogOut',style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),),
          onTap: ()async{
            FirebaseAuthMethods(FirebaseAuth.instance).logOut(context);
          },
        ),
      ),
    );
  }
}
