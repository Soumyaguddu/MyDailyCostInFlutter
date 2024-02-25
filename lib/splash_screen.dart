import 'dart:async';

import 'package:flutter/material.dart';

import 'home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  void initState() {

    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: const Center(
            child: Text(
          "Location App",
          style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700,color: Colors.black),
        )),
      ),
    );
  }
}
