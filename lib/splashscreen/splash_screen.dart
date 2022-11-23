import 'dart:async';

import 'package:drivers_app/authentication/login_screen.dart';
import 'package:drivers_app/constants/constan_color.dart';
import 'package:drivers_app/mainScreens/main_screen.dart';

import 'package:flutter/material.dart';
import '../global/global.dart';

class MySplachScreen extends StatefulWidget {
  const MySplachScreen({Key? key}) : super(key: key);

  @override
  State<MySplachScreen> createState() => _MySplachScreenState();
}

class _MySplachScreenState extends State<MySplachScreen> {
  startTimer() {
    // fAuth.currentUser != null
        // ? AssistantMethods.readDriverEarnings
        // : null;
    Timer(const Duration(seconds: 3), () async {
      if (await fAuth.currentUser != null) {
        currentFirebaseUser = fAuth.currentUser;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MainSCreen()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blueColor,
      body: Center(
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.spaceAround,

          children: [
              Image.asset(
                      'images/logo1.png',
                      height: 320,
                      fit: BoxFit.cover,
                    ),

                    const Text(
                      'Drivers App in Ambulance Booking',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
            // Container(
            //   color: blueColor,
            //   child: Padding(
            //     padding: const EdgeInsets.all(16.0),
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
                  
                    
            //       ],
            //     ),
            //   ),
            // ),
         
          ],
        ),
      ),
    );
  }
}
