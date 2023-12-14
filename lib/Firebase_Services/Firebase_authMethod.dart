import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sandesh/Custom_item/Custom_widgets.dart';

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

  //FACEBOOK SIGN IN
/*  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken.token);

    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }*/
  Future<void> signInWithFaceBook(BuildContext context) async{
    try{
      final LoginResult loginResult = await FacebookAuth.instance.login();
      final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
      final credential = FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    }catch(e){
      showSnackBar(context, e.toString());
    }
  }
  //GOOGLE SIGN IN
  Future<void> signInWithGoogle (BuildContext context) async{
      try{
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
        // if(googleAuth?.accessToken != null && googleAuth?.idToken != null)
        //   {
            final credential = GoogleAuthProvider.credential(
              idToken : googleAuth?.idToken,
              accessToken: googleAuth?.accessToken,
            );
            UserCredential userCredential =
                await _auth.signInWithCredential(credential);
            final User? user = userCredential.user;
          // }
        showSnackBar(context, 'All Done..');
      }on FirebaseAuthException catch(e){
        showSnackBar(context, e.message!);
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
          showSnackBar(context, 'Loged in');
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