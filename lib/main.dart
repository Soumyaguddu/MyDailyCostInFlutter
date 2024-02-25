import 'package:flutter/material.dart';
import 'package:my_flutter/pin_code_widget.dart';
import 'package:my_flutter/splash_new_screen.dart';
import 'package:my_flutter/splash_screen.dart';

void main()
{
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.brown),
      darkTheme: ThemeData.light(),
      home:const PinCodeWidget(),
    );
  }
}