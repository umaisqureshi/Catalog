import 'package:category/screens/dashboard1/widgets/roundedButtonWidget.dart';
import 'package:flutter/material.dart';
import 'package:category/utils/constant.dart';

class TileWidget extends StatelessWidget {
  final Widget leadingWidget, trailingWidget;
  final bool isRoundedButton;
  final Function function;

  TileWidget(
      {this.leadingWidget,
      this.trailingWidget,
      this.function,
      this.isRoundedButton = true});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 45,
        margin: const EdgeInsetsDirectional.only(start: 20,end:20, top:4, bottom:4),
        padding: const EdgeInsetsDirectional.only(start: 20,end:20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: primary)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            leadingWidget,
            Row(
              children: [
                trailingWidget ?? Container(),
                SizedBox(
                  width: 10,
                ),
                isRoundedButton
                    ? RoundedButtonWidget(
                        function: function,
                      )
                    : Container()
              ],
            )
          ],
        ));
  }
}
