import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../add_cost_page.dart';
import '../baseClass.dart';
import 'package:intl/intl.dart';

class AllTaskPage extends StatefulWidget {
  const AllTaskPage({super.key});

  @override
  State<AllTaskPage> createState() => _AllTaskPageState();
}

class _AllTaskPageState extends State<AllTaskPage> {

  List categoryList = [];
  late Future taskFuture=Future(() => null);
  @override
  void initState() {
    super.initState();
    taskFuture = getTaskData(); // Initialize the future here
  }

  Future<void> _refreshData() async {
    setState(() {
      taskFuture = getTaskData(); // Refresh the future here
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('All Task',
            style: TextStyle(color: Colors.white, fontSize: 18)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: FutureBuilder(
          future: taskFuture,
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
              return ListView.builder(

                itemCount: categoryList.length,
                itemBuilder: (context, index) {
                  return _buildGridItem(categoryList[index]);
                },
              );
            }
          },
        ),
      ),




    );
  }

  Widget _buildGridItem(Map<String, dynamic> taskName) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRichText(taskName['title']),
                _buildDivider(),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader("Amount"),
                          _buildValue("Amount",taskName['amount'].toString()),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8.0), // Add some spacing between columns
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildHeader("Category"),
                          _buildValue("Category",taskName['category']),
                        ],
                      ),
                    ),
                  ],
                ),
                _buildDivider(),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader("Payment Mode"),
                          _buildValue("Payment Mode",taskName['paymentMethod'].toString()),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8.0), // Add some spacing between columns
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildHeader("Bank"),
                          _buildValue("Bank",taskName['paymentBank']),
                        ],
                      ),
                    ),
                  ],
                ),
                _buildDivider(),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader("Type"),
                          _buildValue("Type",taskName['type'].toString()),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8.0), // Add some spacing between columns
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildHeader("Entry Date"),
                          _buildValue("Entry Date",taskName['date']),
                        ],
                      ),
                    ),
                  ],
                ),


              ],
            ),
            onTap: () {
              // Add your onTap functionality here
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String text) {


    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.normal,
        color: Colors.black87
      ),
    );
  }

  Widget _buildValue(String title,String text) {
    String formattedValue = text.toString();

    if (title == "Entry Date") {
      // Convert "yyyy-MM-ddTHH:mm:ss.SSSZ" to "dd-MM-yyyy"
      final DateTime dateTime = DateTime.parse(text);
      formattedValue = DateFormat('dd-MM-yyyy').format(dateTime);
    }
    return Text(
      formattedValue,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.blueAccent
        // Adjust styling as needed
      ),
    );
  }


  Widget _buildDivider() {
    return const Divider(
      height: 1,
      color: Colors.grey,
    );
  }

  Widget _buildRichText( String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
          children: [
            TextSpan(
              text: value.toUpperCase(),
            ),
          ],
        ),
      ),
    );
  }



  Future<void> getTaskData() async {
    var response = await BaseClient().get('/expenses').catchError((err) {});
    if (response == null) return;
    debugPrint(response);

    final Map<String, dynamic> responseData = json.decode(response);

    // Now you can access the status parameter
    final taskResponse = responseData['response'];
    if (taskResponse != null) {
      setState(() {
        categoryList = taskResponse;
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
