import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/model_class/chatmodel.dart';
import 'package:firebase_authentication/widget/format_time.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Screens/dashboard-student/chat_room_screen/message_screen.dart';
import '../main.dart';
import '../model_class/messsage_user_model.dart';
import '../service/service.dart';

//card to represent a single user in home screen
class ChatUserCard extends StatefulWidget {
  final messageUserModel user;

  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  //last message info (if null --> no message)

  final auth = FirebaseAuth.instance;
  final storeinstance = FirebaseFirestore.instance;
  MessageModel? _message;

  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * .02, vertical: 4),
      // color: Colors.blue.shade100,
      elevation: 0.5,
      color: Colors.grey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
          onTap: () {
            //for navigating to chat screen
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => message_screen(
                          messageUser: widget.user,
                        )));
          },
          child: StreamBuilder(stream: getLastMessage(widget.user.room_id), builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => MessageModel.fromMap(e.data())).toList() ?? [];
              if (list.isNotEmpty) _message = list[0];

              return ListTile(
                //user profile picture
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * .03),
                  child: CachedNetworkImage(
                    width: mq.height * .055,
                    height: mq.height * .055,
                    imageUrl: "${widget.user.profile}",
                    errorWidget: (context, url, error) =>
                        const CircleAvatar(child: Icon(CupertinoIcons.person)),
                  ),
                ),

                //user name
                title: Text("${widget.user.target_username}"),

                //last message
                subtitle: Text(
                    "${_message != null ? _message!.type == "img" ? 'image' : _message!.message : ''}",
                    maxLines: 1,style: TextStyle(color: Colors.black)),

                //last message time
                trailing: _message == null
                    ? null //show nothing when no message is sent
                    : _message!.read!.isEmpty &&
                            _message!.sendby != auth.currentUser?.uid
                        ?
                        //show for unread message
                        Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                                color: Colors.greenAccent.shade400,
                                borderRadius: BorderRadius.circular(10)),
                          )
                        :
                        //message sent time
                        Text(
                            '${set_time.format_time(context: context, time: "${_message?.sent}")}',
                            style: const TextStyle(color: Colors.black54),
                          ),
              );
            },
          )),
    );
  }
}
