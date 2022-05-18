import 'package:category/screens/dashboard1/widgets/buttonWidget.dart';
import 'package:category/screens/dashboard1/widgets/textWidget.dart';
import 'package:category/screens/dashboard1/widgets/tileWidget.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:flutter/material.dart';
import 'package:category/utils/constant.dart';

class Country1 extends StatefulWidget {
  @override
  _Country1State createState() => _Country1State();
}

class _Country1State extends State<Country1> {

  int selectedCity = 0;

  void changeIndex(int index) {
    selectedCity = index;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: TextWidget(
            text: AppLocalizations.of(context).changeLocation,
            textSize: 18,
            textColor: primary,
            isBold: true,
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsetsDirectional.only(top: size.height * 0.06),
              child: ListView(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: locationList.length,
                              itemBuilder: (context, i) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() => selectedCity = i);
                                  },
                                  child: TileWidget(
                                    isRoundedButton: false,
                                    trailingWidget: selectedCity == i
                                        ? Icon(
                                            Icons.check,
                                            color: primary,
                                          )
                                        : Container(),
                                    leadingWidget: Row(
                                      children: [
                                        TextWidget(
                                          text: SharedPrefs().locale == "ar" ? locationListArabic[i] : locationList[i],
                                          textSize: 14,
                                          textColor: primary,
                                          isBold: true,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }),
                          ButtonWidget(
                            buttonHeight: 50,
                            buttonWidth: MediaQuery.of(context).size.width,
                            function: () {
                              Navigator.pushNamed(context, '/dashboardPartner');
                            },
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
