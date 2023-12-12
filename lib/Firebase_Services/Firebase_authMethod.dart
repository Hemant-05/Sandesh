import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sandesh/Custom_item/Cus_snackBar.dart';

class FirebaseAuthMethods{
  final FirebaseAuth _auth;
  FirebaseAuthMethods(this._auth);

  //EMAIL SIGN UP
  Future<void> signUpWithEmail(
      {
        required String email,
        required String pass,
        required BuildContext context
      }
      )async{
    try{
      await _auth.createUserWithEmailAndPassword(email: email, password: pass);
      await sendEmailVerification(context);
      showSnackBar(context, "Done");
    }on FirebaseAuthException catch(e){
       showSnackBar(context, "Some Error Accured !");
    }
  }

  //LOGIN
  Future<void> logInWithEmail(
  {
    required String email,
    required String pass,
    required BuildContext context
  })async{
     try{
      await _auth.signInWithEmailAndPassword(email: email, password: pass);
          if(!_auth.currentUser!.emailVerified){
            await sendEmailVerification(context);
          }
     }on FirebaseAuthException catch(e){
       showSnackBar(context, e.message!);
     }
  }

  // EMAIL VERIFICATION
  Future<void> sendEmailVerification(BuildContext context) async{
          try{
            await _auth.currentUser!.sendEmailVerification();
            showSnackBar(context, "Email Verification sent !");
          }on FirebaseAuthException catch(e){
            showSnackBar(context, e.message!);
          }
  }
}