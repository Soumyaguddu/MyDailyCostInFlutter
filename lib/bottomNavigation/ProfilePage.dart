import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Profile',style: TextStyle(color: Colors.white,fontSize: 18)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const Center(
        child: Text('Profile Page Content',style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
