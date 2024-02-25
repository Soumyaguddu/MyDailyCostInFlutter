import 'package:flutter/material.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          child: Material(
              child: Center(
                child: Container(
                  child: const Text("Show My App"),
                ),
              )
          )
      ),
    );
  }
}
