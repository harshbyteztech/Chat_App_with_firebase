import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/utils/app_color.dart';
import 'package:firebase_authentication/utils/app_text.dart';
import 'package:firebase_authentication/utils/text_style.dart';
import 'package:firebase_authentication/widget/login_signup_reset_method.dart';
import 'package:firebase_authentication/sharedpreferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../widget/button_widget.dart';
import '../widget/textform_widget.dart';
import 'dashboard-student/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var username = TextEditingController();
  var email = TextEditingController();
  var emailforgot = TextEditingController();
  var password = TextEditingController();
  final _loginkey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  File? file;

  // bool index = true;
  bool forgot = true;
  bool isFetching = false;
  String url = '';
  ImagePicker image = ImagePicker();

  get shared => null;

  // ignore: non_constant_identifier_names
  clean_data() {
    email.clear();
    password.clear();
    text_style.index == false ? username.clear() : null;
    forgot == false ? emailforgot.clear() : null;
    file = null;
  }

  login(context) async {
    setState(() {
      isFetching = true;
    });
    if (_loginkey.currentState!.validate()) {}
    method.login(context, email, password);
    setState(() {
      isFetching = false;
    });
  }

  signup(context) async {
    setState(() {
      isFetching = true;
    });
    String path = DateTime.now().millisecondsSinceEpoch.toString();
    var imageFile = FirebaseStorage.instance.ref().child(path).child('/.jpg');
    UploadTask task = imageFile.putFile(file!);
    TaskSnapshot snapshot = await task;
    url = await snapshot.ref.getDownloadURL();
    if (_loginkey.currentState!.validate()) {}
    method.signup(
      email: email.text,
      password: password.text,
      username: username.text,
      url: url,
    );
    setState(() {
      text_style.index = false;
      isFetching = false;
    });
  }

  Forgot(context) async {
    setState(() {
    isFetching = true;
    });
    if (_loginkey.currentState!.validate()) {}
    method.forgot(context, email.text);
    clean_data();
    setState(() {
      isFetching = false;
    });
  }

  get_image() async {
    final img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(img!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _loginkey,
      autovalidateMode: AutovalidateMode.always,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/background.jpg'),
                  fit: BoxFit.cover)),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Center(
                child: Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: theme.containershadowB,
                      color: Colors.black26),
                  height: forgot
                      ? text_style.index == true
                          ? 550
                          : 445
                      : 330,
                  width: 600,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 10.0, right: 10.0, top: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                              forgot
                                  ? text_style.index == true
                                      ? app_Text.signupButton.toUpperCase()
                                      : app_Text.loginButton.toUpperCase()
                                  : app_Text.forget,
                              style: TextStyle(
                                  color: app_color.white_color, fontSize: 40)),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        text_style.index == true
                            ? Center(
                                child: InkWell(
                                    onTap: () {
                                      get_image();
                                    },
                                    child: CircleAvatar(
                                      radius: 40,
                                      backgroundImage: file == null
                                          ? null
                                          : FileImage(File(file!.path)),
                                      child: file == null
                                          ? const Icon(
                                              Icons.camera_alt,
                                              size: 30,
                                            )
                                          : null,
                                    )),
                              )
                            : Container(),
                        const SizedBox(
                          height: 15,
                        ),
                        text_style.index == true
                            ? Textfield(
                          iconcolor: app_color.black_color,
                                prefixIcon: Icons.person,
                                Hindtext: app_Text.userfield,
                                controller: username,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return app_Text.uservalidation;
                                  }
                                  return null;
                                },
                              )
                            : Container(),
                        const SizedBox(
                          height: 15,
                        ),
                        forgot
                            ? Textfield(
                          iconcolor: app_color.black_color,
                                prefixIcon: Icons.email_outlined,
                                Hindtext: app_Text.emailfield,
                                controller: email,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return app_Text.emailvalidation1;
                                  } else if (!RegExp('@').hasMatch(value)) {
                                    return app_Text.emailvalidation2;
                                  }
                                  return null;
                                },
                              )
                            : Textfield(
                          iconcolor: app_color.black_color,
                                prefixIcon: Icons.email_outlined,
                                Hindtext: app_Text.emailfield,
                                controller: emailforgot,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return app_Text.emailvalidation1;
                                  } else if (!RegExp('@').hasMatch(value)) {
                                    return app_Text.emailvalidation2;
                                  }
                                  return null;
                                },
                              ),
                        const SizedBox(
                          height: 15,
                        ),
                        forgot
                            ? Textfield(
                          iconcolor: app_color.black_color,
                                prefixIcon: Icons.key,
                                Hindtext: 'Password',
                                controller: password,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return app_Text.passwordvalidation1;
                                  } else if (value.length < 6) {
                                    return app_Text.passwordvalidation2;
                                  }
                                  return null;
                                },
                              )
                            : const SizedBox(),
                        SizedBox(
                          height: text_style.index == true ? 10 : 15,
                        ),
                        forgot
                            ? text_style.index == true
                                ? Container()
                                : TextButton(
                                    onPressed: () {
                                      setState(() {
                                        forgot = false;
                                      });
                                    },
                                    child: Text(
                                      app_Text.forget,
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              50,
                                          color: app_color.white_color,
                                          fontFamily: 'poppins'),
                                    ))
                            : const SizedBox(),
                        isFetching ==true
                            ? const Center(child: CircularProgressIndicator())
                            : button(
                                name: forgot
                                    ? text_style.index == true
                                        ? app_Text.signupButton.toUpperCase()
                                        : app_Text.loginButton.toUpperCase()
                                    : 'Reset'.toUpperCase(),
                                onTap: () {

                                  forgot
                                      ? text_style.index == true
                                          ? signup(context)
                                          : login(context)
                                      : Forgot(context);
                                  // clean_data();

                                },
                              ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                text_style.index == true
                                    ? app_Text.account
                                    : app_Text.noaccount,
                                style: TextStyle(
                                    fontFamily: 'poppins',
                                    fontSize:
                                        MediaQuery.of(context).size.height / 50,
                                    color: app_color.white_color)),
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    text_style.index == true
                                        ? text_style.index = false
                                        : text_style.index = true;
                                    forgot = true;
                                    clean_data();
                                  });
                                },
                                child: Text(
                                  text_style.index == true
                                      ? app_Text.loginButton
                                      : app_Text.signupButton,
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height /
                                              50,
                                      color: const Color(0XffFEA53F),
                                      fontFamily: 'poppins'),
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
