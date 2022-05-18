import 'dart:convert';

import 'package:category/api/auth_apis.dart';
import 'package:category/modals/apiError.dart';
import 'package:category/modals/apiResponse.dart';
import 'package:category/modals/user.dart';
import 'package:category/screens/dashboard1/widgets/buttonWidget.dart';
import 'package:category/screens/dashboard1/widgets/textWidget.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:flutter/material.dart';
import 'package:category/utils/constant.dart';

class ChangePassword1 extends StatefulWidget {
  @override
  _ChangePassword1State createState() => _ChangePassword1State();
}

class _ChangePassword1State extends State<ChangePassword1> {

  ApiResponse _apiResponse = ApiResponse();

  Welcome _userInfo;

  showInSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


  _handleChangePassword({String newPassword, String oldPassword}) async {
    _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
    print("User Token" + _userInfo.token);
    _apiResponse = await changePassword(
        token: _userInfo.token,
        oldPassword: newPassword,
        newPassword: oldPassword
    );
    if ((_apiResponse.ApiError as ApiError) == null) {
      showInSnackBar("Password changed successfully");
      setState(() {});
    } else {
      showInSnackBar((_apiResponse.ApiError as ApiError).error);
    }
  }


  bool isLoading = false;
  bool currentPasswordStatus = true;
  final _formKey = GlobalKey<FormState>();
  TextEditingController oldpassword = TextEditingController();
  TextEditingController newpassword = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();

  bool eye = true;
  bool eye1 = true;
  bool eye2 = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: TextWidget(
            text: AppLocalizations.of(context).changePassword,
            textSize: 18,
            textColor: primary,
            isBold: true,
          ),
          elevation: 0,
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsetsDirectional.only(top: size.height * 0.04),
                child: ListView(
                  children: [
                    SingleChildScrollView(
                      // scrollDirection: Axis.vertical,
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.only(
                                  end: size.width * 0.33,
                                  top: size.height * 0.04),
                              child: TextWidget(
                                text: AppLocalizations.of(context)
                                    .changeYourPassword,
                                textSize: 18,
                                textColor: primary,
                                isBold: true,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.only(
                                  end: size.width * 0.65,
                                  top: size.height * 0.05),
                              child: Text(
                                AppLocalizations.of(context).oldPassword,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF151515),
                                    fontFamily: "Yu Gothic UI"),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.only(
                                  start: size.width * 0.05,
                                  end: size.width * 0.05,
                                  top: size.height * 0.009),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xFF151515)),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: TextFormField(
                                  obscureText: eye,
                                  validator: (value) {
                                    if (value.isNotEmpty) {
                                      if (currentPasswordStatus) {
                                        return null;
                                      } else
                                        return 'Incorrect Passowrd.';
                                    } else
                                      return AppLocalizations.of(context)
                                          .enterOldPassword;
                                  },
                                  controller: oldpassword,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        if (eye == true) {
                                          setState(() {
                                            eye = false;
                                          });
                                        } else {
                                          setState(() {
                                            eye = true;
                                          });
                                        }
                                      },
                                      icon: eye == true
                                          ? Icon(
                                              Icons.remove_red_eye_outlined,
                                              color: Colors.black,
                                            )
                                          : Icon(
                                              Icons.visibility_off_outlined,
                                              color: Colors.black,
                                            ),
                                    ),
                                    border: InputBorder.none,
                                    prefixIcon: Image.asset(
                                      'assets/images/password.png',
                                      scale: 1.5,
                                    ),
                                    hintText: AppLocalizations.of(context)
                                        .enterOldPassword,
                                    hintStyle: TextStyle(
                                        fontSize: 9.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF151515),
                                        fontFamily: "Yu Gothic UI"),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.only(
                                  end: size.width * 0.65,
                                  top: size.height * 0.018),
                              child: Text(
                                AppLocalizations.of(context).newPassword,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF151515),
                                    fontFamily: "Yu Gothic UI"),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.only(
                                  start: size.width * 0.05,
                                  end: size.width * 0.05,
                                  top: size.height * 0.009),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xFF151515)),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: TextFormField(
                                  obscureText: eye1,
                                  validator: (value) {
                                    if (value.isNotEmpty) {
                                      return null;
                                    } else
                                      return AppLocalizations.of(context)
                                          .enterNewPassword;
                                  },
                                  textInputAction: TextInputAction.next,
                                  controller: newpassword,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        if (eye1 == true) {
                                          setState(() {
                                            eye1 = false;
                                          });
                                        } else {
                                          setState(() {
                                            eye1 = true;
                                          });
                                        }
                                      },
                                      icon: eye1 == true
                                          ? Icon(
                                              Icons.remove_red_eye_outlined,
                                              color: Colors.black,
                                            )
                                          : Icon(
                                              Icons.visibility_off_outlined,
                                              color: Colors.black,
                                            ),
                                    ),
                                    border: InputBorder.none,
                                    prefixIcon: Image.asset(
                                      'assets/images/password.png',
                                      scale: 1.5,
                                    ),
                                    hintText: AppLocalizations.of(context)
                                        .enterNewPassword,
                                    hintStyle: TextStyle(
                                        fontSize: 9.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF151515),
                                        fontFamily: "Yu Gothic UI"),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.only(
                                  end: size.width * 0.6,
                                  top: size.height * 0.018),
                              child: Text(
                                AppLocalizations.of(context).confirmPassword,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF151515),
                                    fontFamily: "Yu Gothic UI"),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.only(
                                  start: size.width * 0.05,
                                  end: size.width * 0.05,
                                  top: size.height * 0.009),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xFF151515)),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: TextFormField(
                                  obscureText: eye2,
                                  validator: (value) {
                                    if (value.isNotEmpty) {
                                      if (value == newpassword.text) {
                                        return null;
                                      } else
                                        return AppLocalizations.of(context)
                                            .passwordsDontMatch;
                                    } else
                                      return AppLocalizations.of(context)
                                          .enterNewPassword;
                                  },
                                  controller: confirmpassword,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        if (eye2 == true) {
                                          setState(() {
                                            eye2 = false;
                                          });
                                        } else {
                                          setState(() {
                                            eye2 = true;
                                          });
                                        }
                                      },
                                      icon: eye2 == true
                                          ? Icon(
                                              Icons.remove_red_eye_outlined,
                                              color: Colors.black,
                                            )
                                          : Icon(
                                              Icons.visibility_off_outlined,
                                              color: Colors.black,
                                            ),
                                    ),
                                    border: InputBorder.none,
                                    prefixIcon: Image.asset(
                                      'assets/images/password.png',
                                      scale: 1.5,
                                    ),
                                    hintText: AppLocalizations.of(context)
                                        .enterNewPassword,
                                    hintStyle: TextStyle(
                                        fontSize: 9.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF151515),
                                        fontFamily: "Yu Gothic UI"),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            ButtonWidget(
                              buttonHeight: 50,
                              buttonWidth: MediaQuery.of(context).size.width,
                              function: () async {

                                if (_formKey.currentState.validate()) {
                                  await _handleChangePassword(newPassword: newpassword.text, oldPassword: oldpassword.text);
                                  setState(() {
                                    isLoading = true;
                                  });
                                }
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
      ),
    );
  }
}

