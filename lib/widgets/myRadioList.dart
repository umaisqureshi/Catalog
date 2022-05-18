import 'package:category/utils/constant.dart';
import 'package:flutter/material.dart';

class MyRadioListTile<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final String leading;
  final Widget title;
  final ValueChanged<T> onChanged;

  const MyRadioListTile({
    @required this.value,
    @required this.groupValue,
    @required this.onChanged,
    @required this.leading,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final title = this.title;
    return InkWell(
      onTap: () => onChanged(value),
      child: _customRadioButton
    );
  }

  Widget get _customRadioButton {
    final isSelected = value == groupValue;
    return Container(
      height: 60,
      margin: EdgeInsetsDirectional.only(start: 16, end: 16),
      color: isSelected ? Colors.brown[50] : null,
      child: Row(
        children: [
          Container(
            padding: EdgeInsetsDirectional.only(start: 5, end: 5),
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: isSelected ? Colors.brown[200] : null,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Image.asset(
              leading,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(width: 12),
          if (title != null) title,
        ],
      ),
    );
  }
}
