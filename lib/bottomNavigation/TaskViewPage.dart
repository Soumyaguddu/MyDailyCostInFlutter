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
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
        width: 100.0, // Set the width of the card
        height: 50.0, // Set the height of the card
        child: Card(
          elevation: 5.0, // Card elevation
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Card border radius
          ),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(8.0), // Adjust padding as needed
              child: Center(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(0), // Remove ListTile default padding
                  title: Text(
                    categoryName['title'].toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, // Customize title font weight
                      fontSize: 14.0,
                      color: Colors.indigo// Adjust font size
                    ),
                    textAlign: TextAlign.center,
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      categoryName['text'].toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold, // Customize subtitle font style
                        fontSize: 18.0, // Adjust font size
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onTap: () {
                    // Add your onTap functionality here
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}

