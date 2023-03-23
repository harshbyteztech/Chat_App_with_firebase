import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/Screens/dashboard-student/chat_room_screen/message_screen.dart';
import 'package:firebase_authentication/service/service.dart';
import 'package:firebase_authentication/utils/app_color.dart';
import 'package:firebase_authentication/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model_class/usermodel.dart';
import '../../widget/textform_widget.dart';

class search_screen extends StatefulWidget {
  const search_screen({Key? key}) : super(key: key);

  @override
  State<search_screen> createState() => _search_screenState();
}

class _search_screenState extends State<search_screen> {
  late TextEditingController search = TextEditingController();
  List<Userdata> userData = [];
  String dropvalue = "";
 final auth = FirebaseAuth.instance;
  final database = FirebaseFirestore.instance;
  late String userid = auth.currentUser!.uid;
  bool Loading = false;
  final index = 0;


  onsearch() async {
      Loading = true;
    userData = (await searchuserdata(search.text,))!;
      Loading = false;
    print('search == ${userData.length}');
    setState(() {
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      onsearch();
    print('===${userData.length}');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 10),
        child: Column(
          children: [
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
                : userData.isEmpty
                    ? Center(
                        child: Text(
                          'No Data Found',
                          style: text_style.high_text,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                            itemCount: userData.length,
                            itemBuilder: (context, index) {
                              var data = userData[index];
                              return InkWell(
                                onTap: () {
                                  Get.to(message_screen(userdata: data));
                                  search.clear();
                                  setState(() {});
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(8.0),
                                  height: 70,
                                  child: Stack(
                                    children: [
                                      Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(30),
                                            child: CachedNetworkImage(
                                              imageUrl: "${data.profileImage}",
                                              placeholder: (context, url) => const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: CircularProgressIndicator(strokeWidth: 2),
                                              ),
                                              errorWidget: (context, url, error) =>
                                              const Icon(Icons.image, size: 70),
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
                                                        color: app_color
                                                            .white_color,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    '${data.username}',
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
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    '${data.email}',
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
                                                    Icons.add,
                                                    color:
                                                        app_color.white_color,
                                                  )),
                                              Text(
                                                'Follow',
                                                style: TextStyle(
                                                    color:
                                                        app_color.white_color),
                                              )
                                            ],
                                          )),
                                    ],
                                  ),
                                ),
                              );
                            })
                        )
          ],
        ));
  }
}
