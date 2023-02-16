import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard/home_screen.dart';
import 'login_screen.dart';

class splash_screen extends StatefulWidget {
  const splash_screen({Key? key}) : super(key: key);

  @override
  State<splash_screen> createState() => _splash_screenState();
}

class _splash_screenState extends State<splash_screen> {
  var Email;

  @override
  void initState() {
    getValidationData().whenComplete(() {
   Timer(Duration(seconds: 1), () { Navigator.pushReplacement(
       context,
       MaterialPageRoute(
           builder: (context) =>
           Email == null ? LoginScreen() : HomeScreen())); });

    });
    super.initState();
  }

  Future getValidationData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var obtainedEmail = sharedPreferences.getString('email');
    setState(() {
      Email = obtainedEmail;
    });
    print(Email);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/photo.jpg'),fit: BoxFit.cover),
    ));
  }
}
