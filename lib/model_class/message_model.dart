import 'dart:convert';

messageDataModel userdataFromJson(String str) => messageDataModel.fromJson(json.decode(str));

String userdataToJson(messageDataModel data) => json.encode(data.toJson());

class messageDataModel {
  messageDataModel({
    this.messageid,
    this.message,
  });

  String? messageid;
  String? message;



  factory messageDataModel.fromJson(Map<String, dynamic> json) => messageDataModel(
    messageid: json["messageID"],
    message: json["Message"],

  );

  Map<String, dynamic> toJson() => {
    "messageID": messageid,
    "Message": message,
  };
}
