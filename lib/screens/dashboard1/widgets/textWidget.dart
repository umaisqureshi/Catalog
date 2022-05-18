import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final Color textColor;
  final double textSize;
  final bool isBold;
  final String fontFamily;

  TextWidget({this.textColor, this.text, this.textSize, this.isBold = false,this.fontFamily});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: textColor,
        fontSize: textSize,
        fontFamily: fontFamily,
        fontWeight: isBold ? FontWeight.w500 : FontWeight.normal,
      ),
    );
  }
}
