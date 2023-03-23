
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/utils/app_color.dart';
import 'package:firebase_authentication/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model_class/studentmodel.dart';
import '../../service/service.dart';
import 'female_data.dart';
import 'male_data.dart';



class user_data extends StatefulWidget {
  const user_data({Key? key}) : super(key: key);

  @override
  State<user_data> createState() => _user_dataState();
}



class _user_dataState extends State<user_data> {
  int index = 0;
  List form_data = [
    male_data(),
    female_data()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 140),
        child: Container(
          height: 60,
          child: Stack(alignment: Alignment.center, children: [
            Positioned(
              top: 10,
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width / 1.6,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.black,
                      Colors.black,
                    ]),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    )),
                child: DefaultTabController(
                  animationDuration: const Duration(milliseconds: 500),
                  length: 2,
                  child: TabBar(
                      onTap:(value) {
                         setState(() {
                          index = value;
                         });
                      },
                      indicator: const BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Color(0Xff757584), Color(0XffAFAFC7)]),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          )),
                      tabs: const[
                        Text(
                          'Male',
                          style:  TextStyle(
                              fontSize: 25,
                              color: Color(0XffFFFFFF),
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Female',
                          style:  TextStyle(
                              fontSize: 25,
                              color: Color(0XffFFFFFF),
                              fontWeight: FontWeight.bold),
                        ),
                      ]),
                ),
              ),
            ),
          ]),
        ),
      ),
      body: form_data.elementAt(index),
    );
  }
}
