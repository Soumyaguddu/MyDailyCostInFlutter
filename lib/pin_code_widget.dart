import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:local_auth/local_auth.dart';
import 'package:my_flutter/home.dart';

import 'baseClass.dart';
import 'navigationBar.dart';


class PinCodeWidget extends StatefulWidget {
  const PinCodeWidget({Key? key}) : super(key: key);

  @override
  State<PinCodeWidget> createState() => _PinCodeWidgetState();
}

class _PinCodeWidgetState extends State<PinCodeWidget> {
  String enteredPin = '';
  bool isPinVisible = false;
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  int failedAttempts = 0;
  TextEditingController pinEditingController = TextEditingController();

  Widget numButton(int number) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextButton(
        onPressed: () {
          setState(() {
            if (enteredPin.length < 4) {
              enteredPin += number.toString();
              if(enteredPin.length==4)
                {
                  submitData(enteredPin);
                }

            }
          });
        },
        child: Text(
          number.toString(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  final LocalAuthentication auth = LocalAuthentication();

  Future<void> _authenticate() async {
    bool isAvailable;
    isAvailable = await auth.canCheckBiometrics;
    if (kDebugMode) {
      print(isAvailable);
    }
    if (isAvailable) {
      bool result = await auth.authenticate(
          localizedReason: 'Scan your fingerprint to proceed',
          options: const AuthenticationOptions(
              biometricOnly: true
          )
      );
      if (result) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const NavigationViewPage()));
      }
      else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error Occured'),
              content: const Text('Permission Denied'),
              // Format total price with two decimal places
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      }
    }
    else {
      if (kDebugMode) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error Occurred'),
              content: const Text('No biometric detected'),
              // Format total price with two decimal places
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
        print("No biometric detected");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Enter Your Pin',
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                4,
                    (index) {
                  return Container(
                    margin: const EdgeInsets.all(6.0),
                    width: isPinVisible ? 50 : 50,
                    height: isPinVisible ? 50 : 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      color: index < enteredPin.length
                          ? isPinVisible
                          ? Colors.green
                          : CupertinoColors.activeBlue
                          : CupertinoColors.activeBlue.withOpacity(0.1),
                    ),
                    child: isPinVisible && index < enteredPin.length
                        ? Center(
                      child: Text(
                        enteredPin[index],
                        style: const TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                        : null,
                  );
                },
              ),
            ),

            IconButton(
              onPressed: () {
                setState(() {
                  isPinVisible = !isPinVisible;
                });
              },
              icon: Icon(
                isPinVisible ? Icons.visibility_off : Icons.visibility,
              ),
            ),

            for (var i = 0; i < 3; i++)
              Padding(
                padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    3,
                        (index) => numButton(1 + 3 * i + index),
                  ).toList(),
                ),
              ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const TextButton(onPressed: null, child: SizedBox()),
                  numButton(0),
                  TextButton(
                    onPressed: () {
                      setState(
                            () {
                          if (enteredPin.isNotEmpty) {
                            enteredPin =
                                enteredPin.substring(0, enteredPin.length - 1);
                          }
                        },
                      );
                    },
                    child: const Icon(
                      Icons.backspace,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            TextButton(
              onPressed: () {
                setState(() {
                  enteredPin = '';
                });
              },
              child: const Text(
                'Reset',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),

            IconButton(
              onPressed: _authenticate,
              icon: const Icon(
                Icons.fingerprint,
                size: 80,
                color: Colors.blue


                ,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> submitData(String enteredPin) async {
    final body = {
      "pin": enteredPin
    };


    final response = await BaseClient().post('/verifypinforterminal', body).catchError((err) {});
    if (response == null) return;

    final Map<String, dynamic> responseData = json.decode(response);

// Now you can access the status parameter
    final bool status = responseData['status'];
    debugPrint(status.toString());
    if(status)
      {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const NavigationViewPage()));
      }
    else
    {
      showMessage( responseData['message']);
    }



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



void main() {
  runApp(const MaterialApp(
    home: PinCodeWidget(),
  ));
}
