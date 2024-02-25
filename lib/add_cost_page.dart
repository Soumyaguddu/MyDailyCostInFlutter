import 'package:flutter/material.dart';
class AddCostPage extends StatelessWidget {
  const AddCostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Task Entry',
            style: TextStyle(color: Colors.white, fontSize: 18)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const Center(
        child: Text('Task Entry Page ',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),

    );
  }
}
