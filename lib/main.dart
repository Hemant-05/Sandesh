import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sandesh/Screens/HomeScreen.dart';
import 'package:sandesh/Screens/LoginScreen.dart';
import 'package:sandesh/Screens/SignUpScreen.dart';
import 'package:sandesh/Screens/SpalshScreen.dart';
import 'package:sandesh/Screens/WelcomScreen.dart';
import 'package:sandesh/firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Sandesh',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
      initialRoute: 'splash',
      routes: {
        'splash' : (context) => const SplashScreen(),
        'welcome': (context) => const WelcomScreen(),
        'signup' : (context) => const SignUpScreen(),
        'login': (context) => const LogInScreen(),
        'home' : (context) =>  const HomeScreen(),
      },
    );
  }
}
