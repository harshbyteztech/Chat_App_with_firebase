import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/Screens/login_registor_screen.dart';
import 'package:firebase_authentication/service/service.dart';
import 'package:firebase_authentication/sharedpreferences/shared_preferences.dart';
import 'package:firebase_authentication/utils/app_color.dart';
import 'package:firebase_authentication/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model_class/usermodel.dart';

class drawer_widget extends StatefulWidget {
  drawer_widget({Key? key}) : super(key: key);

  @override
  State<drawer_widget> createState() => _drawer_widgetState();
}

class _drawer_widgetState extends State<drawer_widget> {
  bool isFetching = false;
  List<Userdata>? userData;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      get();
  }

 get() async{
    setState(() {
      isFetching = true;
    });
    userData = await currentUserdataget();
    setState(() {
      isFetching = false;
    });
}

  final auth = FirebaseAuth.instance;
  final database = FirebaseFirestore.instance.collection('User');
  late String userid = auth.currentUser!.uid;

  signout(context) async {
    await auth.signOut();
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.remove('email');
    sharedPreferences.remove('image');
    sharedPreferences.remove('username');
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }
  setStatus(String state)async{
   await database.doc(auth.currentUser?.uid).update({
      "status": state,
    });
  }


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child:isFetching ? Center(child: CircularProgressIndicator(),):userData!.isNotEmpty?Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        UserAccountsDrawerHeader(
                          accountName: Text(
                            '${userName}',
                            style: TextStyle(
                                color: app_color.black_color,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          accountEmail: Text(
                            '${userEmail}',
                            style: TextStyle(
                                color: app_color.black_color,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                          currentAccountPicture:  ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: CachedNetworkImage(
                              imageUrl: "$userImage",
                              placeholder: (context, url) => const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                              errorWidget: (context, url, error) =>
                              const Icon(Icons.image, size: 70),
                            ),
                          ),
                        ),
                      ]
                      ) ,

                  ],
                ),
                Positioned(
                    top: 5,
                    right: 5,
                    child: InkWell(
                      onTap: () {},
                      child: Icon(Icons.close_outlined,
                          color: app_color.black_color),
                    )),
              ],
            ),
          ),
          SizedBox(
            height: 450,
          ),
          TextButton(
              onPressed: () async {
                signout(context);
                setStatus('offline');
              },
              child: Text(
                'Logout',
                style: TextStyle(
                    color: app_color.black_color,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ))
        ],
      ):Center(
        child: Text(
          'No Data Found',
          style: text_style.high_text,
        ),
      ),
    );
  }
}

