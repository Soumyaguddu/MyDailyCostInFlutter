import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter/add_cost_page.dart';

import '../baseClass.dart';
import '../home.dart';

class TaskViewPage extends StatefulWidget {
  const TaskViewPage({super.key});

  @override
  State<TaskViewPage> createState() => _TaskViewPage();
}

class _TaskViewPage extends State<TaskViewPage> {
  List categoryList = [];

  @override
  void initState() {
    super.initState();
    getTaskCategoryData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Task',
            style: TextStyle(color: Colors.white, fontSize: 18)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
          itemCount: categoryList.length,
          itemBuilder: (context, index) {
            final categoryName = categoryList[index] as Map;

            return ListTile(
                title: Text(categoryName['title'].toString()),
                subtitle: Text(categoryName['text'].toString())
            );
          }),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.blue,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddCostPage()));
          },
          label: const Text(
            "Add Cost",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          )),
    );
  }

  Future<void> getTaskCategoryData() async {
    var response = await BaseClient().get('/expenses').catchError((err) {});
    if (response == null) return;
    debugPrint(response);

    final Map<String, dynamic> responseData = json.decode(response);

// Now you can access the status parameter
    final cardResponse = responseData['cardResponse'];
    if (cardResponse != null) {
      setState(() {
        categoryList = cardResponse;
      });
    } else {
      showMessage("No Data Found");
    }
    debugPrint(responseData.toString());
  }

  void showMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.blue,
      // Background color of the SnackBar
      behavior: SnackBarBehavior.floating,
      // Adjust behavior as needed
      duration: const Duration(seconds: 5),
      // Control how long the SnackBar is displayed
      action: SnackBarAction(
        label: 'Dismiss', // Text for the action button
        onPressed: () {
          // Code to execute when action button is pressed
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );

// Show the customized SnackBar
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
