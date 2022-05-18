import 'package:category/utils/constant.dart';
import 'package:flutter/material.dart';

class RoundedButtonWidget extends StatelessWidget {
  final Function function;

  RoundedButtonWidget({this.function});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        height: 20,
        width: 20,
        decoration: BoxDecoration(
            color: Color(0xFFb58563), borderRadius: BorderRadius.circular(100)),
        child: Center(
          child: Icon(
            Icons.arrow_forward_ios_rounded,
            color: white,
            size: 13,
          ),
        ),
      ),
    );
  }
}
