import 'package:firebase_authentication/extra_screen/userform_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../utils/notification.dart';
import '../message_user_screen.dart';

class notifications extends StatefulWidget {
     const notifications({Key? key}) : super(key: key);

     @override
     State<notifications> createState() => _notificationsState();
   }

   class _notificationsState extends State<notifications> {
   NotificationApi notificationApi = NotificationApi();
@override
  void initState() {
  super.initState();
  listenNotification();
  notificationApi.initialiseNotification();

}
 void  listenNotification() =>
NotificationApi.onNotification.stream.listen(onClickedNotification);


   onClickedNotification(String? payload){
     if(payload !=null && payload.isNotEmpty){
       print("payload $payload");
  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>userform()));}
   }
     @override
     Widget build(BuildContext context) {
       return Scaffold(
    backgroundColor: Colors.black,
         body: Center(
           child:  Column(
             mainAxisAlignment: MainAxisAlignment.center,
             mainAxisSize: MainAxisSize.max,
             children: <Widget>[
                MaterialButton(
                 onPressed: () =>
                 notificationApi.sendNotification('Harsh', 'Are you ready come with me',"ghgh"),
                 child:  const Text('Show Notification With Sound',style: TextStyle(color: Colors.white)),
               ),
                const SizedBox(
                 height: 30.0,
               ),
                MaterialButton(
                 onPressed: () {
                   print('Done');
                   notificationApi.SecheduleNotification('Notification', "secheduleNotification",);},
                 child:  const Text('Show Notification Without Sound',style: TextStyle(color: Colors.white)),
               ),
                const SizedBox(
                 height: 30.0,
               ),
               MaterialButton(
                 onPressed: (){
                   print('Stop');
                   notificationApi.stopNotification();
                 },
                 child:  const Text('Show Notification With Default Sound',style: TextStyle(color: Colors.white)),
               ),
             ],
           ),
         ),
       );
     }

   }
