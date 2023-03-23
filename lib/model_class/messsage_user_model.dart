import 'dart:convert';

messageUserModel userdataFromJson(String str) => messageUserModel.fromJson(json.decode(str));

String userdataToJson(messageUserModel data) => json.encode(data.toJson());

class messageUserModel {
  messageUserModel({
    this.email_target_user,
    this.profile,
    this.target_user_id,
    this.target_username,
    this.currant_Id,
    this.room_id,
    this.lastmessage,
  });

  String? email_target_user;
  String? profile;
  String? target_user_id;
  String? target_username;
  String? currant_Id;
  String? room_id;
  String? lastmessage;



  factory messageUserModel.fromJson(Map<String, dynamic> json) => messageUserModel(
    email_target_user: json["email_target_user"],
    profile: json["profile"],
    target_user_id: json["target_user_id"],
    target_username: json["target_username"],
    currant_Id: json["currant_Id"],
    room_id: json["room_id"],
    lastmessage: json["lastmessage"],

  );

  Map<String, dynamic> toJson() => {
    "email_target_user": email_target_user,
    "profile": profile,
    "target_user_id": target_user_id,
    "target_username": target_username,
    "currant_Id": currant_Id,
    "room_id": room_id,
    "lastmessage": lastmessage,
  };
}
