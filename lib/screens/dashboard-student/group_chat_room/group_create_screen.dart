import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/screens/dashboard-student/group_chat_room/group_screen.dart';
import 'package:firebase_authentication/sharedpreferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../follow_screen.dart';
import '../home_screen.dart';

class create_group extends StatefulWidget {
  create_group({required this.memberList});

  final List<Map<String, dynamic>> memberList;

  @override
  State<create_group> createState() => _create_groupState();
}

class _create_groupState extends State<create_group> {
  final auth = FirebaseAuth.instance;
  final storeinstance = FirebaseFirestore.instance;
  bool isFetching = false;
  TextEditingController creategroup = TextEditingController();
  String url = '';
  File file = File("path");
  ImagePicker image = ImagePicker();
  final String path = DateTime.now().millisecondsSinceEpoch.toString();

  get_image() async {
    final img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(img!.path);
    });
  }

  CreateGroup() async {
    setState(() {
      isFetching = true;
    });
    String path = DateTime.now().millisecondsSinceEpoch.toString();
    var imageFile = FirebaseStorage.instance.ref().child(path).child('/.jpg');
    UploadTask task = imageFile.putFile(file);
    TaskSnapshot snapshot = await task;
    url = await snapshot.ref.getDownloadURL();
    var name = creategroup.text;
    var groupid = await storeinstance.collection('group').doc().id;
    await storeinstance.collection('group').doc(groupid).set({
      'members': widget.memberList,
      'groupName': name,
      'groupId': groupid,
      'groupImage':url,
    });
    for (int i = 0; i < widget.memberList.length; i++) {
      String uid = widget.memberList[i]['uid'];
      await storeinstance
          .collection("User")
          .doc(uid)
          .collection("group")
          .doc(groupid)
          .set({
        "groupname": name,
        "groupid": groupid,
        'groupImage':url,
      });
    }
    await storeinstance
        .collection("group")
        .doc(groupid)
        .collection("chats")
        .doc(path)
        .set({
      "message": "$userName Created This Group",
      "type": "notify",
    });
    setState(() {
      isFetching = false;
    });

    // await storeinstance.collection()
    creategroup.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Group'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey,
                backgroundImage:FileImage(file),
                child:  Center(
                  child: IconButton(onPressed: () {
                    get_image();
                  },
                  icon: file == null? Icon(Icons.camera_alt, size: 30):SizedBox(),
                  ),
                )),
            SizedBox(height: 50,),
            TextFormField(
              controller: creategroup,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                focusColor: Colors.white,
                hintText: 'Enter name',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter group name";
                }
                return null;
              },
            ),
            SizedBox(
              height: 15,
            ),
            isFetching == true
                ? const Center(child: CircularProgressIndicator())
                : InkWell(
                    onTap: () {
                      CreateGroup();
                      Navigator.pop(context);
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                          HomeScreen()), (route) => false);
                    },
                    child: Container(
                      height: 50,
                      width: 70,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.all(Radius.circular(40))),
                      child: Center(child: Text('Yes')),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
