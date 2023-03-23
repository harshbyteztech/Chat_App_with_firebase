import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/model_class/usermodel.dart';
import 'package:firebase_authentication/sharedpreferences/shared_preferences.dart';
import 'package:firebase_authentication/utils/app_color.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../widget/textform_widget.dart';
import '../widget/button_widget.dart';
import '../screens/login_registor_screen.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late TextEditingController username = TextEditingController();
  late TextEditingController email = TextEditingController();
  late TextEditingController password = TextEditingController();
  final _loginkey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  final database = FirebaseFirestore.instance.collection('User');
  ImagePicker image = ImagePicker();
  File? file;
  String url = '';
  List<Userdata>? userData;

  clean_data() {
    username.clear();
    email.clear();
    password.clear();
  }

  get_image() async {
    final img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(img!.path);
    });
  }

  signup(context) async {
    if (_loginkey.currentState!.validate()) {
      try {
          // String path = DateTime.now().millisecondsSinceEpoch.toString();
          // var imageFile =
          // FirebaseStorage.instance.ref().child(path).child('/.jpg');
          // UploadTask task = imageFile.putFile(file!);
          // TaskSnapshot snapshot = await task;
          // url = await snapshot.ref.getDownloadURL();
        await auth.createUserWithEmailAndPassword(
            email: email.text, password: password.text);
          shared.save_email(email);
        await database.doc(auth.currentUser!.uid).set({
          'Username': username.text,
          'Email': email.text,
          'Password': password.text,
          'authId': auth.currentUser!.uid,
        });
        clean_data();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
        Get.snackbar("Welcome", 'Successfully registor',
            colorText: Colors.black, backgroundColor: Colors.green);}
      catch (e) {
        Get.snackbar("Error", 'Email is already login',
            colorText: Colors.black, backgroundColor: Colors.red);
        print(e);
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _loginkey,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 150),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Center(
                  child: Text('Register',
                      style: TextStyle(color: Color(0XffA1A1A9), fontSize: 40)),
                ),
                Image.network(
                  'https://img.freepik.com/premium-vector/registration-sign-up-user-interface-users-use-secure-login-password-collection-online_566886-2046.jpg?w=740',
                ),
                Textfield(
                  prefixIcon: Icons.person,
                  Hindtext: 'Username',
                  controller: username,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter username';
                    }
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                Textfield(
                  prefixIcon: Icons.email_outlined,
                  Hindtext: 'Email',
                  controller: email,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter email';
                    } else if (!RegExp('@').hasMatch(value)) {
                      return 'Please enter valid email';
                    }
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                Textfield(
                  prefixIcon: Icons.key,
                  Hindtext: 'Password',
                  controller: password,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'PLease enter password';
                    } else if (value.length < 6) {
                      return 'Too short';
                    }
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
                button(
                  name: "Registor".toUpperCase(),
                  onTap: () async {
                    signup(context);
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?",
                        style: TextStyle(
                            fontFamily: 'poppins',
                            fontSize: MediaQuery.of(context).size.height / 50,
                            color: const Color(0XffA1A1A9))),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.height / 50,
                              color: const Color(0XffFEA53F),
                              fontFamily: 'poppins'),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
