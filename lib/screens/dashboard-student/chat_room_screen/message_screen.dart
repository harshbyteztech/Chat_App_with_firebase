// ignore_for_file: avoid_print, non_constant_identifier_names

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/Screens/message_user_screen.dart';
import 'package:firebase_authentication/model_class/chatmodel.dart';
import 'package:firebase_authentication/model_class/user_token_model.dart';
import 'package:firebase_authentication/model_class/usermodel.dart';
import 'package:firebase_authentication/service/service.dart';
import 'package:firebase_authentication/sharedpreferences/shared_preferences.dart';
import 'package:firebase_authentication/utils/app_color.dart';
import 'package:firebase_authentication/utils/text_style.dart';
import 'package:firebase_authentication/widget/chat_message_card.dart';
import 'package:firebase_authentication/widget/format_time.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../model_class/messsage_user_model.dart';
import '../../../widget/textform_widget.dart';
import 'show_image.dart';

class message_screen extends StatefulWidget {
  message_screen({this.userdata, this.messageUser});

  Userdata? userdata;
  messageUserModel? messageUser;

  @override
  State<message_screen> createState() => _message_screenState();
}

// ignore: camel_case_types
class _message_screenState extends State<message_screen> {

  final auth = FirebaseAuth.instance;
  final storeinstance = FirebaseFirestore.instance;
  List<MessageModel> chatroomModel = [];
  TextEditingController messagecontroller = TextEditingController();
  bool isFetching = false;
  final _loginkey = GlobalKey<FormState>();
  final ScrollController scrollController = ScrollController();
  ImagePicker imagePicker = ImagePicker();
  File? imageFile;
  var messages;
  List<user_token_model> usertoken = [];
  var token;

  gettoken() async {
    usertoken = (await GetUserToken(widget.messageUser?.target_user_id))!;
    token = usertoken[0].token;
    setState(() {});
  }

