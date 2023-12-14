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

  logInUser(String email, String pass) {
    FirebaseAuthMethods(FirebaseAuth.instance)
        .logInWithEmail(email: email, pass: pass, context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 150,
              ),
              Text(
                "Log In",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  label: Text("Enter your Email"),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: passController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    label: Text("Enter your password")),
              ),
              heightGap(20),
              ElevatedButton(
                  onPressed: () {
                    logInUser(emailController.text, passController.text);
                  },
                  child: Text("Log In")),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      await FirebaseAuthMethods(FirebaseAuth.instance)
                          .signInWithGoogle(context);
                    },
                    child: Image.asset('assets/images/icon_gg.png',width: 28,height: 28,),
                  ),
                  SizedBox(width: 40,),
                  IconButton(
                    onPressed: () async {
                      await FirebaseAuthMethods(FirebaseAuth.instance)
                      .signInWithFaceBook(context);
                    },
                    icon: Icon(
                      Icons.facebook,
                      color: Colors.blue,
                      size: 36,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
