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
  late Future taskCategoryFuture=Future(() => null);
  @override
  void initState() {
    super.initState();
    taskCategoryFuture = getTaskCategoryData(); // Initialize the future here
  }

  Future<void> _refreshData() async {
    setState(() {
      taskCategoryFuture = getTaskCategoryData(); // Refresh the future here
    });
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

      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: FutureBuilder(
          future: taskCategoryFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            } else {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns
                  crossAxisSpacing: 8.0, // Spacing between columns
                  mainAxisSpacing: 8.0, // Spacing between rows
                ),
                itemCount: categoryList.length,
                itemBuilder: (context, index) {
                  return _buildGridItem(categoryList[index]);
                },
              );
            }
          },
        ),
      ),



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
  Widget _buildGridItem(Map<String, dynamic> categoryName) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          title: Text(
            categoryName['title'].toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(

              fontSize: 15.0,
              color: Colors.black87,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              categoryName['text'].toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          onTap: () {
            // Add your onTap functionality here
          },
        ),
      ),
    );
  }

}

