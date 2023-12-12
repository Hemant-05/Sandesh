import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sandesh/Firebase_Services/Firebase_authMethod.dart';
import 'package:sandesh/Screens/LoginScreen.dart';

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

  void signUpUser(String email,String pass)async{
    FirebaseAuthMethods(
        FirebaseAuth.instance
    ).signUpWithEmail(
        email: email,
        pass: pass,
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
              ),
              Text(
                "Sign Up",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              SizedBox(
                height: 30,
              ),
              TextField(
                controller: emailcon,
                decoration: InputDecoration(
                    label: Text("Enter Email"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12))),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                decoration: InputDecoration(
                    label: Text("Enter name"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12))),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                decoration: InputDecoration(
                    label: Text("Enter Number"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12))),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: passcon,
                decoration: InputDecoration(
                    label: Text("Enter pass"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12))),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(onPressed: (){
                var email = emailcon.value.text;
                var pass = passcon.value.text;
                signUpUser(email,pass);
              }, child: Text("Sign up",)),
              ElevatedButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder:(context) => LogInScreen(), ));
              }, child: Text("Go to login"))
            ],
          ),
        ),
      ),
    );
  }
}
