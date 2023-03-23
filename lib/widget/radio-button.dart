import 'package:flutter/material.dart';

class RadioButton extends StatelessWidget {
  RadioButton({this.onTap, required this.circle, this.name,});


  final GestureTapCallback? onTap;
  late String? name;
  late bool circle;


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 20,
            width: 20,
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black,width: 2),
                color: Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(10),
                )),
            child: circle == false ? CircleAvatar(backgroundColor: Colors.black) : null,
          ),
          SizedBox(width: 10,),
          Text('$name',style: TextStyle(fontSize: 23,color: Colors.black),)
        ],
      ),
    );
  }
}