  String createroom(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  createChatRoom() async {
    String roomid =
        createroom(auth.currentUser!.uid, "${widget.userdata?.userId}");
    await storeinstance.collection('chatroom').doc(roomid).set({
      'currant_Id': auth.currentUser!.uid,
      'target_user_id': widget.userdata?.userId,
      'email_target_user': widget.userdata?.email,
      'profile': widget.userdata?.profileImage,
      'target_username': widget.userdata?.username,
      'room_id': roomid,
    });
    await storeinstance
        .collection("User")
        .doc(widget.userdata?.userId)
        .collection("chatroom")
        .doc(roomid)
        .set({
      'currant_Id': widget.userdata?.userId,
      'target_user_id': auth.currentUser!.uid,
      'email_target_user': userEmail,
      'profile': userImage,
      'target_username': userName,
      'room_id': roomid,
      'status': 'offline',
    });
    await storeinstance
        .collection("User")
        .doc(auth.currentUser!.uid)
        .collection("chatroom")
        .doc(roomid)
        .set({
      'currant_Id': auth.currentUser!.uid,
      'target_user_id': widget.userdata?.userId,
      'email_target_user': widget.userdata?.email,
      'profile': widget.userdata?.profileImage,
      'target_username': widget.userdata?.username,
      'room_id': roomid,
      'status': 'offline',
    });

    messagecontroller.clear();
  }

  Future getImage(ImageSource source) async {
    await imagePicker.pickImage(source: source).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage();
        get();
      }
    });
  }

  Future uploadImage() async {
    int status = 1;
    DateTime now = DateTime.now();
    var messageid = DateTime.now().millisecondsSinceEpoch.toString();
    var chatroomid = createroom(
        auth.currentUser!.uid,
        widget.userdata != null
            ? "${widget.userdata?.userId}"
            : "${widget.messageUser?.target_user_id}");
    await storeinstance
        .collection('chatroom')
        .doc(chatroomid)
        .collection('Message')
        .doc(messageid)
        .set({
      'type': 'img',
      'sendby': auth.currentUser!.uid,
      "sendto": widget.userdata == null
          ? widget.messageUser?.target_user_id
          : widget.userdata?.userId,
      'messageid': messageid,
      'message': "",
      'sent': messageid,
      'read': "",
    });
    var ref =
        FirebaseStorage.instance.ref().child('images').child("$messageid.jpg");

    var uploadTask = await ref.putFile(imageFile!).catchError((error) async {
      var chatroomid = createroom(
          auth.currentUser!.uid,
          widget.userdata != null
              ? "${widget.userdata?.userId}"
              : "${widget.messageUser?.target_user_id}");
      await storeinstance
          .collection('chatroom')
          .doc(chatroomid)
          .collection('Message')
          .doc(messageid)
          .delete();
      status = 0;
    });

    if (status == 1) {
      String imageUrl = await uploadTask.ref.getDownloadURL();
      var chatroomid = createroom(
          auth.currentUser!.uid,
          widget.userdata != null
              ? "${widget.userdata?.userId}"
              : "${widget.messageUser?.target_user_id}");
      await storeinstance
          .collection('chatroom')
          .doc(chatroomid)
          .collection('Message')
          .doc(messageid)
          .update({"message": imageUrl});
    }
  }

  onsendmessage() async {
    if (messagecontroller.text.isEmpty) {
      return print('please type message');
    } else {
      messages = messagecontroller.text;

      sendnotification(
          widget.messageUser?.target_username,
          widget.userdata == null ? token : widget.userdata?.token,
          messagecontroller.text.toString());
      var messageid = DateTime.now().millisecondsSinceEpoch.toString();
      var chatroomid = createroom(
          auth.currentUser!.uid,
          widget.userdata != null
              ? "${widget.userdata?.userId}"
              : "${widget.messageUser?.target_user_id}");
      await storeinstance
          .collection('chatroom')
          .doc(chatroomid)
          .collection('Message')
          .doc(messageid)
          .set({
        'type': 'text',
        'sendby': auth.currentUser!.uid,
        "sendto": widget.userdata == null
            ? widget.messageUser?.target_user_id
            : widget.userdata?.userId,
        'messageid': messageid,
        'message': messagecontroller.text,
        'sent': messageid,
        'read': "",
      });
      setState(() {});
    }
  }

  get() async {
    var chatroomid = createroom(
        auth.currentUser!.uid,
        widget.userdata != null
            ? "${widget.userdata?.userId}"
            : "${widget.messageUser?.target_user_id}");
    isFetching = false;
    chatroomModel = (await messageDataGet(chatroomid))!;
    isFetching = false;
    setState(() {});
  }

  updateReadTime(Messageid) async {
    var time = DateTime.now().millisecondsSinceEpoch.toString();
    await storeinstance
        .collection('chatroom')
        .doc(widget.messageUser?.room_id)
        .collection('Message')
        .doc(Messageid)
        .update({"read": time});
  }

  @override
  void initState() {
    super.initState();
    get();
    widget.userdata == null ? gettoken() : null;
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Form(
        key: _loginkey,
        child: Scaffold(
            backgroundColor: app_color.black_color,
            appBar: AppBar(
                title: Column(
                  children: [
                    Text(widget.userdata != null
                        ? '${widget.userdata?.username}'
                        : '${widget.messageUser?.target_username}'),
                    Text(widget.userdata != null
                        ? '${widget.userdata?.status}'
                        : '${widget.messageUser?.target_username}')
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
                          onPressed: () async {
                            Navigator.pop(context, messages);
                          },
                          icon: const Icon(Icons.arrow_back)),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: CachedNetworkImage(
                            imageUrl: widget.userdata != null
                                ? '${widget.userdata?.profileImage}'
                                : '${widget.messageUser?.profile}',
                            placeholder: (context, url) => const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            errorWidget: (context, url, error) =>
                            const Icon(Icons.image, size: 70),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                leadingWidth: 110),
            body: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(children: [
                  isFetching == true
                      ? const CircularProgressIndicator()
                      : chatroomModel.isEmpty
                          ? SizedBox(
                              height: size.height / 1.2 - 30,
                              child:const Center(
                                child: Text('Say Hii! 👋',
                                    style: TextStyle(fontSize: 20,color: Colors.white)),
                              ),
                            )
                          : SizedBox(
                              height: size.height / 1.2 - 30,
                              child: ListView.builder(
                                  reverse: true,
                                  controller: scrollController,
                                  shrinkWrap: true,
                                  itemCount: chatroomModel.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index == chatroomModel.length) {
                                      return const SizedBox(
                                        height: 70,
                                      );
                                    }
                                    var data = chatroomModel[index];
                                    // messages = data.type =='img'?'image':data.message;
                                    return MessageCard(
                                      messages: data,
                                        Index:index,
                                        list:chatroomModel,
                                        roomid:
                                            "${widget.messageUser?.room_id}");
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
                              width: 280,
                              child: Textfield(
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
                                  widget.userdata != null
                                      ? createChatRoom()
                                      : null;
                                  onsendmessage();
                                  get();
                                  messagecontroller.clear();
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
}
