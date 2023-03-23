import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/model_class/studentmodel.dart';
import 'package:firebase_authentication/service/service.dart';
import 'package:firebase_authentication/utils/text_style.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'button_widget.dart';
import 'radio-button.dart';
import 'textform_widget.dart';

class update_field extends StatefulWidget {
  update_field({this.studentdata});

  Studentdata? studentdata;

  @override
  State<update_field> createState() => _update_fieldState();
}

class _update_fieldState extends State<update_field> {
  final _formkey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  final storeinstance = FirebaseFirestore.instance;
  late TextEditingController firstname =
      TextEditingController(text: widget.studentdata!.firstname);
  late TextEditingController lastname =
      TextEditingController(text: widget.studentdata!.lastname);
  late TextEditingController nickname =
      TextEditingController(text: widget.studentdata!.nickname);
  late TextEditingController mobilenumber =
      TextEditingController(text: widget.studentdata!.number);
  late TextEditingController birthdata =
      TextEditingController(text: widget.studentdata!.birthdata);
  late TextEditingController studentemail =
      TextEditingController(text: widget.studentdata!.studentemail);
  late TextEditingController schoolname =
      TextEditingController(text: widget.studentdata!.schoolname);
  bool isFetching = false;
  late TextEditingController gender = TextEditingController(text: widget.studentdata!.gender);
  File? file;
  bool picture = false;
  String url = '';
  ImagePicker image = ImagePicker();
  List<Studentdata>? studentData;
  int selectedindex = 0;

  _onTapped(int index) {
    setState(() {
      selectedindex = index;
    });
  }

  get_image() async {
    final img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(img!.path);
      picture = true;
    });
  }

  clean_data() {
    firstname.clear();
    lastname.clear();
    nickname.clear();
    mobilenumber.clear();
    birthdata.clear();
    studentemail.clear();
    schoolname.clear();
    gender.clear();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    birthdata.text = '';
  }

  update() async {
    setState(() {
      isFetching = true;
    });
    String path = DateTime.now().millisecond.toString();
    var imageFile = FirebaseStorage.instance.ref().child(path).child('/.jpg');
    UploadTask task = imageFile.putFile(file!);
    TaskSnapshot snapshot = await task;
    url = await snapshot.ref.getDownloadURL();
    studentdataupdate(
      widget.studentdata!.studentId,
      {
        'Firstname': firstname.text,
        'Lastname': lastname.text,
        'Nickname': nickname.text,
        'Mobilenumber': mobilenumber.text,
        'Studentemail': studentemail.text,
        'Schoolname': schoolname.text,
        'Image_url': url,
        'Gender':gender.text,
      },
    );
    setState(() {
      isFetching = false;
    });
    Get.back();
    Get.snackbar(
      'Update',
      '${widget.studentdata!.firstname}',
      backgroundColor: Colors.green,
      animationDuration: const Duration(seconds: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isFetching == true
        ? Center(child: const CircularProgressIndicator())
        : SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: AlertDialog(
              title: const Text("Update"),
              actions: [
                Form(
                  key: _formkey,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        InkWell(
                            onTap: () => get_image(),
                            child: picture
                                ? CircleAvatar(
                                    backgroundImage: FileImage(file!),
                                    radius: 50,
                                    backgroundColor: null,
                                  )
                                : CircleAvatar(
                                    radius: 50,
                                    backgroundImage: NetworkImage(
                                        '${widget.studentdata!.image}'),
                                  )),
                        Center(
                            child: Text('SelectImage',
                                style: text_style.high_text)),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 100,
                              child: Textfield(
                                controller: firstname,
                                icon: true,
                                Hindtext: 'Firstname',
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter firstname';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              child: Textfield(
                                controller: lastname,
                                icon: true,
                                Hindtext: 'Lastname',
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter lastname';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Textfield(
                          controller: nickname,
                          Hindtext: 'Nickname',
                          prefixIcon: Icons.person,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter nickname';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Textfield(
                            controller: mobilenumber,
                            Hindtext: 'Mobilenumber',
                            prefixIcon: Icons.call,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter mobilenumber';
                              } else if (value.length < 10) {
                                return 'Please enter valid number';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number),
                        const SizedBox(
                          height: 20,
                        ),
                        Textfield(
                            controller: birthdata,
                            Hindtext: 'Enter birthdata',
                            // readonly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100)) ;
                              if (pickedDate != null) {
                                String formattedDate =
                                    DateFormat('dd-MM-yyyy').format(pickedDate);
                                setState(() {
                                  birthdata.text = formattedDate;
                                });
                              } else {
                                print("Date is not selected");
                              }
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter birthdate';
                              }
                              return null;
                            },
                            prefixIcon: Icons.calendar_month),
                        const SizedBox(
                          height: 20,
                        ),
                        Textfield(
                            controller: studentemail,
                            Hindtext: 'Student email',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter email';
                              } else if (!RegExp('@').hasMatch(value)) {
                                return 'Please enter valid email';
                              }
                              return null;
                            },
                            prefixIcon: Icons.email),
                        const SizedBox(
                          height: 20,
                        ),
                        Textfield(
                          controller: schoolname,
                          Hindtext: 'School name',
                          icon: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter schoolname';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Gender',
                              style: TextStyle(
                                color: Color(0XffA1A1A9),
                                fontSize: 20,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                            //   children: [
                            //     RadioButton(
                            //       name: 'Male',
                            //       circle: selectedindex == 0 ? false : true,
                            //       onTap: () {
                            //         setState(() {
                            //           _onTapped(0);
                            //         });
                            //       },
                            //     ),
                            //     RadioButton(
                            //         name: 'Female',
                            //         onTap: () {
                            //           setState(() {
                            //             _onTapped(1);
                            //           });
                            //         },
                            //         circle: selectedindex == 1 ? false : true)
                            //   ],
                            // ),
                            Container(
                              child: RadioListTile(
                                dense: true,
                                selected: true,
                                title: Text(
                                  'Female',
                                  style: text_style.high_text,
                                ),
                                value: 'Female',
                                groupValue: gender.text,
                                onChanged: (value) {
                                  setState(() {
                                    gender.text = value.toString();
                                    print(gender.text);
                                  });
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 15),
                              child: RadioListTile(
                                selected: true,
                                contentPadding: const EdgeInsets.all(0.1),
                                title: Text(
                                  'Male',
                                  style: text_style.high_text,
                                ),
                                value: 'Male',
                                groupValue: gender.text,
                                onChanged: (value) => setState(() {
                                  gender.text = value.toString();
                                  print(gender.text);
                                }),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        button(
                            name: 'Submmit',
                            onTap: () async {
                              update();
                            }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
