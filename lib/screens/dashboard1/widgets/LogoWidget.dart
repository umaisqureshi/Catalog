import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {

  final double scale;
  LogoWidget({this.scale});

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/logo.png',scale: scale,);
  }
}
