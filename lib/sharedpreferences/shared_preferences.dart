 import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

  class shared{
   static save_email(TextEditingController email) async{
     final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
     sharedPreferences.setString('email', email.text);
   }
   static save_image(String? image) async{
     final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
     sharedPreferences.setString('image', "$image");
   }
   static save_username(String? username) async{
     final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
     sharedPreferences.setString('username', "$username");
   }
  }
  var userEmail;
  var userImage;
  var userName;

