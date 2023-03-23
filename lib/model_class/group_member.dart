// To parse this JSON data, do
//
//     final groupMemberModel = groupMemberModelFromJson(jsonString);

import 'dart:convert';

GroupMemberModel groupMemberModelFromJson(String str) => GroupMemberModel.fromJson(json.decode(str));

String groupMemberModelToJson(GroupMemberModel data) => json.encode(data.toJson());

class GroupMemberModel {
  GroupMemberModel({
    this.groupId,
    this.groupName,
    this.members,
  });

  String? groupId;
  String? groupName;
  List<Member>? members;

  factory GroupMemberModel.fromJson(Map<String, dynamic> json) => GroupMemberModel(
    groupId: json["groupId"],
    groupName: json["groupName"],
    members: json["members"] == null ? [] : List<Member>.from(json["members"]!.map((x) => Member.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "groupId": groupId,
    "groupName": groupName,
    "members": members == null ? [] : List<dynamic>.from(members!.map((x) => x.toJson())),
  };
}

class Member {
  Member({
    this.memberEmail,
    this.memberName,
    this.memberImage,
    this.memberUid,
  });

  String? memberEmail;
  String? memberName;
  String? memberImage;
  String? memberUid;

  factory Member.fromJson(Map<String, dynamic> json) => Member(
    memberEmail: json["email"],
    memberName: json["name"],
    memberImage: json["image"],
    memberUid: json["uid"],
  );

  Map<String, dynamic> toJson() => {
    "email": memberEmail,
    "name": memberName,
    "image": memberImage,
    "uid": memberUid,
  };
}
