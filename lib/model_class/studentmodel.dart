import 'dart:convert';

Studentdata userdataFromJson(String str) => Studentdata.fromJson(json.decode(str));

String userdataToJson(Studentdata data) => json.encode(data.toJson());

class Studentdata {
  Studentdata({
    this.userId,
    this.studentId,
    this.firstname,
    this.lastname,
    this.nickname,
    this.image,
    this.studentemail,
    this.schoolname,
    this.birthdata,
    this.gender,
    this.number
  });

  String? userId;
  String? studentId;
  String? firstname;
  String? lastname;
  String? nickname;
  String? image;
  String? studentemail;
  String? schoolname;
  String? birthdata;
  String? gender;
  String? number;

  factory Studentdata.fromJson(Map<String, dynamic> json) => Studentdata(
    userId: json["UserID"],
    studentId: json["StudentId"],
    firstname: json["Firstname"],
    lastname: json["Lastname"],
    nickname: json["Nickname"],
    image: json["Image_url"],
    studentemail: json["Studentemail"],
    schoolname: json["Schoolname"],
    birthdata: json["Birthdata"],
    gender: json["Gender"],
    number:json["Mobilenumber"],
  );

  Map<String, dynamic> toJson() => {
    "UserID": userId,
    "StudentId": studentId,
    "Firstname": firstname,
    "Lastname": lastname,
    "Nickname": nickname,
    "Image_url": image,
    "Studentemail": studentemail,
    "Schoolname": schoolname,
    "Birthdata": birthdata,
    "Gender": gender,
    "Mobilenumber":number,
  };
}
