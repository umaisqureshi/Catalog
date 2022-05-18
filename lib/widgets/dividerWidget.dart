import 'package:category/utils/constant.dart';
import 'package:flutter/material.dart';

class DividerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: grey,
        height: 2,
        margin: EdgeInsets.symmetric(vertical: 10),
        width: MediaQuery.of(context).size.width
    );
  }
}
