import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/utils/text_style.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_authentication/sharedpreferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import '../Screens/dashboard-student/home_screen.dart';



final _loginkey = GlobalKey<FormState>();
final auth = FirebaseAuth.instance;
final database = FirebaseFirestore.instance.collection('User');
ImagePicker image = ImagePicker();
File? file;
String url = '';
final FirebaseMessaging message = FirebaseMessaging.instance;



class method{
  static login(context,email,password,) async {
      try {
        await auth.signInWithEmailAndPassword(
            email: email.text, password: password.text);
        shared.save_email(email);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
        Get.snackbar("Welcome", 'Successfully login',
            colorText: Colors.black, backgroundColor: Colors.green);
      } catch (e) {
        Get.snackbar("Error", 'Email & Password Invalid',
            colorText: Colors.black, backgroundColor: Colors.red);
        print(e);
      }

  }
  static signup({String? email,String? password,String? username,String? url}) async {
    final usertoken = await message.getToken();
    try {
        await auth.createUserWithEmailAndPassword(
            email: email.toString(), password: password.toString());
        // shared.save_email(email);
        await database.doc(auth.currentUser?.uid).set({
          'Username': username,
          'Email': email,
          'Password': password,
          'authId': auth.currentUser?.uid,
          'profile': url.toString(),
          'status': 'offline',
          'lastMessage':"",
          'token':usertoken
          // 'followers':[],
          // 'following':[],
        });
        print('Successfully registor');
          await database
              .doc(auth.currentUser?.uid).collection('token').doc(email).
          set({"token":usertoken});
        text_style.index = false;
        // Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (context) => LoginScreen()));
        Get.snackbar("Welcome", 'Successfully registor',
            colorText: Colors.black, backgroundColor: Colors.green);
    } catch (e) {
      // index = index;
      Get.snackbar("Error", 'Email is already login',
          colorText: Colors.black, backgroundColor: Colors.red);
      print(e);

    };
  }
  static forgot(context,String? email){
    try{
    auth.sendPasswordResetEmail(email: email.toString());
    Get.snackbar("Successfully", ' send OTP on your email address',
        colorText: Colors.black, backgroundColor: Colors.green);
    }
        catch (e){
          Get.snackbar("Error", 'Email & Password Invalid',
              colorText: Colors.black, backgroundColor: Colors.red);
          print(e);
        }
  }
}