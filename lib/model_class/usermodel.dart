import 'dart:convert';

Userdata userdataFromJson(String str) => Userdata.fromJson(json.decode(str));

String userdataToJson(Userdata data) => json.encode(data.toJson());

class Userdata {
  Userdata({
    this.email,
    this.password,
    this.userId,
    this.username,
    this.profileImage,
    this.status,
    this.lastMessage,
    this.token
  });

  String? email;
  String? password;
  String? userId;
  String? username;
  String? profileImage;
  String? status;
  String? lastMessage;
  String? token;

  factory Userdata.fromJson(Map<String, dynamic> json) => Userdata(
    email: json["Email"],
    password: json["Password"],
    userId: json["authId"],
    username: json["Username"],
   profileImage:  json["profile"],
    status:  json["status"],
      lastMessage:json["lastMessage"],
    token:json["token"],
  );

  Map<String, dynamic> toJson() => {
    "Email": email,
    "Password": password,
    "authId": userId,
    "Username": username,
    "profile":profileImage,
    "status":status,
    "lastMessage":lastMessage,
    "token":token
  };
}
