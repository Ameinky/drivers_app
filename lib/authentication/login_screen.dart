import 'package:drivers_app/authentication/forget_password.dart';
import 'package:drivers_app/constants/constan_color.dart';
import 'package:drivers_app/splashscreen/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../global/global.dart';
import '../widgets/progress_dailog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController EmailTextEditingController = TextEditingController();
  TextEditingController PasswordTextEditingController = TextEditingController();
  int? nom;
  void ValidateForm() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    if (!EmailTextEditingController.text.contains("@")) {
      Fluttertoast.showToast(msg: "Email Address in not valid");
    } else if (EmailTextEditingController.text == nom) {
      Fluttertoast.showToast(msg: "Email Address in not prevent number");
    } else if (PasswordTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Password is required,");
    } else {
      loginDriverNow();
    }
  }

  loginDriverNow() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return ProgressDailog(
            message: "Processing PlS Wait...",
          );
        });
    final User? firebaseUser = (await fAuth
            .signInWithEmailAndPassword(
      email: EmailTextEditingController.text.trim(),
      password: PasswordTextEditingController.text.trim(),
    )
            .catchError((msg) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error" + msg.toString());
    }))
        .user;

    if (firebaseUser != null) {
      DatabaseReference driversRef =
          FirebaseDatabase.instance.ref().child("drivers");

      driversRef.child(firebaseUser.uid).once().then((driverKey) {
        final snap = driverKey.snapshot;
        if (snap.value != null) {
          currentFirebaseUser = firebaseUser;
          Fluttertoast.showToast(msg: "Login SuccessFull");
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => MySplachScreen()));
        } else {
          Fluttertoast.showToast(msg: "No Record exist with this Email");
          fAuth.signOut();
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => MySplachScreen()));
        }
      });
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error Accured During Login");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blueColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset(
                  'images/logo2.png',
                  height: 310,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Login as a Driver',
                style: TextStyle(
                  fontSize: 30,
                  color: whiteColor,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: EmailTextEditingController,
                style: TextStyle(color: whiteColor),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: "Email",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: whiteColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: whiteColor),
                  ),
                  hintStyle: TextStyle(
                    fontSize: 20,
                    color: whiteColor,
                  ),
                  labelStyle: TextStyle(
                    fontSize: 20,
                    color: whiteColor,
                  ),
                ),
              ),
       
              TextField(
                controller: PasswordTextEditingController,
                style: TextStyle(color: whiteColor),
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: "Password",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: whiteColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: whiteColor),
                  ),
                  hintStyle: TextStyle(
                    fontSize: 20,
                    color: whiteColor,
                  ),
                  labelStyle: TextStyle(
                    fontSize: 20,
                    color: whiteColor,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  ValidateForm();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.lightGreenAccent,
                ),
                child: Text(
                  'LogIn',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 7,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgetPasswordPage(),
                          ));
                    },
                    child: Text(
                      'Forget Password',
                      style: TextStyle(
                        color: whiteColor,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
