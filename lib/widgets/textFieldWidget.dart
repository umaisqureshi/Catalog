import 'package:category/utils/constant.dart';
import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final String hintText;
  final Widget prefixIcon;
  final  keyboardType;
  final Widget sufixIcon;
  final TextEditingController controller;


  TextFieldWidget(
      {this.hintText,
        this.keyboardType,
        this.sufixIcon,
      this.prefixIcon,
      this.controller,

      });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: TextFormField(
          keyboardType: keyboardType,
          controller: controller,

          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            hintText: hintText,
            hintStyle: TextStyle(fontSize: 9,fontWeight: FontWeight.bold,color: Colors.black,fontFamily: "Yu Gothic UI"),
            prefixIcon: prefixIcon,
            suffixIcon: sufixIcon,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: primary,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: primary,
                width: 2,
              ),
            ),
          ),
        ));
  }
}
