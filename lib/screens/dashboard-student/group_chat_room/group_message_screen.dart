// ignore_for_file: avoid_print, non_constant_identifier_names

import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/model_class/chatmodel.dart';
import 'package:firebase_authentication/model_class/group_chat_model.dart';
import 'package:firebase_authentication/model_class/group_model.dart';
import 'package:firebase_authentication/model_class/usermodel.dart';
import 'package:firebase_authentication/screens/dashboard-student/group_chat_room/group_info.dart';
import 'package:firebase_authentication/service/service.dart';
import 'package:firebase_authentication/sharedpreferences/shared_preferences.dart';
import 'package:firebase_authentication/utils/app_color.dart';
import 'package:firebase_authentication/utils/text_style.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../widget/textform_widget.dart';
import '../chat_room_screen/show_image.dart';

class group_message_screen extends StatefulWidget {
  group_message_screen({this.groupdata});

  group_model? groupdata;

  @override
  State<group_message_screen> createState() => _group_message_screenState();
}

// ignore: camel_case_types
class _group_message_screenState extends State<group_message_screen> {
  final auth = FirebaseAuth.instance;
  final storeinstance = FirebaseFirestore.instance;
  TextEditingController messagecontroller = TextEditingController();
  bool isFetching = false, Loading = false;
  final _loginkey = GlobalKey<FormState>();
  final ScrollController scrollController = ScrollController();
  ImagePicker imagePicker = ImagePicker();
  File? imageFile;
  List<group_chat_model> chatlist = [];

  sendmessage() async {
    if (messagecontroller.text.isNotEmpty) {
      var messageid = DateTime.now().millisecondsSinceEpoch.toString();
      await storeinstance
          .collection('group')
          .doc(widget.groupdata?.groupId)
          .collection("chats")
          .doc(messageid)
          .set({
        "sendby": userName,
        "message": messagecontroller.text,
        "type": "text",
        "messageid": messageid,
        "time": messageid,
      });
      messagecontroller.clear();
    } else {
      return print('please type message');
    }
  }

  getchat() async {
    chatlist = (await GroupMessageData(widget.groupdata?.groupId))!;
    setState(() {});
  }

  Future getImage(ImageSource source) async {
    await imagePicker.pickImage(source: source).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage();
        getchat();
      }
    });
  }

  Future uploadImage() async {
    int status = 1;
    var messageid = DateTime.now().millisecondsSinceEpoch.toString();
    await storeinstance
        .collection('group')
        .doc(widget.groupdata?.groupId)
        .collection('chats')
        .doc(messageid)
        .set({
      'type': 'img',
      'sendby': userName,
      'messageid': messageid,
      'message': "",
      'time': messageid
    });
    var ref =
        FirebaseStorage.instance.ref().child('images').child("$messageid.jpg");

    var uploadTask = await ref.putFile(imageFile!).catchError((error) async {
      await storeinstance
          .collection('group')
          .doc(widget.groupdata?.groupId)
          .collection('chats')
          .doc(messageid)          .delete();
      status = 0;
    });

    if (status == 1) {
      String imageUrl = await uploadTask.ref.getDownloadURL();

      await storeinstance
          .collection('group')
          .doc(widget.groupdata?.groupId)
          .collection('chats')
          .doc(messageid)
          .update({"message": imageUrl});
    }
  }

  void scrollToBottom() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void initState() {
    super.initState();
    getchat();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Form(
        key: _loginkey,
        child: Scaffold(
            backgroundColor: app_color.black_color,
            appBar: AppBar(
                actions: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              group_info(groupdata: widget.groupdata),
                        ));
                      },
                      icon: const Icon(Icons.more_vert))
                ],
                title: Column(
                  children: [
                    Text('${widget.groupdata?.group_name}'),
                    const Text('Online'),
                  ],
                ),
                centerTitle: false,
                titleSpacing: 20,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back)),
                      CircleAvatar(
                        backgroundImage: NetworkImage("${widget.groupdata?.group_image}"),
                      ),
                    ],
                  ),
                ),
                leadingWidth: 100),
            body: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(children: [
                  isFetching == true
                      ? const CircularProgressIndicator()
                      : chatlist.isEmpty
                          ? SizedBox(
                              height: size.height / 1.2 - 30,
                              child: Center(
                                child: Text(
                                  'No Data Found',
                                  style: text_style.high_text,
                                ),
                              ),
                            )
                          : SizedBox(
                              height: size.height / 1.2 - 30,
                              child: ListView.builder(
                                  controller: scrollController,
                                  shrinkWrap: true,
                                  itemCount: chatlist.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index == chatlist.length) {
                                      return const SizedBox(
                                        height: 70,
                                      );
                                    }
                                    var data = chatlist[index];
                                    return messages(size, context, data);
                                  }),
                            ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: 300,
                              child: Textfield(
                                onTap: scrollToBottom,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return '';
                                  }
                                  return null;
                                },
                                controller: messagecontroller,
                                suffixIcon: SizedBox(
                                  width: 100,
                                  child: Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            getImage(ImageSource.camera);
                                          },
                                          icon: Icon(
                                            Icons.camera_alt,
                                            color: app_color.text_color,
                                          )),
                                      IconButton(
                                          onPressed: () {
                                            getImage(ImageSource.gallery);
                                          },
                                          icon: Icon(
                                            Icons.image,
                                            color: app_color.text_color,
                                          )),
                                    ],
                                  ),
                                ),
                                icon: true,
                                Hindtext: 'typing message',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        color: app_color.text_color, width: 3)),
                                Border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  sendmessage();
                                  getchat();
                                },
                                icon: Icon(
                                  Icons.send,
                                  color: app_color.text_color,
                                  size: 30,
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            )));
  }

  Widget messages(size, context, group_chat_model? data) {
    return Builder(
      builder: (context) {
        if (data?.type == 'text') {
          return Container(
            width: MediaQuery.of(context).size.width,
            alignment: data?.sendby == userName
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.blue,
              ),
              child: Column(
                children: [
                  Text(
                    "${data?.sendby}",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: size.height / 200,
                  ),
                  Text(
                    "${data?.message}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (data?.type == 'img') {
          return Container(
            height: size.height / 2.5,
            width: size.width,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            alignment: data?.sendby == userName
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ShowImage(
                    imageUrl: "${data?.message}",
                  ),
                ),
              ),
              onLongPress: () {
                data?.sendby == userName
                    ? showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return IconButton(
                              onPressed: () {
                                groupmessageDelete(
                                    data?.messsageid, widget.groupdata?.groupId);
                                Get.back();
                                getchat();
                              },
                              icon: const Icon(Icons.delete));
                        },
                      )
                    : "";
                isFetching = true;
                // get();
                isFetching = false;
              },
              child: Container(
                height: size.height / 2.8,
                width: size.width / 2,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    border: Border.all(color: app_color.text_color, width: 10)),
                alignment: data?.message != "" ? null : Alignment.center,
                child: data?.message != ""
                    ? Image.network(
                        "${data?.message}",
                        fit: BoxFit.cover,
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),
            ),
          );
        } else if (data?.type == 'notify') {
          return Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.grey,
              ),
              child: Text(
                "${data?.message}",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          );
        }
        return SizedBox();
      },
    );
  }
}
