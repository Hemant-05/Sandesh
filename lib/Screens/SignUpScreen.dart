import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sandesh/Custom_item/Custom_widgets.dart';
import 'package:sandesh/Firebase_Services/Firebase_authMethod.dart';
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

  void signUpUser(String email, String pass, String name) async {
    FirebaseAuthMethods(FirebaseAuth.instance)
        .signInWithEmail(email: email, pass: pass, name: name, context: context)
        .then((user) => {
              if (user != null)
                {
                  Navigator.pushReplacementNamed(context, 'home'),
                  showSnackBar(context, "Sign Up as ${user.email}")
                }
              else
                {
                  showSnackBar(
                      context, "Some error occured when creating account....")
                }
            });
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
              heightGap(h * 0.14),
              cusBoldText("Sign Up", (h * .06)),
              heightGap((h * 0.12)),
              cusTextField("Enter Email", emailcon),
              heightGap(h * .02),
              cusTextField('Enter Name', namecon),
              heightGap(h * .02),
              cusTextField('Enter Password', passcon),
              heightGap(h * .06),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, 'login');
                },
                child: Text(
                  'Already have an account',
                  style: TextStyle(
                      fontSize: h * 0.02,
                      color: Colors.black,
                      decoration: TextDecoration.underline),
                ),
              ),
              heightGap(h * 0.15),
              ElevatedButton(
                onPressed: () {
                  var email = emailcon.value.text;
                  var pass = passcon.value.text;
                  var name = namecon.value.text;
                  signUpUser(email, pass, name);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Sign up",
                    style: TextStyle(fontSize: (h * 0.026)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
