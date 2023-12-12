import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sandesh/Firebase_Services/Firebase_authMethod.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  logInUser(String email,String pass){
    FirebaseAuthMethods(
      FirebaseAuth.instance
    ).logInWithEmail(email: email, pass: pass, context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Log In",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
              SizedBox(height: 20,),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  label: Text("Enter your Email"),
                ),
              ),
              SizedBox(height: 20,),
              TextField(
                controller: passController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)
                    ),
                    label: Text("Enter your password")
                ),
              ),
              SizedBox(height: 20,),
              ElevatedButton(onPressed: (){
                logInUser(emailController.text, passController.text);
              }, child: Text("Log In"))
            ],
          ),
        )
    );
  }
}
