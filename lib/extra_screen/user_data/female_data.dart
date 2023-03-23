import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/service/service.dart';
import 'package:firebase_authentication/utils/app_color.dart';
import 'package:firebase_authentication/utils/text_style.dart';
import 'package:firebase_authentication/widget/list-tile.dart';
import 'package:firebase_authentication/widget/update_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model_class/studentmodel.dart';

class female_data extends StatefulWidget {
  @override
  State<female_data> createState() => _female_dataState();
}

class _female_dataState extends State<female_data> {
  final auth = FirebaseAuth.instance;
  final storeinstance = FirebaseFirestore.instance;
  bool isFetching = false, Loading = false;
  List<Studentdata>? studentData;

  final database = FirebaseFirestore.instance;
  late String userid = auth.currentUser!.uid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get();
  }

  get() async {
    setState(() {
      isFetching = true;
    });
    studentData = await femaleStudentData();
    setState(() {
      isFetching = false;
      Loading = true;
    });
  }

  delete(
    String? id,
    String? document,
  ) {
    studentdatadelete(id);
    Get.snackbar('Delete', '${document}',
        backgroundColor: Colors.red,
        animationDuration: const Duration(seconds: 1),
        snackPosition: SnackPosition.BOTTOM);
    get();
  }

  Update() {
    setState(() {
      text_style.selectedIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isFetching == true
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : studentData!.isNotEmpty
            ? Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: List.generate(studentData!.length, (index){
            var data = studentData![index];
            return InkWell(
              onTap: (){},
              child: Container(
                margin: const EdgeInsets.all(8.0),
                height: 70,
                child: Stack(
                  children: [
                    Row(
                      children: [
                        Loading ?
                        data.image!.isEmpty
                            ? const Center(child: CircularProgressIndicator())
                            : CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage('${data.image}'),
                        ):const Center(child: CircularProgressIndicator()),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Studentname:-',
                                  style: TextStyle(
                                      fontSize: 18, color:app_color.white_color,fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${data.firstname} ${data.lastname}',
                                  style:  TextStyle(
                                      fontSize: 15, color: app_color.white_color),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Email:-',
                                  style: TextStyle(
                                      fontSize: 18, color: app_color.white_color,fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${data.studentemail}',
                                  style:  TextStyle(
                                      fontSize: 15, color: app_color.white_color),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Gender :-',
                                  style:TextStyle(
                                      fontSize: 18, color: app_color.white_color,fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "${data.gender}",
                                  style:  TextStyle(
                                      fontSize: 15, color:app_color.white_color),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                    Positioned(
                        right: 0,
                        bottom: 0,
                        child:
                        Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(onPressed: (){
                                  delete(data.studentId, data.firstname);
                                }, icon:  Icon(Icons.delete,color: app_color.white_color)),
                                Text('Delete',style: TextStyle(color: app_color.white_color))
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(onPressed: (){
                                }, icon:  Icon(Icons.add,color: app_color.white_color,)),
                                Text('Follow',style: TextStyle(color: app_color.white_color),)
                              ],
                            ),

                          ],
                        )

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
    //   StreamBuilder(
    //   stream: storeinstance
    //       .collection('students')
    //       .where('UserID', isEqualTo: auth.currentUser!.uid)
    //       .snapshots(),
    //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    //     if (snapshot.hasData) {
    //       return ListView(
    //         children: snapshot.data!.docs.map((document) {
    //           Map<String, dynamic> data =
    //           document.data() as Map<String, dynamic>;
    //           var id = document.id;
    //           return Padding(
    //               padding: const EdgeInsets.all(10.0),
    //           child: Column(
    //           children: List.generate(studentData!.length, (index){
    //             var data = studentData![index];
    //           return Container(
    //             height: 70,
    //             child: Stack(
    //               children: [
    //                 Row(
    //                   children: [
    //                     document['Image_url'] == null
    //                         ? const Center(child: CircularProgressIndicator())
    //                         : CircleAvatar(
    //                       radius: 40,
    //                       backgroundImage:
    //                       NetworkImage('${data.image}'),
    //                     ),
    //                     const SizedBox(
    //                       width: 20,
    //                     ),
    //                     Column(
    //                       mainAxisAlignment: MainAxisAlignment.spaceAround,
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         Row(
    //                           children: [
    //                             const Text(
    //                               'Studentname:-',
    //                               style: TextStyle(
    //                                   fontSize: 18, color: Colors.black54),
    //                             ),
    //                             Text(
    //                               '${data.firstname} ${data.lastname}',
    //                               style: const TextStyle(
    //                                   fontSize: 15, color: Colors.black87),
    //                             ),
    //                           ],
    //                         ),
    //                         Row(
    //                           children: [
    //                             const Text(
    //                               'Email:-',
    //                               style: TextStyle(
    //                                   fontSize: 18, color: Colors.black54),
    //                             ),
    //                             Text(
    //                               '${data.studentemail}',
    //                               style: const TextStyle(
    //                                   fontSize: 15, color: Colors.black87),
    //                             ),
    //                           ],
    //                         ),
    //                         Row(
    //                           mainAxisAlignment: MainAxisAlignment.start,
    //                           crossAxisAlignment: CrossAxisAlignment.start,
    //                           children: [
    //                             const Text(
    //                               'Gender :-',
    //                               style: TextStyle(
    //                                   fontSize: 18, color: Colors.black54),
    //                             ),
    //                             Text(
    //                               "${data.gender}",
    //                               style: const TextStyle(
    //                                   fontSize: 15, color: Colors.black87),
    //                             ),
    //                           ],
    //                         )
    //                       ],
    //                     ),
    //                   ],
    //                 ),
    //                 Positioned(
    //                   top: 0,
    //                   right: 5,
    //                   child: PopupMenuButton(itemBuilder: (context) {
    //                     return List.generate(2, (index) {
    //                       return PopupMenuItem(
    //                           value: index,
    //                           child: index == 0
    //                               ? const Text('Update')
    //                               : const Text('Delete'),
    //                           onTap: () {
    //                             index == 0
    //                                 ? print('Update')
    //                                 : delete(data.studentId, data.firstname);
    //                           });
    //                     });
    //                   }),
    //                 ),
    //               ],
    //             ),
    //           );
    //           },
    //           ),
    //           ));
    //         }).toList(),
    //       );
    //     } else {
    //       return const Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     }
    //   },
    // );
  }
}
