import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'baseClass.dart';
import 'navigationBar.dart';
class AddCostPage extends StatefulWidget {
  const AddCostPage({super.key});

  @override
  State<AddCostPage> createState() => _AddCostPageState();
}

class _AddCostPageState extends State<AddCostPage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController paymentMethodController = TextEditingController();
  TextEditingController paymentBankController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Add Expenses',
            style: TextStyle(color: Colors.white, fontSize: 18)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildDoubleTextField(
                'Title',
                titleController,
                TextInputType.text,

                'Amount',
                amountController,
                TextInputType.number,

              ),
              _buildDoubleDropdownField(
                'Category',
                categoryController,
                ['Mutual fund', 'Stock', 'Other'],
                'Payment Method',
                paymentMethodController,
                ['Online', 'Credit Card', 'Cash'],
              ),
              _buildDoubleDropdownField(
                'Payment Bank',
                paymentBankController,
                ['HDFC', 'ICICI', 'SBI'],
                'Typed',
                typeController,
                ['Debits', 'Credits'],
              ),
              _buildTextField('Description', descriptionController,TextInputType.multiline,TextInputAction.done),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor:Colors.blue,
                  // Set the button background color to match the app bar color
                ),
                child: const Text(
                  'Add Transaction',
                  style: TextStyle(
                    color: Colors.white, // Set text color to white or a contrasting color
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, TextInputType inputType, TextInputAction next) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: inputType,
        textInputAction: next,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }
  Widget _buildDateField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        onTap: () => _selectDate(context, controller),
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Row _buildDoubleDropdownField(
      String label1, TextEditingController controller1, List<String> options1,
      String label2, TextEditingController controller2, List<String> options2) {

    return Row(
      children: [
        Expanded(
          child: _buildDropdownField(label1, controller1, options1),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: _buildDropdownField(label2, controller2, options2),
        ),
      ],
    );
  }



  Widget _buildDropdownField(String label, TextEditingController controller, List<String> options) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: controller.text.isEmpty ? null : controller.text,
        items: options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            controller.text = newValue;
          }
        },
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select $label';
          }
          return null;
        },
      ),
    );
  }
  Row _buildDoubleTextField(
      String label1, TextEditingController controller1, TextInputType inputType1, String label2, TextEditingController controller2, TextInputType inputType2) {
    return Row(
      children: [
        Expanded(
          child: _buildTextField(label1, controller1, inputType1,TextInputAction.next),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: _buildTextField(label2, controller2, inputType2,TextInputAction.next),
        ),
      ],
    );
  }


  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime currentDate = DateTime.now();

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != currentDate) {
      controller.text = DateFormat('dd-MM-yyyy').format(pickedDate);
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Form is valid, handle the submitted data
     /* 'date': _formatDate(dateController.text),*/
      final body = {
        "title": titleController.text,
        'date': "",
        "amount": amountController.text,
        "category": categoryController.text,
        "paymentMethod": paymentMethodController.text,
        "paymentBank": paymentBankController.text,
        "type": typeController.text,
        "description": descriptionController.text,
      };

      final response = await BaseClient().postExpenses('/expenses', body).catchError((err) {});
      if (response == null) return;

      final Map<String, dynamic> responseData = json.decode(response);

// Now you can access the status parameter
      final String message = responseData['message'];

      debugPrint(message.toString());
      showMessage( message.toString());
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const NavigationViewPage()));


    }
  }

  String _formatDate(String inputDate) {
    final parsedDate = DateFormat('dd-MM-yyyy').parseStrict(inputDate);
    final formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
    return formattedDate;
  }
  void showMessage(String message)
  {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.blue, // Background color of the SnackBar
      behavior: SnackBarBehavior.floating, // Adjust behavior as needed
      duration: const Duration(seconds: 5), // Control how long the SnackBar is displayed
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
