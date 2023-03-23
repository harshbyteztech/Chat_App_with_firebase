import 'dart:convert';

group_model userdataFromJson(String str) => group_model.fromJson(json.decode(str));

String userdataToJson(group_model data) => json.encode(data.toJson());

class group_model {
  group_model({
    this.groupId,
    this.group_image,
    this.group_name
  });
  String? groupId;
  String? group_image;
  String? group_name;

  factory group_model.fromJson(Map<String, dynamic> json) => group_model(
    groupId: json["groupid"],
    group_image: json["groupImage"],
    group_name:  json["groupname"],
  );

  Map<String, dynamic> toJson() => {
    "groupid": groupId,
    "groupImage": group_image,
    "groupname":group_name,
  };
}
