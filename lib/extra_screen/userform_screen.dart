import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/utils/text_style.dart';
import 'package:firebase_authentication/widget/button_widget.dart';
import 'package:firebase_authentication/widget/textform_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class userform extends StatefulWidget {
  @override
  State<userform> createState() => _userformState();
}

class _userformState extends State<userform> {
  final _formkey = GlobalKey<FormState>();
  late TextEditingController firstname = TextEditingController();
  late TextEditingController lastname = TextEditingController();
  late TextEditingController nickname = TextEditingController();
  late TextEditingController mobilenumber = TextEditingController();
  late TextEditingController birthdata = TextEditingController();
  late TextEditingController studentemail = TextEditingController();
  late TextEditingController schoolname = TextEditingController();
  var gender = TextEditingController();
  final auth = FirebaseAuth.instance;
  final database = FirebaseFirestore.instance;
  late String userid = auth.currentUser!.uid;
   File? file;
   bool picture = false;
  String url = '';
  ImagePicker image = ImagePicker();
  List data = [];
  bool isFetching = false;



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

  get_image() async {
    final img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(img!.path);
      picture = true;
    });
  }

  StudentRegister() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        isFetching = true;
      });
      String path = DateTime.now().millisecond.toString();
      var imageFile = FirebaseStorage.instance.ref().child(path).child('/.jpg');
      UploadTask task = imageFile.putFile(file!);
      TaskSnapshot snapshot = await task;
      url = await snapshot.ref.getDownloadURL();
      final stundent = database.collection('students').doc().id;
      await database.collection('students').doc(stundent).set({
        'Firstname': firstname.text,
        'Lastname': lastname.text,
        'Nickname': nickname.text,
        'Mobilenumber': mobilenumber.text,
        'Birthdata': birthdata.text,
        'Studentemail': studentemail.text,
        'Schoolname': schoolname.text,
        'Gender': gender.text,
        'Image_url': url,
        'UserID': userid,
        'StudentId': stundent,
      });
      clean_data();
      setState(() {
        isFetching = false;
        picture = false;
      });
      Get.snackbar("Successfully", 'Student is registered',
          colorText: Colors.black, backgroundColor: Colors.green);

    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                height: 5,
              ),
              InkWell(
                onTap: () => get_image(),
                child: picture ?
                CircleAvatar(
                  backgroundImage: FileImage(file!),
                  radius: 50,
                  backgroundColor: null,
                ):
                const CircleAvatar(
                  radius: 50,
                  child: Center(child: Icon(
                    Icons.camera_alt,
                    size: 40,
                  ),),)

              ),
              Center(child: Text('SelectImage', style: text_style.high_text)),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 150,
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
                    width: 150,
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
                  readonly: true,
                  onTap: () async {
                    DateTime pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100)) as DateTime;
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
                mainAxisAlignment: MainAxisAlignment.center,
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
                  Row(
                    children: [
                      Expanded(
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
                      Expanded(
                          child: RadioListTile(
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
                      )),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              isFetching == true
                  ? const CircularProgressIndicator()
                  : button(
                      name: 'Submmit',
                      onTap: () {
                        StudentRegister();
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
