import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/model_class/chatmodel.dart';
import 'package:firebase_authentication/model_class/messsage_user_model.dart';
import 'package:firebase_authentication/service/service.dart';
import 'package:firebase_authentication/utils/app_color.dart';
import 'package:firebase_authentication/utils/text_style.dart';
import 'package:firebase_authentication/widget/chat_user_card.dart';
import 'package:firebase_authentication/widget/login_signup_reset_method.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dashboard-student/chat_room_screen/message_screen.dart';

class message_user_screen extends StatefulWidget {


  @override
  State<message_user_screen> createState() => message_user_screenState();
}


class message_user_screenState extends State<message_user_screen>  {


  final auth = FirebaseAuth.instance;
  final storeinstance = FirebaseFirestore.instance;
  List<messageUserModel> messageUser = [];
  List<MessageModel> MessageData = [];
  var messages;
  bool isFetching = false, Loading = false;

  Get_messager() async {
    isFetching = true;
    messageUser = (await messageUserDataGet())!;
    print('message USer Length${messageUser.length}');
    isFetching = false;
    setState(() {});
  }

  delete(id,String? document){
    ChatUserdatadelete(id);
    Get.snackbar('Delete', '${document}',
        backgroundColor: Colors.red,
        animationDuration: const Duration(milliseconds: 50),
        snackPosition: SnackPosition.BOTTOM);
    Get_messager();
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance.addObserver(this);
    Get_messager();
    print('Chat User Length${messageUser.length}');
    // setStatus("Online");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Messages'),
        centerTitle: true,
        elevation: 5,
        shadowColor: Colors.white,
        backgroundColor: Colors.black,),
      body: isFetching
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : messageUser.isNotEmpty
          ? Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: List.generate(
              messageUser.length,
                  (index) {
                var data = messageUser[index];
                return ChatUserCard(user: data);
              },
            ),
          ))
          : Center(
        child: Text(
          'No Data Found',
          style: text_style.high_text,
        ),
      ),
    );
  }
}
