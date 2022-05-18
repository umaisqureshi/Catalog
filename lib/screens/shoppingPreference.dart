import 'package:category/utils/constant.dart';
import 'package:category/widgets/backIconWidget.dart';
import 'package:category/widgets/bottomBarWidget.dart';
import 'package:category/widgets/buttonWidget.dart';
import 'package:category/widgets/textWidget.dart';
import 'package:category/widgets/tileWidget.dart';
import 'package:category/widgets/topBarWidget.dart';
import 'package:flutter/material.dart';

class ShoppingPreference extends StatefulWidget {
  @override
  _ShoppingPreferenceState createState() => _ShoppingPreferenceState();
}

class _ShoppingPreferenceState extends State<ShoppingPreference> {
  List<String> type = [
    'Men',
    'Women',
    'Kids',
  ];

  int selectedCategory = 0;

  void changeIndex(int index) {
    selectedCategory = index;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: TextWidget(
            text: AppLocalizations.of(context).categories,
            textSize: 18,
            textColor: primary,
            isBold: true,
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Stack(
            children: [
              Positioned(
                top: 40,
                child: SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height / 1.2,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40,
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: type.length,
                            itemBuilder: (context, i) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() => selectedCategory = i);
                                },
                                child: TileWidget(
                                  isRoundedButton: false,
                                  trailingWidget: selectedCategory == i
                                      ? Icon(
                                          Icons.check,
                                          color: primary,
                                        )
                                      : Container(),
                                  leadingWidget: TextWidget(
                                    text: type[i],
                                    textSize: 14,
                                    textColor: primary,
                                    isBold: true,
                                  ),
                                ),
                              );
                            }),
                        SizedBox(
                          height: 30,
                        ),
                        ButtonWidget(
                          buttonHeight: 50,
                          buttonWidth: MediaQuery.of(context).size.width,
                          function: () =>
                              Navigator.pushNamed(context, '/dashboard'),
                          roundedBorder: 10,
                          buttonColor: Color(0xFFb58563),
                          widget: TextWidget(
                            text: AppLocalizations.of(context).save,
                            textSize: 18,
                            textColor: grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
