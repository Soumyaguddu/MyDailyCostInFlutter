import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

import 'home.dart';



class FingerPrintPage extends StatefulWidget {
  const FingerPrintPage({super.key});

  @override
  State<FingerPrintPage> createState() => _HomePageState();
}

class _HomePageState extends State<FingerPrintPage> {

  final LocalAuthentication auth = LocalAuthentication();

  checkAuth() async{
    bool isAvailable;
    isAvailable = await auth.canCheckBiometrics;
    print(isAvailable);
    if(isAvailable)
    {
      bool result = await auth.authenticate(
          localizedReason: 'Scan your fingerprint to proceed',
          options: const AuthenticationOptions(
              biometricOnly: true
          )
      );
      if(result)
      {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const HomePage()));

      }
      else
      {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error Occured'),
              content: Text('Permission Denied'), // Format total price with two decimal places
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                ),
              ],
            );
          },
        );
      }
    }
    else
    {
      print("No biometric detected");
    }

  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        // backgroundColor: Color(0xFF0B0B45),
        backgroundColor: CupertinoColors.activeBlue,
        body: Center(
          child: Column(

            children: [
              const SizedBox(
                height: 150,
              ),
              const Text('Login',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 45,
                    fontWeight: FontWeight.w700
                ),),
              const SizedBox(
                height: 60,
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(30, 0, 10, 0),
                child:
                Text('Use your fingerprint to authenticate yourself ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,

                  ),),
              ),

              const Text('before using the app ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,

                ),),
              const SizedBox(
                height: 100,
              ),
              GestureDetector(
                onTap: checkAuth,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60),
                      border: Border.all(
                        color: Colors.green,
                        width: 3,

                      )
                  ),
                  child: const Icon(
                      Icons.fingerprint_rounded,
                      size: 120,
                      color:Colors.green
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }



}

