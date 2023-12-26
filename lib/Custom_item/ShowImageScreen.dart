import 'package:flutter/material.dart';

class showImageScreen extends StatelessWidget {
  String url;
  String tag;

  showImageScreen({super.key, required this.tag, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        alignment: Alignment.center,
        child: Hero(
          tag: '$tag',
          child: Image.network(
            url,
          ),
        ),
      ),
    );
  }
}
