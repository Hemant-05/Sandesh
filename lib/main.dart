import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sandesh/Group_Works/GroupsScreen.dart';
import 'package:sandesh/Screens/HomeScreen.dart';
import 'package:sandesh/Screens/LoginScreen.dart';
import 'package:sandesh/Screens/OtherUserProfile.dart';
import 'package:sandesh/Screens/SignUpScreen.dart';
import 'package:sandesh/Screens/SpalshScreen.dart';
import 'package:sandesh/Screens/UserProfileScreen.dart';
import 'package:sandesh/Screens/WelcomScreen.dart';
import 'package:sandesh/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sandesh',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      routes: {
        'splash': (context) => const SplashScreen(),
        'welcome': (context) => const WelcomScreen(),
        'signup': (context) => const SignUpScreen(),
        'login': (context) => const LogInScreen(),
        'groups': (context) => const GroupsScreen(),
      },
    );
  }
}
