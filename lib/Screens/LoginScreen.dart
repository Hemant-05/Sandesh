import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sandesh/Custom_item/Custom_widgets.dart';
import 'package:sandesh/Firebase_Services/Firebase_authMethod.dart';
import 'package:sandesh/utils/Colors.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  User? logInUser(String email, String pass) {
    User? user;
    FirebaseAuthMethods(FirebaseAuth.instance)
        .logInWithEmail(email: email, pass: pass, context: context)
        .then((value) => {
              user = value,
              if (value != null)
                {
                  Navigator.pushNamedAndRemoveUntil(
                      context, 'home', (route) => false),
                  showSnackBar(context, "Account Log in as ${value.email}")
                }
              else
                {showSnackBar(context, "Some error occured when Login....")}
            });
    return user;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var h = size.height;
    return Scaffold(
      backgroundColor: color1,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              heightGap(h * 0.16),
              cusBoldText('Log In',color2, h * .06),
              heightGap(h * .12),
              cusTextField('Enter you Email', emailController),
              heightGap(h * .04),
              cusTextField('Enter you password', passController),
              heightGap(h * .04),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      await FirebaseAuthMethods(FirebaseAuth.instance)
                          .signInWithGoogle(context)
                          .then(
                            (user) => {
                              if (user != null)
                                {
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, 'home', (route) => false),
                                  showSnackBar(
                                      context, "Logged as ${user.email}")
                                }
                              else
                                {showSnackBar(context, "Error !!!!!")}
                            },
                          );
                    },
                    child: Image.asset(
                      'assets/images/icon_gg.png',
                      width: 28,
                      height: 28,
                    ),
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  IconButton(
                    onPressed: () async {
                      print('facebook \n Nothing');
                    },
                    icon: const Icon(
                      Icons.facebook,
                      color: Colors.blue,
                      size: 36,
                    ),
                  ),
                ],
              ),
              heightGap(h * .16),
              customButton(
                () {
                  var email = emailController.text;
                  var pass = passController.text;
                  logInUser(email, pass);
                },
                'Login',
                (h * .04),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
