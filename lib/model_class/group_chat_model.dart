class group_chat_model {
  String? messsageid;
  String? sendby;
  String? time;
  String? type;
  String? message;


  group_chat_model({this.messsageid, this.sendby,this.message,this.type,this.time});

  group_chat_model.fromMap(Map<String, dynamic> map) {
    messsageid = map["messageid"];
    sendby = map["sendby"];
    message = map["message"];
    type=map["type"];
    time = map['time'];
  }

  Map<String, dynamic> toMap() {
    return {
      "messageid": messsageid,
      "sendby": sendby,
      "profile": message,
      "type":type,
      "time":time,
    };
  }
}
