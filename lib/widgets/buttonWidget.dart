import 'package:flutter/material.dart';

class ButtonWidget extends StatefulWidget {
  final Function function;
  final buttonColor;
  final double buttonHeight, buttonWidth, roundedBorder;
  final Widget widget;
  final Color borderColor;
  final bool isPadding;

  ButtonWidget(
      {this.function,
      this.buttonColor,
      this.buttonHeight,
      this.buttonWidth,
      this.roundedBorder,
      this.borderColor,
      this.isPadding = true,
      this.widget});

  @override
  _ButtonWidgetState createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.isPadding
          ? const EdgeInsetsDirectional.only(start: 20,end:20, top:10, bottom: 10,)
          : EdgeInsets.zero,
      child: Container(
        height: widget.buttonHeight,
        width: widget.buttonWidth,
        decoration: BoxDecoration(
            border: Border.all(color: widget.borderColor ?? Colors.transparent),
            borderRadius: BorderRadius.circular(widget.roundedBorder)),
        child: RaisedButton(
            color: widget.buttonColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widget.roundedBorder)),
            onPressed: widget.function,
            child: widget.widget),
      ),
    );
  }
}
