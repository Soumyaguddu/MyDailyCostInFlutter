import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_flutter/finger_print_auth.dart';
import 'package:my_flutter/home.dart';
import 'package:my_flutter/pin_code_widget.dart';

class SplashNewScreen extends StatelessWidget {
  const SplashNewScreen({super.key});

  get splash => null;

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash:Icons.map_sharp,
      duration: 4000,
      splashTransition: SplashTransition.fadeTransition ,
      nextScreen: const PinCodeWidget(),
      splashIconSize: 200,
      backgroundColor: Colors.white,

    );
  }
}
