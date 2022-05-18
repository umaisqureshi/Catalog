import 'package:category/utils/constant.dart';
import 'package:category/widgets/textWidget.dart';
import 'package:flutter/material.dart';

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
            size: 17,
          ),
          TextWidget(
            text: 'Back',
            textSize: 14,
            textColor: primary,
            isBold: true
          )
        ],
      ),
    );
  }
}
