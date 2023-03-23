import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model_class/studentmodel.dart';
import '../service/service.dart';

class list_tile extends StatefulWidget {
   list_tile({this.get
});
   final get;
  @override
  State<list_tile> createState() => _list_tileState();
}


class _list_tileState extends State<list_tile> {

  final auth = FirebaseAuth.instance;
  final storeinstance = FirebaseFirestore.instance;
  bool isFetching = false, Loading = false;
  late List<Studentdata>? studentData;

  final database = FirebaseFirestore.instance;
  late String userid = auth.currentUser!.uid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  widget.get;
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
    widget.get;
  }
  @override
  Widget build(BuildContext context) {
    return  Padding(
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
                                }, icon:  Icon(Icons.edit,color: app_color.white_color,)),
                                Text('Update',style: TextStyle(color: app_color.white_color),)
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
        ));
  }
}
