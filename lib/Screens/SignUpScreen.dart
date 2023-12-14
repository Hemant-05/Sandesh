import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sandesh/Custom_item/Custom_widgets.dart';
import 'package:sandesh/Firebase_Services/Firebase_authMethod.dart';
import 'package:sandesh/Screens/LoginScreen.dart';
import 'package:sandesh/utils/Colors.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailcon = TextEditingController();
  TextEditingController passcon = TextEditingController();
  TextEditingController namecon = TextEditingController();
  TextEditingController numbercon = TextEditingController();

  @override
  void dispose() {
    emailcon.dispose();
    passcon.dispose();
    namecon.dispose();
    numbercon.dispose();
    super.dispose();
  }

  void signUpUser(String email, String pass) async {
    FirebaseAuthMethods(FirebaseAuth.instance)
        .signUpWithEmail(email: email, pass: pass, context: context);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var h = size.height;
    var w = size.width;
    return Scaffold(
      backgroundColor: color,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              heightGap(h*0.14),
              cusBoldText("Sign Up", (h * .06)),
              heightGap((h * 0.04)),
              cusTextField("Enter Email", emailcon),
              heightGap(h * .02),
              cusTextField('Enter Name', namecon),
              heightGap(h * .02),
              cusTextField('Enter Password', passcon),
              heightGap(h * .02),
              ElevatedButton(
                  onPressed: () {
                    var email = emailcon.value.text;
                    var pass = passcon.value.text;
                    signUpUser(email, pass);
                  },
                  child: Text(
                    "Sign up",
                  )),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LogInScreen(),
                        ));
                  },
                  child: Text("Go to login"))
            ],
          ),
        ),
      ),
    );
  }
}
