import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sandesh/Custom_item/Custom_widgets.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth;

  FirebaseAuthMethods(this._auth);

  //EMAIL SIGN UP
  Future<User?> signUpWithEmail(
      {required String email,
      required String pass,
      required BuildContext context}) async {
    User? user;
    try {
      user = (await _auth.createUserWithEmailAndPassword(email: email, password: pass)).user;
      if(user != null){
        await sendEmailVerification(context);
        showSnackBar(context, "Done");
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, "Some Error Accured !");
    }
    return user;
  }

  //GOOGLE SIGN IN
  Future<User?> signInWithGoogle(BuildContext context) async {
    User? user;
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      // if(googleAuth?.accessToken != null && googleAuth?.idToken != null)
      //   {
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth?.idToken,
        accessToken: googleAuth?.accessToken,
      );
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      user = userCredential.user;
      // }
      showSnackBar(context, 'All Done..');
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
    return user;
  }

  //LOGIN
  Future<User?> logInWithEmail(
      {required String email,
      required String pass,
      required BuildContext context}) async {
    User? user;
    try {
      user = (await _auth.signInWithEmailAndPassword(email: email, password: pass)).user;
      if(user != null){
        showSnackBar(context, 'Me Loged in');
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
    return user;
  }

  // EMAIL VERIFICATION
  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      await _auth.currentUser!.sendEmailVerification();
      showSnackBar(context, "Email Verification sent !");
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }
}
