import 'package:firebase_authentication/utils/app_color.dart';
import 'package:flutter/material.dart';

class button extends StatelessWidget {
  button({this.name, this.onTap});

  late String? name;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          color: app_color.button_color,
        ),
        child: Center(
            child: Text(
              name!,
              style: TextStyle(
                  color: app_color.white_color,
                  fontSize: MediaQuery.of(context).size.height / 30,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold),
            )),
      ),
    );
  }
}