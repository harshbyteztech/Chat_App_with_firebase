import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/model_class/group_chat_model.dart';
import 'package:firebase_authentication/model_class/group_model.dart';
import 'package:firebase_authentication/model_class/message_model.dart';
import 'package:firebase_authentication/model_class/messsage_user_model.dart';
import 'package:firebase_authentication/model_class/user_token_model.dart';
import 'package:firebase_authentication/widget/login_signup_reset_method.dart';
import 'package:http/http.dart' as http;
import '../model_class/chatmodel.dart';
import '../model_class/group_member.dart';
import '../model_class/studentmodel.dart';
import '../model_class/usermodel.dart';

final auth = FirebaseAuth.instance;
final Storeinstance = FirebaseFirestore.instance;
List Memberlist = [];

Future<List<Userdata>?> Userdataget() async {
  QuerySnapshot<Map<String, dynamic>> snapshot =
      await Storeinstance.collection('User')
          .where('authId', isNotEqualTo: auth.currentUser!.uid)
          .get();
  return snapshot.docs
      .map((document) => Userdata.fromJson(document.data()))
      .toList();
}

Future<List<Userdata>?> currentUserdataget() async {
  QuerySnapshot<Map<String, dynamic>> snapshot =
      await Storeinstance.collection('User')
          .where('authId', isEqualTo: auth.currentUser!.uid)
          .get();
  return snapshot.docs
      .map((document) => Userdata.fromJson(document.data()))
      .toList();
}

Future<List<Studentdata>?> ChatUserdatadelete(String? id,) async {
  DocumentReference snapshot = Storeinstance.collection('User')
      .doc(auth.currentUser!.uid)
      .collection("chatroom")
      .doc(id);
  await snapshot.delete();
  print('Successfully Student data updata');
}

Future<List<Studentdata>?> userdatadelete() async {
  DocumentReference snapshot =
      Storeinstance.collection('User').doc(auth.currentUser!.uid);
  await snapshot.delete();
  print(' Successfully Student data delete');
}

// Future<List<Studentdata>?> userdataupdate(String? id, data,) async {DocumentReference snapshot =
//       Storeinstance.collection('User').doc(auth.currentUser!.uid);
//   await snapshot.update(data);
//   print('Successfully Student data updata');
// }

Future<List<Userdata>?> searchuserdata(String? search,) async {
  QuerySnapshot<Map<String, dynamic>> snapshot =
      await Storeinstance.collection('User')
          .where('Email', isEqualTo: search)
          .where('Email', isNotEqualTo: auth.currentUser!.email)
          .get();
  return snapshot.docs
      .map((document) => Userdata.fromJson(document.data()))
      .toList();
}

Future<List<Userdata>?> searchmemberdata(String? search,) async {
  QuerySnapshot<Map<String, dynamic>> snapshot =
      await Storeinstance.collection('User')
          .where('Email', isEqualTo: search)
          .where('Email', isNotEqualTo: auth.currentUser!.email)
          .get();
  return snapshot.docs
      .map((document) => Userdata.fromJson(document.data()))
      .toList();
}

Future<List<Studentdata>?> maleStudentData() async {
  QuerySnapshot<Map<String, dynamic>> snapshot =
      await Storeinstance.collection('students')
          .where('UserID', isEqualTo: auth.currentUser!.uid)
          .where('Gender', whereIn: ['Male']).get();
  return snapshot.docs
      .map((document) => Studentdata.fromJson(document.data()))
      .toList();
}

Future<List<Studentdata>?> femaleStudentData() async {
  QuerySnapshot<Map<String, dynamic>> snapshot =
      await Storeinstance.collection('students')
          .where('UserID', isEqualTo: auth.currentUser!.uid)
          .where('Gender', whereIn: ['Female']).get();
  return snapshot.docs
      .map((document) => Studentdata.fromJson(document.data()))
      .toList();
}

Future<List<Studentdata>?> studentdatadelete(String? id) async {
  DocumentReference snapshot = Storeinstance.collection('students').doc(id);
  await snapshot.delete();
  print(' Successfully Student data delete');
}

Future<List<Studentdata>?> studentdataupdate(String? id, data,) async {
  DocumentReference snapshot = Storeinstance.collection('students').doc(id);
  await snapshot.update(data);
  print('Successfully Student data updata');
}

Future<List<MessageModel>?> messageDataGet(roomid) async {
  QuerySnapshot<Map<String, dynamic>> snapshot =
      await Storeinstance.collection('chatroom')
          .doc(roomid)
          .collection('Message').orderBy('messageid',descending: true)
          .get();
  return snapshot.docs.map((e) => MessageModel.fromMap(e.data())).toList();
}

