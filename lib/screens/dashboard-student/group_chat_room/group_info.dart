import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/Screens/dashboard-student/home_screen.dart';
import 'package:firebase_authentication/model_class/group_model.dart';
import 'package:firebase_authentication/screens/dashboard-student/group_chat_room/group_screen.dart';
import 'package:firebase_authentication/sharedpreferences/shared_preferences.dart';
import 'package:firebase_authentication/utils/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model_class/group_member.dart';
import '../../../service/service.dart';
import 'add_member_screen.dart';

class group_info extends StatefulWidget {
  group_info({this.groupdata});

  group_model? groupdata;

  @override
  State<group_info> createState() => _group_infoState();
}

class _group_infoState extends State<group_info> {
  final auth = FirebaseAuth.instance;
  final storeinstance = FirebaseFirestore.instance;
  bool isFetching = false, Loading = false;
  List MemberList = [];

  getMembers() async {
    isFetching = true;
    await storeinstance
        .collection("group")
        .doc(widget.groupdata?.groupId)
        .get()
        .then((value) => MemberList = value['members']);
    isFetching = false;
    setState(() {});
  }

  showdialog(int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return IconButton(
            onPressed: () {
              RemoveMember(index);
              Get.back();
            },
            icon: const Icon(Icons.delete));
      },
    );
  }

  RemoveMember(int index) async {
    String path = DateTime.now().millisecondsSinceEpoch.toString();
   var name = "${MemberList[index]["name"]}";
    if (CheckAdmin()) {
      if(auth.currentUser!.uid != MemberList[index]["uid"]){
      isFetching = true;
      String uid = "${MemberList[index]["uid"]}";
      MemberList.removeAt(index);
      await storeinstance
          .collection("group")
          .doc(widget.groupdata?.groupId)
          .update({
        "members": MemberList,
      });

      await storeinstance
          .collection('User')
          .doc(uid)
          .collection("group")
          .doc(widget.groupdata?.groupId)
          .delete();
      await storeinstance
          .collection("group")
          .doc(widget.groupdata?.groupId)
          .collection("chats")
          .doc(path)
          .set({
        "message": "$userName remove to $name",
        "type": "notify",
      });
      print("Member uid ==>$uid");
      print("groupid uid ==>${widget.groupdata?.groupId}");
      isFetching = false;
      setState(() {});
    } }else {
    }
  }

  bool CheckAdmin() {
    bool isAdmin = false;
    String uid = auth.currentUser!.uid;
    MemberList.forEach((element) {
      if (element["uid"] == uid) {
        isAdmin = element['admin'];
      }
    });
    return isAdmin;
  }

  LeaveGroup() async {
    String path = DateTime.now().millisecondsSinceEpoch.toString();
    if (!CheckAdmin()) {
      isFetching = true;
      String uid = auth.currentUser!.uid;

      for (int i = 0; i < MemberList.length; i++) {
        if (MemberList[i]['uid'] == uid) {
          MemberList.removeAt(i);

        }
      }
      await storeinstance
          .collection("group")
          .doc(widget.groupdata?.groupId)
          .update({
        "members": MemberList,
      });
      await storeinstance
          .collection('User')
          .doc(uid)
          .collection("group")
          .doc(widget.groupdata?.groupId)
          .delete();
      isFetching = false;
      setState(() {});
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false);
    }
    await storeinstance
        .collection("group")
        .doc(widget.groupdata?.groupId)
        .collection("chats")
        .doc(path)
        .set({
      "message": "$userName leave this group",
      "type": "notify",
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMembers();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    CupertinoIcons.back,
                    color: Colors.white,
                    size: 30,
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 5),
                child: Row(
                  children: [
                    CircleAvatar(
                        radius: 38,
                        backgroundImage:
                            NetworkImage("${widget.groupdata?.group_image}"),
                        backgroundColor: Colors.white,
                        child: widget.groupdata?.group_image == null
                            ? const Center(
                                child: Icon(Icons.group, size: 30),
                              )
                            : SizedBox()),
                    const SizedBox(
                      width: 25,
                    ),
                    Text("${widget.groupdata?.group_name}",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              ListTile(
                title: Text("${MemberList.length} members",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ),
              ListTile(
                  onTap: () {
                    if(CheckAdmin()){
                    Get.to(add_member_screen(
                      groupid: widget.groupdata?.groupId,
                      memberList: MemberList,
                      groupdata: widget.groupdata,
                    ));}
                    else{
                      print("you are not admin");
                    };
                  },
                  leading: const Icon(Icons.person_add, color: Colors.white),
                  title: const Text(
                    "Add members",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  )),
              isFetching
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : MemberList.isEmpty
                      ? Center(
                          child: Text(
                            'No Data Found',
                            style: text_style.high_text,
                          ),
                        )
                      : Flexible(
                          child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: MemberList.length,
                          itemBuilder: (context, index) {
                            var data = MemberList[index];
                            return ListTile(
                              onTap: () {
                                MemberList[index]['admin']
                                    ? null
                                    : showdialog(index);
                              },
                              trailing: Text(data["admin"] ? "Admin" : "",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                              leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage("${data["image"]}")),
                              title: Text("${data["name"]}",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text("${data["email"]}",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            );
                          },
                        )),
              ListTile(
                onTap: () {
                  LeaveGroup();
                },
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  'Leave group',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
