import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

user_token_model userdataFromJson(String str) => user_token_model.fromJson(json.decode(str));

String userdataToJson(user_token_model data) => json.encode(data.toJson());

class user_token_model {
  user_token_model({
    this.token,
  });

  String? token;



  factory user_token_model.fromJson(Map<String, dynamic> json) => user_token_model(
    token: json["token"],

  );

  Map<String, dynamic> toJson() => {
    "token": token,
  };
}
