import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  UserProfileScreen({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Profile Screen \n ${_auth.currentUser!.email}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 40),),
    );
  }
}
