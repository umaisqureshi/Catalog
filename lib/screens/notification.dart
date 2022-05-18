import 'package:category/utils/constant.dart';
import 'package:category/widgets/textWidget.dart';
import 'package:custom_switch_button/custom_switch_button.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  bool isChecked = false;
  bool isChecked1 = false;
  bool isChecked2 = false;
  bool isChecked3 = false;
  bool isChecked4 = false;
  bool isChecked5 = false;
  bool isChecked6 = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: TextWidget(
              text: AppLocalizations.of(context).alerts,
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
                padding:  EdgeInsetsDirectional.only(top:size.height*0.01),
                child: ListView(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [

                            Padding(
                              padding:  EdgeInsetsDirectional.only(end: size.width*0.45,top: size.height*0.1),
                              child: TextWidget(
                                text: AppLocalizations.of(context).pushNotifications,
                                textSize: 18,
                                textColor: primary,
                                isBold: true,
                              ),
                            ),

                            //Push Notifications
                            Padding(
                              padding:  EdgeInsetsDirectional.only(end: size.width*0.05,start: size.width*0.05,top: size.height*0.02),
                              child: Container(
                                width: size.width,
                                height: size.height*0.057,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                    border: Border.all(color: Color(0xFF0f1013).withOpacity(0.25)),
                                    borderRadius: BorderRadius.circular(15)
                                ),
                                child: Padding(
                                  padding:  EdgeInsetsDirectional.only(start: size.width*0.02,end: size.width*0.03),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      TextWidget(
                                        text: AppLocalizations.of(context).alertsOnFav,
                                        textColor: Color(0xFF0f1310),
                                        isBold: true,
                                        textSize: 14,
                                      ),
                                    GestureDetector(
                                      onTap: () {
                                      setState(() {
                                        isChecked = !isChecked;
                                      });
                                    },
                                      child: CustomSwitchButton(
                                      backgroundColor: Color(0xFFb58563),
                                      unCheckedColor: Colors.white,
                                      animationDuration: Duration(milliseconds: 400),
                                      checkedColor: Colors.black,
                                      checked: isChecked,
                                    ),
                                    ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:  EdgeInsetsDirectional.only(end: size.width*0.05,start: size.width*0.05,top: size.height*0.01),
                              child: Container(
                                width: size.width,
                                height: size.height*0.057,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Color(0xFF0f1013).withOpacity(0.25)),
                                    borderRadius: BorderRadius.circular(15)
                                ),
                                child: Padding(
                                  padding:  EdgeInsetsDirectional.only(start: size.width*0.02,end: size.width*0.03),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      TextWidget(
                                        text: AppLocalizations.of(context).specialOffers,
                                        textColor: Color(0xFF0f1310),
                                        isBold: true,
                                        textSize: 14,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isChecked1 = !isChecked1;
                                          });
                                        },
                                        child: CustomSwitchButton(
                                          backgroundColor: Color(0xFFb58563),
                                          unCheckedColor: Colors.white,
                                          animationDuration: Duration(milliseconds: 400),
                                          checkedColor: Colors.black,
                                          checked: isChecked1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:  EdgeInsetsDirectional.only(end: size.width*0.05,start: size.width*0.05,top: size.height*0.01),
                              child: Container(
                                width: size.width,
                                height: size.height*0.057,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Color(0xFF0f1013).withOpacity(0.25)),
                                    borderRadius: BorderRadius.circular(15)
                                ),
                                child: Padding(
                                  padding:  EdgeInsetsDirectional.only(start: size.width*0.02,end: size.width*0.03),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      TextWidget(
                                        text: AppLocalizations.of(context).backInStock,
                                        textColor: Color(0xFF0f1310),
                                        isBold: true,
                                        textSize: 14,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isChecked2 = !isChecked2;
                                          });
                                        },
                                        child: CustomSwitchButton(
                                          backgroundColor: Color(0xFFb58563),
                                          unCheckedColor: Colors.white,
                                          animationDuration: Duration(milliseconds: 400),
                                          checkedColor: Colors.black,
                                          checked: isChecked2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:  EdgeInsetsDirectional.only(end: size.width*0.05,start: size.width*0.05,top: size.height*0.01),
                              child: Container(
                                width: size.width,
                                height: size.height*0.057,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Color(0xFF0f1013).withOpacity(0.25)),
                                    borderRadius: BorderRadius.circular(15)
                                ),
                                child: Padding(
                                  padding:  EdgeInsetsDirectional.only(start: size.width*0.02,end: size.width*0.03),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      TextWidget(
                                        text: AppLocalizations.of(context).yourSalesAlerts,
                                        textColor: Color(0xFF0f1310),
                                        isBold: true,
                                        textSize: 14,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isChecked3 = !isChecked3;
                                          });
                                        },
                                        child: CustomSwitchButton(
                                          backgroundColor: Color(0xFFb58563),
                                          unCheckedColor: Colors.white,
                                          animationDuration: Duration(milliseconds: 400),
                                          checkedColor: Colors.black,
                                          checked: isChecked3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            //Email Notification
                            Padding(
                              padding:  EdgeInsetsDirectional.only(end: size.width*0.45,top: size.height*0.03),
                              child: TextWidget(
                                text: AppLocalizations.of(context).emailNotifications,
                                textSize: 18,
                                textColor: primary,
                                isBold: true,
                              ),
                            ),

                            Padding(
                              padding:  EdgeInsetsDirectional.only(end: size.width*0.05,start: size.width*0.05,top: size.height*0.02),
                              child: Container(
                                width: size.width,
                                height: size.height*0.057,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Color(0xFF0f1013).withOpacity(0.25)),
                                    borderRadius: BorderRadius.circular(15)
                                ),
                                child: Padding(
                                  padding:  EdgeInsetsDirectional.only(start: size.width*0.02,end: size.width*0.03),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      TextWidget(
                                        text:  AppLocalizations.of(context).yourFavSalesAlerts,
                                        textColor: Color(0xFF0f1310),
                                        isBold: true,
                                        textSize: 14,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isChecked4 = !isChecked4;
                                          });
                                        },
                                        child: CustomSwitchButton(
                                          backgroundColor: Color(0xFFb58563),
                                          unCheckedColor: Colors.white,
                                          animationDuration: Duration(milliseconds: 400),
                                          checkedColor: Colors.black,
                                          checked: isChecked4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:  EdgeInsetsDirectional.only(end: size.width*0.05,start: size.width*0.05,top: size.height*0.01),
                              child: Container(
                                width: size.width,
                                height: size.height*0.057,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Color(0xFF0f1013).withOpacity(0.25)),
                                    borderRadius: BorderRadius.circular(15)
                                ),
                                child: Padding(
                                  padding:  EdgeInsetsDirectional.only(start: size.width*0.02,end: size.width*0.03),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      TextWidget(
                                        text:  AppLocalizations.of(context).yourProductRecommendations,
                                        textColor: Color(0xFF0f1310),
                                        isBold: true,
                                        textSize: 14,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isChecked5 = !isChecked5;
                                          });
                                        },
                                        child: CustomSwitchButton(
                                          backgroundColor: Color(0xFFb58563),
                                          unCheckedColor: Colors.white,
                                          animationDuration: Duration(milliseconds: 400),
                                          checkedColor: Colors.black,
                                          checked: isChecked5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:  EdgeInsetsDirectional.only(end: size.width*0.05,start: size.width*0.05,top: size.height*0.01),
                              child: Container(
                                width: size.width,
                                height: size.height*0.057,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Color(0xFF0f1013).withOpacity(0.25)),
                                    borderRadius: BorderRadius.circular(15)
                                ),
                                child: Padding(
                                  padding:  EdgeInsetsDirectional.only(start: size.width*0.02,end: size.width*0.03),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      TextWidget(
                                        text:  AppLocalizations.of(context).limitedNews,
                                        textColor: Color(0xFF0f1310),
                                        isBold: true,
                                        textSize: 14,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isChecked6 = !isChecked6;
                                          });
                                        },
                                        child: CustomSwitchButton(
                                          backgroundColor: Color(0xFFb58563),
                                          unCheckedColor: Colors.white,
                                          animationDuration: Duration(milliseconds: 400),
                                          checkedColor: Colors.black,
                                          checked: isChecked6,
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
                  ],
                ),
              ),
            ],
          ),
        ),);
  }
}
