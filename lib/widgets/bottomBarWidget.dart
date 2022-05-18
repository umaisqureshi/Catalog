import 'package:flutter/material.dart';

class BottomBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        child: Image.asset('assets/images/bottomBar.png',color: Color(0xFFb58563),));
  }
}
