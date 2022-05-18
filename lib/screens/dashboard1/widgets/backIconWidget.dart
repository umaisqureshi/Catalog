import 'package:category/screens/dashboard1/widgets/textWidget.dart';
import 'package:flutter/material.dart';
import 'package:category/utils/constant.dart';

class BackIconWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Row(
        children: [
          Icon(
            Icons.arrow_back,
            color: primary,
            size: 22,
          ),
          TextWidget(
            text: 'Back',
            textSize: 14,
            textColor: primary,
            isBold: true
          ),
        ],
      ),
    );
  }
}
