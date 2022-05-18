import 'dart:convert';

import 'package:category/api/auth_apis.dart';
import 'package:category/main.dart';
import 'package:category/screens/dashboard/promoCodesScreen.dart';
import 'package:category/screens/dashboard1/widgets/textWidget.dart';
import 'package:category/screens/dashboard1/widgets/tileWidget.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:category/utils/constant.dart';
import 'buttonWidget.dart';
import 'package:category/modals/user.dart';

class DrawerCustomer extends StatefulWidget {
  @override
  _DrawerCustomerState createState() => _DrawerCustomerState();
}

class _DrawerCustomerState extends State<DrawerCustomer> {
  final _formKey = GlobalKey<FormState>();
  String user;
  String imageurl;
  String pictureURL;
  String url = 'default';

  Welcome _userInfo;

  handleLogout() async {
    SharedPrefs().clear();
    Navigator.pushNamedAndRemoveUntil(context, '/auth', (route) => false);
  }

  @override
  void initState() {
    _userInfo =Welcome.fromJson(json.decode(SharedPrefs().token));
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
            centerTitle: true,
            elevation: 0,
            title: TextWidget(
              text: AppLocalizations.of(context).mainMenu,
              textSize: 15,
              isBold: true,
              textColor: primary,
            ),
          ),
          body: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.03),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                            Navigator.pushNamed(context, '/account'),
                        leadingWidget: Row(
                          children: [
                            /*SizedBox(
                              height: 40,
                              width: 40,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  "https://img.freepik.com/free-photo/mand-holding-cup_1258-340.jpg?size=626&ext=jpg",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),*/
                            Text(
                              _userInfo.userData.username,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                      ),
                      TileWidget(
                        function: () =>
                            Navigator.pushNamed(context, '/changePassword'),
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
                        function: () async {
                        var role =   SharedPrefs().userRole;
                        Welcome userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));

                        if(role == "partner"){
                          valueNotifier.value = false;
                          SharedPrefs().userRole = "customer";
                          await updateRole("customer", userInfo.token);
                          valueNotifier.notifyListeners();

                        }else{
                          valueNotifier.value = true;
                          SharedPrefs().userRole = "partner";
                          await updateRole("partner", userInfo.token);
                          valueNotifier.notifyListeners();
                        }
                        },
                        trailingWidget: TextWidget(
                          text: "Partner",
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

          /*            _userInfo.userData.role == 'partner' ? TileWidget(
                        function: (){},
                        trailingWidget: TextWidget(
                          text: _userInfo.userData.role,
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
                      ) : Container(),*/
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 6),
                        child: TextWidget(
                          text: AppLocalizations.of(context).preferences,
                          textColor: primary,
                          textSize: 15,
                          isBold: true,
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      TileWidget(
                        function: () =>
                            Navigator.pushNamed(context, '/Language'),
                        leadingWidget: TextWidget(
                          textSize: 14,
                          isBold: true,
                          textColor: primary,
                          text: AppLocalizations.of(context).language,
                        ),
                        trailingWidget: TextWidget(
                          textSize: 14,
                          textColor: primary.withOpacity(0.4),
                          text: 'English',
                        ),
                      ),
                      TileWidget(
                        function: () =>
                            Navigator.pushNamed(context, '/country'),
                        leadingWidget: TextWidget(
                          textSize: 14,
                          isBold: true,
                          textColor: primary,
                          text:AppLocalizations.of(context).location,
                        ),
                        trailingWidget: TextWidget(
                          textSize: 14,
                          textColor: primary.withOpacity(0.4),
                          text: locationList[0],
                        ),
                      ),
                      TileWidget(
                        function: () =>
                            Navigator.pushNamed(context, '/Currency'),
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
                            context, '/shoppingPreference'),
                        leadingWidget: TextWidget(
                          textSize: 14,
                          isBold: true,
                          textColor: primary,
                          text: AppLocalizations.of(context).shoppingPreferences,
                        ),
                      ),
                      TileWidget(
                        function: () =>
                            Navigator.pushNamed(context, '/brands'),
                        leadingWidget: TextWidget(
                          textSize: 14,
                          isBold: true,
                          textColor: primary,
                          text: AppLocalizations.of(context).addFavBrands,
                        ),
                      ),
                      TileWidget(
                        function: () =>
                            Navigator.pushNamed(context, '/Stores'),
                        leadingWidget: TextWidget(
                          textSize: 14,
                          isBold: true,
                          textColor: primary,
                          text: AppLocalizations.of(context).addFavStores,
                        ),
                      ),

                      TileWidget(
                        function: () =>
                            Navigator.pushNamed(context, '/PromoCode')
                            /*Navigator.push(context, MaterialPageRoute(builder: (context) => PromoCodesScreen()))*/,
                        leadingWidget: TextWidget(
                          textSize: 14,
                          isBold: true,
                          textColor: primary,
                          text: AppLocalizations.of(context).enterPromoCodes,
                        ),
                      ),


                      /*Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 6),
                        child: TextWidget(
                            text:AppLocalizations.of(context).support,
                            textColor: primary,
                            textSize: 15,
                          isBold: true,
                        ),
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
                          text: AppLocalizations.of(context).aboutUs,
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),*/
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
                          isBold: true,
                          textSize: 15,
                          textColor: grey,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
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