Future<List<messageUserModel>?> messageUserDataGet() async {
  QuerySnapshot<Map<String, dynamic>> snapshot =
      await Storeinstance.collection("User")
          .doc(auth.currentUser!.uid)
          .collection('chatroom')
          .get();
  print(snapshot);
  return snapshot.docs
      .map((document) => messageUserModel.fromJson(document.data()))
      .toList();
}

Future<List<MessageModel>?> messageDelete(String? Messageid, String? Roomid) async {
  DocumentReference snapshot = Storeinstance.collection('chatroom')
      .doc(Roomid)
      .collection('Message')
      .doc(Messageid);
  await snapshot.delete();
  print(' Successfully Student data delete');
}

Future<List<group_model>?> GroupDataGet() async {
  QuerySnapshot<Map<String, dynamic>> snapshot =
      await Storeinstance.collection('User')
          .doc(auth.currentUser!.uid)
          .collection("group")
          .get();
  print(snapshot);
  return snapshot.docs
      .map((document) => group_model.fromJson(document.data()))
      .toList();
}

// Future<List<Member>?> GroupMemberData(groupid) async {
//   QuerySnapshot<Map<String, dynamic>> snapshot =
//       await Storeinstance.collection('group')
//           .doc(groupid)
//           .get()
//           .then((value) => Memberlist = value["members"]);
//   print(snapshot);
//   return snapshot.docs
//       .map((document) => Member.fromJson(document.data()))
//       .toList();
// }

Future<List<group_chat_model>?> GroupMessageData(groupid) async {
  QuerySnapshot<Map<String, dynamic>> snapshot =
      await Storeinstance.collection('group')
          .doc(groupid)
          .collection('chats')
          .get();
  return snapshot.docs.map((e) => group_chat_model.fromMap(e.data())).toList();
}

Future<List<group_chat_model>?> groupmessageDelete(String? Messageid, String? groupid) async {
  DocumentReference snapshot = Storeinstance.collection('group')
      .doc(groupid)
      .collection('chats')
      .doc(Messageid);
  await snapshot.delete();
  print(' Successfully Student data delete');
  return null;
}

Future<user_token_model?>sendnotification(username,token, String msg) async {
  try{
    final body = {
      "to":token,
      "notification": {
        "title": username,
        "body": msg,
        "android_channel_id": "chats"
      }
    };
    // dfDZ88PWSqmfYTsEcWL05w:APA91bGTcCC3YTD4Vzg4rYyDba2uS2TLFuSCFeFukSyz_KHA14wNXGSyeyIspyUTc6DVCC6FW6p2stzFoQ5_IHPTRIxPYhGAKKqDRlhSL2BfyDRqFuDuzZe5nklwx1zbnR-hMM2VroNN
    var url = Uri.parse('https://fcm.googleapis.com/fcm/send');
    var response = await http.post(url, body: jsonEncode(body),
        headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader:
      "key=AAAAD4AuAbQ:APA91bH3zjRwr2Fq9RFBJjVvTb4-ivETZn312Bksp4erhQl-xe95u_j52yg1TEv86xUTO1Ev7IZmgcfy5PRiHyiBimLtmks6IsbmQJyrY0mBFv3T11ZnhPxF-zTKJfZMmJopMTS3TGm3"
    });
    log('Response status: ${response.statusCode}');
    log('Response body: ${response.body}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }
      catch(e){
    print("error $e");
      }
  return null;
}

Future<List<user_token_model>?> GetUserToken(uid) async {
  QuerySnapshot<Map<String, dynamic>> snapshot =
      await Storeinstance.collection('User')
          .doc(uid)
          .collection('token')
          .get();
  print(snapshot);
  return snapshot.docs
      .map((document) => user_token_model.fromJson(document.data()))
      .toList();
}

 Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
     roomid) {
return Storeinstance
    .collection('chatroom').doc(roomid).collection('Message')
    .orderBy('sent', descending: true)
    .limit(1)
    .snapshots();
}

Future<List<MessageModel>?> last_message(roomid) async {
QuerySnapshot<Map<String, dynamic>> snapshot =
await Storeinstance.collection('chatroom').doc(roomid).collection('Message')
      .orderBy('sent', descending: true)
      .limit(1).get();
print(snapshot);
return snapshot.docs
    .map((document) => MessageModel.fromMap(document.data()))
    .toList();

}
