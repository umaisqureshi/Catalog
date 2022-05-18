import 'dart:convert';

import 'package:category/modals/user.dart';
import 'package:category/screens/dashboard1/widgets/textWidget.dart';
import 'package:category/screens/dashboard1/widgets/tileWidget.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'buttonWidget.dart';
import 'package:category/utils/constant.dart';

class DrawerPartner extends StatefulWidget {
  DrawerPartner({Key key}) : super(key: key);

  @override
  _DrawerPartnerState createState() => _DrawerPartnerState();
}

class _DrawerPartnerState extends State<DrawerPartner> {
  final _formKey = GlobalKey<FormState>();
  Welcome _userInfo;
  String user;
  String imageurl;
  String pictureURL;
  String url = 'default';
  DocumentSnapshot documentSnapshot;
  bool check = true;

  handleLogout() async {
    await SharedPrefs().clear();
    categoriesFilter.clear();
    categoriesSubCate.clear();
    categoriesGender.clear();
    categoriesList.clear();
    Navigator.pushNamedAndRemoveUntil(context, '/auth', (route) => false);
  }

  @override
  void initState() {
    _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));

    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Drawer(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            title: TextWidget(
              text: AppLocalizations.of(context).mainMenu,
              textSize: 15,
              textColor: primary,
              isBold: true,
            ),
            centerTitle: true,
            elevation: 0,
          ),
          body: Stack(
            children: [
              Padding(
                padding: EdgeInsetsDirectional.only(top: size.height * 0.02),
                child: ListView(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.only(start: size.width * 0.055),
                                child: Text(
                                  AppLocalizations.of(context).account,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TileWidget(
                            function: () =>
                                Navigator.pushNamed(context, '/account1'),
                            leadingWidget: Row(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      _userInfo.userData.username,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          TileWidget(
                            function: () => Navigator.pushNamed(
                                context, '/changePassword'),
                            trailingWidget: TextWidget(
                              text: "******",
                              textSize: 14,
                              isBold: true,
                              textColor: primary.withOpacity(0.4),
                            ),
                            leadingWidget: TextWidget(
                              textSize: 14,
                              isBold: true,
                              textColor: primary,
                              text: AppLocalizations.of(context).changePassword,
                            ),
                          ),
                          TileWidget(
                            function: () => Navigator.pushNamed(
                                context, '/switchaccountPartner'),
                            trailingWidget: TextWidget(
                              text: "Customer",
                              textSize: 14,
                              isBold: true,
                              textColor: primary.withOpacity(0.4),
                            ),
                            leadingWidget: TextWidget(
                              textSize: 14,
                              isBold: true,
                              textColor: primary,
                              text: AppLocalizations.of(context).switchAccount,
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.only(start: 20,end:20, top:6, bottom:6),
                                child: TextWidget(
                                  text: AppLocalizations.of(context).preferences,
                                  textColor: primary,
                                  isBold: true,
                                  textSize: 15,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(
                            height: 3,
                          ),
                          TileWidget(
                            function: () => Navigator.pushNamed(
                                context, '/LanguagePartner'),
                            leadingWidget: TextWidget(
                              textSize: 14,
                              isBold: true,
                              textColor: primary,
                              text: AppLocalizations.of(context).language,
                            ),
                            trailingWidget: TextWidget(
                              textSize: 14,
                              textColor: primary.withOpacity(0.4),
                              text: "English",
                            ),
                          ),
                          TileWidget(
                            function: () =>
                                Navigator.pushNamed(context, '/countryPartner'),
                            leadingWidget: TextWidget(
                              textSize: 14,
                              isBold: true,
                              textColor: primary,
                              text: AppLocalizations.of(context).location,
                            ),
                            trailingWidget: TextWidget(
                              textSize: 14,
                              textColor: primary.withOpacity(0.4),
                              text:locationList[0],
                            ),
                          ),
                          TileWidget(
                            function: () => Navigator.pushNamed(
                                context, '/CurrencyPartner'),
                            leadingWidget: TextWidget(
                              textSize: 14,
                              isBold: true,
                              textColor: primary,
                              text: AppLocalizations.of(context).currency,
                            ),
                            trailingWidget: TextWidget(
                              textSize: 14,
                              textColor: primary.withOpacity(0.4),
                              text: '\$',
                            ),
                          ),
                          TileWidget(
                            function: () => Navigator.pushNamed(
                                context, '/storePreferencePartner'),
                            leadingWidget: TextWidget(
                              textSize: 14,
                              isBold: true,
                              textColor: primary,
                              text: AppLocalizations.of(context).storePreference,
                            ),
                          ),
                         /* Row(
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.only(start: 20,end:20, top:6, bottom:6),
                                child: TextWidget(
                                  text: AppLocalizations.of(context).support,
                                  textColor: primary,
                                  isBold: true,
                                  textSize: 15,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          TileWidget(
                            leadingWidget: TextWidget(
                              textSize: 14,
                              isBold: true,
                              textColor: primary,
                              text: AppLocalizations.of(context).faq,
                            ),
                          ),
                          TileWidget(
                            leadingWidget: TextWidget(
                              textSize: 14,
                              isBold: true,
                              textColor: primary,
                              text: AppLocalizations.of(context).contactUs,
                            ),
                          ),
                          TileWidget(
                            leadingWidget: TextWidget(
                              textSize: 14,
                              isBold: true,
                              textColor: primary,
                              text:AppLocalizations.of(context).aboutUs,
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.01,
                          ),*/

                          SizedBox(height: 40,),
                          ButtonWidget(
                            buttonHeight: 50,
                            buttonWidth: MediaQuery.of(context).size.width,
                            function: () async {
                              await handleLogout();
                            },
                            roundedBorder: 10,
                            buttonColor: Color(0xFFb58563),
                            widget: TextWidget(
                              text: AppLocalizations.of(context).logout,
                              textSize: 15,
                              textColor: grey,
                            ),
                          ),
                          /*SizedBox(
                            height: size.height * 0.01,
                          ),*/
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
