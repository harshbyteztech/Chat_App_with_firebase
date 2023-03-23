import 'package:flutter/material.dart';

class app_color {
  static final text_color = Color(0XffA1A1A9);
  static final button_color = Colors.blue.shade300;
  static final white_color = Colors.white;
  static final black_color = Colors.black;
}

class theme {
  static const containershadowB = [
    BoxShadow(
      color: Colors.black26,
      offset: Offset(0, 3),
      blurRadius: 6,
      spreadRadius: 4,
    )
  ];
  static const containershadowW = [
    BoxShadow(
      color: Colors.white,
      offset: Offset(0, 12),
      blurRadius: 20,
      spreadRadius: 4,
    )
  ];
}
