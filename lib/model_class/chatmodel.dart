class MessageModel {
  String? messsageid;
  String? sendby;
  String? type;
  String? message;
  String? sent;
  String? read;
  String? sendto;


  MessageModel({this.messsageid, this.sendby,this.message,this.type,this.sent,this.read,this.sendto});

  MessageModel.fromMap(Map<String, dynamic> map) {
    messsageid = map["messageid"];
    sendby = map["sendby"];
    message = map["message"];
    type=map["type"];
    sent = map['sent'];
    read = map['read'];
    sendto = map['sendto'];
  }

  Map<String, dynamic> toMap() {
    return {
      "messageid": messsageid,
      "sendby": sendby,
      "profile": message,
      "type":type,
      "sent":sent,
      "read":read,
      "sendto":sendto,
    };
  }
}
