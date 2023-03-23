import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/model_class/user_token_model.dart';
import 'package:firebase_authentication/screens/dashboard-student/group_chat_room/group_screen.dart';
import 'package:firebase_authentication/screens/dashboard-student/search_screen.dart';
import 'package:firebase_authentication/screens/message_user_screen.dart';
import 'package:firebase_authentication/service/service.dart';
import 'package:firebase_authentication/sharedpreferences/shared_preferences.dart';
import 'package:firebase_authentication/utils/app_color.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model_class/usermodel.dart';
import '../../widget/drawer_widget.dart';
import 'follow_screen.dart';
import 'notification_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;
  final database = FirebaseFirestore.instance.collection('User');
  List<Userdata> userData = [];

  get() async {
    userData = (await currentUserdataget())!;
    var Image = userData[0].profileImage;
    var name = userData[0].username;
    shared.save_image(Image);
    shared.save_username(name);
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var obtainedimage = sharedPreferences.getString('image');
    var obtainedusername = sharedPreferences.getString('username');
    var obtainedemail = sharedPreferences.getString('email');
    setState(() {
      userImage = obtainedimage;
      userName = obtainedusername;
      userEmail = obtainedemail;
    });
    setState(() {});
  }

  CreatToken() async {
    final FirebaseMessaging message = FirebaseMessaging.instance;
    final usertoken = await message.getToken();
    await database
        .doc(auth.currentUser?.uid).
    update({"token":usertoken});

    await database.doc(auth.currentUser?.uid).collection('token').doc(userEmail).update(
        {"token":usertoken});

  }

  late int selectedIndex = 0;

  onchange(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  // ignore: non_constant_identifier_names
  late List User_Data_List = [
    const follow_screen(),
    const search_screen(),
    const notifications(),
    Center(
      child: Text(
        'Profile',
        style: TextStyle(color: app_color.white_color, fontSize: 25),
      ),
    ),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get();
    CreatToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => group_screen(),
                ));
          },
          child: const Icon(Icons.group)),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('WELCOME'),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(message_user_screen());
              },
              icon: const Icon(Icons.message))
        ],
      ),
      drawer: drawer_widget(),
      backgroundColor: Colors.black,
      bottomNavigationBar: Container(
        height: 60,
        decoration: const BoxDecoration(
            color: Colors.black,
            boxShadow: theme.containershadowW,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(25), topLeft: Radius.circular(25))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            bottomitem(0, 'User', Icons.person),
            bottomitem(1, 'Search', Icons.search),
            bottomitem(2, 'Favorite', Icons.favorite_border_outlined),
            bottomitem(3, 'Setting', Icons.settings),
          ],
        ),
      ),
      body: User_Data_List.elementAt(selectedIndex),
    );
  }

  bottomitem(int? index, String? name, IconData? icons) {
    return InkWell(
      onTap: () {
        setState(() {
          onchange(index);
        });
      },
      child: AnimatedContainer(
        height: 50,
        width: selectedIndex == index! ? 120 : 50,
        duration: const Duration(seconds: 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(
              icons,
              color: selectedIndex == index ? Colors.white : Colors.white,
              size: selectedIndex == index ? 30 : 25,
            ),
            selectedIndex == index
                ? Expanded(
                    child: Text(
                      '$name',
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                : const Text(''),
          ],
        ),
      ),
    );
  }
}
