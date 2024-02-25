import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Notifications',style: TextStyle(color: Colors.white,fontSize: 18)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const Center(
        child: Text('Notification Page Content',style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
