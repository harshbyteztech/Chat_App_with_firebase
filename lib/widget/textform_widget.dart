import 'package:firebase_authentication/utils/app_color.dart';
import 'package:flutter/material.dart';

class Textfield extends StatelessWidget {
  Textfield(
      { this.Hindtext,
        this.iconcolor,
        this.onTap,
        this.readonly,
        this.suffixIcon,
        this.autovalue,
        this.border,
        this.Border,
        this.keyboardType,this.prefixIcon,this.obscureText,this.icon, this.controller,this.validator,this.prefix});


  late String? Hindtext;
  final Color? iconcolor;
  late String? autovalue;
  late FormFieldValidator<String>? validator;
  late  IconData? prefixIcon;
  final Widget? prefix;

  final Widget? suffixIcon;
  late bool? obscureText,icon,readonly;
  late TextInputType? keyboardType;
  late TextEditingController? controller = TextEditingController();
  GestureTapCallback? onTap;
  final InputBorder? border;
  final InputBorder? Border;


  @override
  Widget build(BuildContext context) {
    return TextFormField(controller: controller,
      initialValue: autovalue,
      keyboardType: keyboardType,
      obscureText: obscureText == true ? true: false,
      validator: validator,
      onTap: onTap,
      style:  TextStyle(
        color: app_color.white_color,
        fontSize: 20,
        fontFamily: 'Poppins',
      ),
      readOnly: readonly == true ? true:false,
      decoration: InputDecoration(
        enabledBorder:border,
        border:Border ,
        hintStyle:  TextStyle(
          color:app_color.text_color,
          fontSize: 20,
          fontFamily: 'Poppins',
        ),
        suffixIcon:suffixIcon,
        hintText: Hindtext,
        prefix: icon == true ? SizedBox(width: 10,):null,
        prefixIcon: icon == true ? null:Icon(prefixIcon,color:iconcolor,),
      ),
    );
  }
}