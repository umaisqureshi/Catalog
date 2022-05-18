import 'package:category/utils/constant.dart';
import 'package:category/widgets/roundedButtonWidget.dart';
import 'package:flutter/material.dart';

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
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 20),
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
