import 'package:flutter/material.dart';

class TopBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        child: Image.asset('assets/images/topBar.png',color: Color(0xFFb58563),));
  }
}
