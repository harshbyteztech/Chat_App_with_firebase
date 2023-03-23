import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/Screens/dashboard-student/home_screen.dart';
import 'package:firebase_authentication/screens/dashboard-student/group_chat_room/group_create_screen.dart';
import 'package:firebase_authentication/utils/app_color.dart';
import 'package:firebase_authentication/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../model_class/group_model.dart';
import '../../../model_class/usermodel.dart';
import '../../../service/service.dart';
import '../../../sharedpreferences/shared_preferences.dart';
import '../../../widget/textform_widget.dart';
import 'group_screen.dart';

class add_member_screen extends StatefulWidget {
  add_member_screen({this.groupid,this.memberList,this.groupdata});

  String?groupid;
  group_model? groupdata;
  List? memberList;



  @override
  State<add_member_screen> createState() => _add_member_screenState();
}

class _add_member_screenState extends State<add_member_screen> {
  List<Map<String, dynamic>> memberList = [];

  final auth = FirebaseAuth.instance;
  final storeinstance = FirebaseFirestore.instance;
  bool isFetching = false, Loading = false;
  List<Userdata> userData = [];
  late TextEditingController search = TextEditingController();
  List<Userdata> searchData = [];
  List MemberList = [];

  var name;

  ontap() async{
    await storeinstance
        .collection("group")
        .doc(widget.groupid).update({
      "members":widget.memberList,
    });
    String path = DateTime.now().millisecondsSinceEpoch.toString();

    for (int i = 0; i < widget.memberList!.length; i++) {
      String uid = widget.memberList?[i]['uid'];
      await storeinstance
          .collection("User")
          .doc(uid)
          .collection("group")
          .doc(widget.groupid)
          .set({
        "groupname": widget.groupdata?.group_name,
        "groupid": widget.groupid,
        'groupImage':widget.groupdata?.group_image,
      });
    }
    await storeinstance
        .collection("group")
        .doc(widget.groupid)
        .collection("chats")
        .doc(path)
        .set({
      "message": "$userName added ${name}",
      "type": "notify",
    });
    Navigator.pop(context);
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
  }

  getMembers() async {
    isFetching = true;
    await storeinstance
        .collection("group")
        .doc(widget.groupid)
        .get()
        .then((value) => MemberList = value['members']);
    isFetching = false;
    setState(() {
    });
  }

  onsearch() async {
    Loading = true;
    searchData = (await searchmemberdata(
      search.text,
    ))!;
    Loading = false;
    print('search == ${searchData.length}');
    setState(() {});
  }

  addcurrentuser() async {
    bool isAlreadyExist = false;
    for (int i = 0; i < memberList.length; i++) {
      if (memberList[i]['uid'] == auth.currentUser!.uid) {
        return isAlreadyExist = true;
      }
    }
    if (!isAlreadyExist) {
      memberList.add({
        "name":userName,
        "email": userEmail,
        "uid":auth.currentUser!.uid,
        "image":userImage,
        "admin":true,
      });
    }
  }

  ADDmember(searchdata, userId) {
    bool isAlreadyExist = false;
    for (int i = 0; i < memberList.length; i++) {
      if (memberList[i]['uid'] == userId) {
        return isAlreadyExist = true;
      }
    }
    if (!isAlreadyExist) {
      memberList.add({
        "name": searchdata.username,
        "email": searchdata.email,
        "uid": searchdata.userId,
        "image": searchdata.profileImage,
        "admin":false,
      });
    }
  }

  AdminAddMember(searchdata, userId) {
    bool isAlreadyExist = false;
    int? length = widget.memberList?.length;

    for (int i = 0; i < length!; i++) {
      if (widget.memberList?[i]['uid'] == userId) {
        return isAlreadyExist = true;
      }
    }
    if (!isAlreadyExist) {
      widget.memberList?.add({
        "name": searchdata.username,
        "email": searchdata.email,
        "uid": searchdata.userId,
        "image": searchdata.profileImage,
        "admin":false,
      });
    }
  }

  Removemember(int index) {
    if(memberList[index]["uid"]== auth.currentUser!.uid) {
      return null;
    }
    else{
    return  setState(() {
        memberList.removeAt(index);
      });
    }

  }

  void initState() {
    super.initState();
    onsearch();
    addcurrentuser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Add Members"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 10),
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.groupid ==null?memberList.length:widget.memberList?.length,
                          itemBuilder: (context, index) {
                            var Data = widget.groupid ==null?memberList[index]:widget.memberList?[index];
                            return InkWell(
                              onTap: () {
                                Removemember(index);
                              },
                              child: Container(
                                margin: const EdgeInsets.all(8.0),
                                height: 70,
                                child: Stack(
                                  children: [
                                    Row(
                                      children: [
                                        isFetching
                                            ? const Center(
                                                child:
                                                    CircularProgressIndicator())
                                            : CircleAvatar(
                                                radius: 40,
                                                backgroundImage: NetworkImage(
                                                    '${Data["image"]}'),
                                              ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Username:-',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color:
                                                          app_color.white_color,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  '${Data["name"]}',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color:
                                                          app_color.white_color),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Email:-',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color:
                                                          app_color.white_color,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  '${Data["email"]}',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color:
                                                          app_color.white_color),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            IconButton(
                                                onPressed: () {},
                                                icon: Icon(
                                                  Icons.close,
                                                  color: app_color.white_color,
                                                )),
                                            Text(
                                              'Remove',
                                              style: TextStyle(
                                                  color: app_color.white_color),
                                            )
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                            );
                          }),
                    )),
                Textfield(
                    controller: search,
                    Hindtext: 'Search',
                    prefixIcon: Icons.search,
                    iconcolor: app_color.white_color,
                    suffixIcon: IconButton(
                        onPressed: () {
                          onsearch();
                        },
                        icon: Icon(
                          Icons.done,
                          color: app_color.white_color,
                        ))),
                Loading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : searchData.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(top: 200),
                            child: Center(
                              child: Text(
                                'No Data Found',
                                style: text_style.high_text,
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: searchData.length,
                                itemBuilder: (context, index) {
                                  var searchdata = searchData[index];
                                  return InkWell(
                                    onTap: () {
                                     widget.groupid ==null? ADDmember(searchdata, searchdata.userId)
                                     :AdminAddMember(searchdata, searchdata.userId);
                                      search.clear();
                                      onsearch();
                                      setState(() {
                                        name = searchdata.username;
                                      });
                                      print("name ==> $name");
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(8.0),
                                      height: 70,
                                      child: Stack(
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 40,
                                                backgroundImage: NetworkImage(
                                                    '${searchdata.profileImage}'),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Username:-',
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            color: app_color
                                                                .white_color,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        '${searchdata.username}',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: app_color
                                                                .white_color),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Email:-',
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            color: app_color
                                                                .white_color,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        '${searchdata.email}',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: app_color
                                                                .white_color),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                })),
              ],
            )),
      ),
      floatingActionButton:
      FloatingActionButton(
              onPressed: () {
              widget.groupid == null?newcreatememberlist():ontap();
              },
              child: Icon(Icons.forward),
            ),
          // :SizedBox():null,
    );
  }
  newcreatememberlist(){
    Navigator.pop(context);
    Get.to(create_group(
      memberList: memberList,
    ));
  }
}
