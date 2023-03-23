import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/model_class/usermodel.dart';
import 'package:firebase_authentication/utils/app_color.dart';
import 'package:firebase_authentication/utils/text_style.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../service/service.dart';
import '../../sharedpreferences/shared_preferences.dart';
import 'chat_room_screen/message_screen.dart';

class follow_screen extends StatefulWidget {
  const follow_screen({Key? key}) : super(key: key);

  @override
  State<follow_screen> createState() => _follow_screenState();
}

class _follow_screenState extends State<follow_screen> with WidgetsBindingObserver {

  final auth = FirebaseAuth.instance;
  final storeinstance = FirebaseFirestore.instance;
  bool isFetching = false, Loading = false;
  List<Userdata>? userData;
  TextEditingController message = TextEditingController();
  final database = FirebaseFirestore.instance;
  late String userid = auth.currentUser!.uid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    get();
    setStatus("Online");
  }

 setStatus(String status) async{
    await storeinstance.collection('User').doc(auth.currentUser!.uid).update(
        {
          'status':status,
        });
 }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if(state == AppLifecycleState.resumed){
      //online
      setStatus("Online");
    }else{
      // offline
      setStatus("offline");
    }
  }

  get() async {
    setState(() {
      isFetching = true;
    });
    userData = await Userdataget();
    setState(() {
      isFetching = false;
      Loading = true;
    });
  }

  delete(String? id, String? document,) {
    userdatadelete();
    Get.snackbar('Delete', '${document}',
        backgroundColor: Colors.red,
        animationDuration: const Duration(milliseconds: 50),
        snackPosition: SnackPosition.BOTTOM);
    get();
  }




  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;

    return isFetching
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : userData!.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: List.generate(
                    userData!.length,
                    (index) {
                      var data = userData![index];
                      return InkWell(
                        onTap: () async {
                        },
                        child: Container(
                          margin: const EdgeInsets.all(8.0),
                          height: 70,
                          child: Stack(
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(mq.height * .08),
                                    child: CachedNetworkImage(
                                      width: mq.height * .085,
                                      height: mq.height * .085,
                                      imageUrl: "${data.profileImage}",
                                      errorWidget: (context, url, error) =>
                                      const CircleAvatar(child: Icon(CupertinoIcons.person)),
                                    ),
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
                                                color: app_color.white_color,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            '${data.username}',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: app_color.white_color),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Email:-',
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: app_color.white_color,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            '${data.email}',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: app_color.white_color),
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
                    },
                  ),
                ))
            : Center(
                child: Text(
                  'No Data Found',
                  style: text_style.high_text,
                ),
              );
  }
}
