import 'dart:core';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/model_class/group_model.dart';
import 'package:firebase_authentication/screens/dashboard-student/group_chat_room/add_member_screen.dart';
import 'package:firebase_authentication/service/service.dart';
import 'package:firebase_authentication/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'group_message_screen.dart';

class group_screen extends StatefulWidget {
  group_screen({Key? key}) : super(key: key);

  @override
  State<group_screen> createState() => _group_screenState();
}

class _group_screenState extends State<group_screen> {
  final auth = FirebaseAuth.instance;
  final storeinstance = FirebaseFirestore.instance;
  bool isFetching = false, Loading = false;
  List<group_model> GroupList = [];

  void getvalue() async {
    isFetching = true;
    GroupList = (await GroupDataGet())!;
    isFetching = false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getvalue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(add_member_screen()),
        child: Icon(Icons.edit),
      ),
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Group Name'),
      ),
      body: Container(
        child: isFetching
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : GroupList.isEmpty
                ? Center(
                    child: Text(
                      'No Data Found',
                      style: text_style.high_text,
                    ),
                  )
                : ListView.builder(
                    itemCount: GroupList.length,
                    itemBuilder: (context, index) {
                      var data = GroupList[index];
                      return ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    group_message_screen(groupdata: data),
                              ));
                        },
                        leading:  ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CachedNetworkImage(
                            imageUrl: "${data.group_image}",
                            placeholder: (context, url) => const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            errorWidget: (context, url, error) =>
                            const Icon(Icons.image, size: 70),
                          ),
                        ),
                        title: Text(
                          "${data.group_name}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
