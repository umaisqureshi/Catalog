import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:category/api/auth_apis.dart';
import 'package:category/modals/apiError.dart';
import 'package:category/modals/apiResponse.dart';
import 'package:category/modals/route_arguments.dart';
import 'package:category/modals/user.dart';
import 'package:category/screens/codeVerification.dart';
import 'package:category/utils/constant.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:category/widgets/buttonWidget.dart';
import 'package:category/widgets/noConnection.dart';
import 'package:category/widgets/textWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:category/modals/local_user.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  LocalUser localUser = LocalUser.name();
  bool phoneNumbers = true;
  bool isHide = true;
  bool isHideCon = true;
  String pass;
  bool isLoading = false;

  String _username;
  String _email;
  String _password;
  String _cpassword;
  String phone;

  bool isInternetAvailable = true;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  ApiResponse _apiResponse = ApiResponse();

  showInSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _handleSubmitted() async {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      showInSnackBar(AppLocalizations.of(context).textFieldError);
    } else {
      form.save();
      setState(() {
        isLoading = true;
      });
      _apiResponse =
          await registerUser(_username, _email, _password, _cpassword);
      if ((_apiResponse.ApiError as ApiError) == null) {
        _saveAndRedirectToHome();
      } else {
        showInSnackBar((_apiResponse.ApiError as ApiError).error);
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _handlePhoneSubmitted()async{
    final FormState form = _formKey.currentState;
    if(!form.validate()){
      showInSnackBar(AppLocalizations.of(context).textFieldError);
    }else{
      form.save();
      setState(() {
        isLoading = true;
      });
      _apiResponse = await registerUserWithPhone(phone);
      if ((_apiResponse.ApiError as ApiError) == null) {

        Navigator.of(context).pushNamed('/CodeVerification',arguments: RouteArguments(param1: _username, param2: phone));

        /*Navigator.push(context, MaterialPageRoute(builder: (context){
          return CodeVerification(username: _username,phone: phone,);
        }));*/
      } else {
        showInSnackBar((_apiResponse.ApiError as ApiError).error);
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _saveAndRedirectToHome() async {
    Welcome welcome = _apiResponse.Data;
    SharedPrefs().token = json.encode(welcome.toJson());
    SharedPrefs().createdMainStore = false;
    Welcome wel = Welcome.fromJson(json.decode((SharedPrefs().token)));

    await FirebaseFirestore.instance.collection("Users").doc(wel.userData.id).set({
      "id" : wel.userData.id,
      "username" : wel.userData.username,
      "email" : wel.userData.email,
      "role" : wel.userData.role,
      "profileImageUrl" : ""
    }, SetOptions(merge: true));

    await getCategoriesData(wel.token).whenComplete(() {
      Navigator.pushNamedAndRemoveUntil(
          context, '/category', ModalRoute.withName('/category'),
          arguments: (wel));
    });
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        setState((){
          isInternetAvailable = true;
        });
        break;
      default:
        setState(() => isInternetAvailable = false);
        break;
    }
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  @override
  void initState() {
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    super.initState();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Form(
            key: _formKey,
            child: isInternetAvailable ? SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 30),
                        child: Image.asset(
                          'assets/images/logo1.png',
                          width: 150,
                          height: 150,
                        )),
                  ),
                  Text(
                    AppLocalizations.of(context).signUp,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.only(
                        end: size.width * 0.72, top: size.height * 0.06),
                    child: TextWidget(
                      textSize: 15,
                      isBold: true,
                      text: AppLocalizations.of(context).username,
                      textColor: primary,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.only(
                        start: 20, end: 20, top: 10, bottom: 10),
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Required Field";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _username = value;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsetsDirectional.only(
                            start: 10, end: 10, top: 5, bottom: 5),
                        hintText: AppLocalizations.of(context).enterUsername,
                        hintStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: "Yu Gothic UI"),
                        prefixIcon: Image.asset(
                          'assets/images/name.png',
                          scale: 1.5,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: primary,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: primary,
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 2,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.only(start: size.width * 0.06),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(
                          textSize: 15,
                          isBold: true,
                          text: phoneNumbers
                              ? AppLocalizations.of(context).phone
                              : AppLocalizations.of(context).email,
                          textColor: primary,
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.only(
                              end: size.width * 0.047),
                          child: InkWell(
                              onTap: () {
                                setState(() {
                                  phoneNumbers = !phoneNumbers;
                                });
                              },
                              child: Text(
                                phoneNumbers
                                    ? AppLocalizations.of(context)
                                        .useEmailInstead
                                    : AppLocalizations.of(context)
                                        .usePhoneInstead,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline),
                              )),
                        )
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsetsDirectional.only(
                          start: 20, end: 20, top: 10, bottom: 10),
                      child: phoneNumbers ? IntlPhoneField(
                        keyboardType: TextInputType.phone,
                        autoValidate: false,
                        showDropdownIcon: false,
                        initialCountryCode: 'LY',
                        decoration: InputDecoration(

                          contentPadding: EdgeInsetsDirectional.all(12),
                          isDense: true,
                          hintText: AppLocalizations.of(context).enterPhoneNumber,
                          hintStyle : TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: "Yu Gothic UI"),
                          prefixIcon: Image.asset(
                            'assets/images/phone.png',
                            scale: 1.5,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: primary,
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: primary,
                              width: 2,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 2,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 2,
                            ),
                          ),
                        ),
                        validator: (value) {
                          return value.isEmpty
                              ? AppLocalizations.of(context).enterPhoneNumber
                              : null;
                        },
                        onSaved: (value) {
                          phone = value.completeNumber;
                        },
                        onChanged: (phone) {
                          print(phone.completeNumber);
                        },
                      ) : TextFormField(
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          return value.isEmpty
                              ? phoneNumbers
                                  ? AppLocalizations.of(context)
                                      .enterPhoneNumber
                                  : AppLocalizations.of(context).enterEmail
                              : null;
                        },
                        onSaved: (value) {
                          phoneNumbers
                              ? phone = value
                              : _email = value;
                        },
                        keyboardType: phoneNumbers
                            ? TextInputType.phone
                            : TextInputType.emailAddress,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsetsDirectional.only(
                              start: 10, end: 10, top: 5, bottom: 5),
                          hintText: phoneNumbers
                              ? AppLocalizations.of(context).enterPhoneNumber
                              : AppLocalizations.of(context).enterEmail,
                          hintStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: "Yu Gothic UI"),
                          prefixIcon: phoneNumbers
                              ? Image.asset(
                                  'assets/images/phone.png',
                                  scale: 1.5,
                                )
                              : Image.asset(
                                  'assets/images/mail.png',
                                  scale: 1.5,
                                ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: primary,
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: primary,
                              width: 2,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 2,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 2,
                            ),
                          ),
                        ),
                      )),
                  !phoneNumbers
                      ? Padding(
                          padding: EdgeInsetsDirectional.only(
                              end: size.width * 0.72),
                          child: TextWidget(
                            textSize: 15,
                            isBold: true,
                            text: AppLocalizations.of(context).password,
                            textColor: primary,
                          ),
                        )
                      : Container(),
                  !phoneNumbers
                      ? Padding(
                          padding: EdgeInsetsDirectional.only(
                              start: 20, end: 20, top: 10, bottom: 10),
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return AppLocalizations.of(context)
                                    .passwordFieldError;
                              } else if (value.length < 6) {
                                return AppLocalizations.of(context)
                                    .passwordLengthError;
                              }
                              return null;
                            },
                            onSaved: (value) {
                              localUser.password = value;
                              _password = value;
                            },
                            onChanged: (input) {
                              setState(() => pass = input);
                            },
                            obscureText: isHide,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsetsDirectional.only(
                                  start: 10, end: 10, top: 5, bottom: 5),
                              hintText:
                                  AppLocalizations.of(context).enterPassword,
                              hintStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: "Yu Gothic UI"),
                              prefixIcon: Image.asset(
                                'assets/images/password.png',
                                scale: 1.5,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isHide = !isHide;
                                  });
                                },
                                icon: isHide
                                    ? Icon(
                                        Icons.remove_red_eye_outlined,
                                        color: Colors.black,
                                      )
                                    : Icon(
                                        Icons.visibility_off_outlined,
                                        color: Colors.black,
                                      ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: primary,
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: primary,
                                  width: 2,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 2,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 2,
                                ),
                              ),
                            ),
                          ))
                      : Container(),
                  !phoneNumbers
                      ? Padding(
                          padding:
                              EdgeInsetsDirectional.only(end: size.width * 0.6),
                          child: TextWidget(
                            textSize: 15,
                            isBold: true,
                            text: AppLocalizations.of(context).confirmPassword,
                            textColor: primary,
                          ),
                        )
                      : Container(),
                  !phoneNumbers
                      ? Padding(
                          padding: EdgeInsetsDirectional.only(
                              start: 20, end: 20, top: 10, bottom: 10),
                          child: TextFormField(
                            validator: (val) {
                              if (val.isEmpty) return 'Empty';
                              if (val != pass) return 'Not Match';
                              return null;
                            },
                            onSaved: (value) {
                              _cpassword = value;
                            },
                            obscureText: isHideCon,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsetsDirectional.only(
                                  start: 10, end: 10, top: 5, bottom: 5),
                              hintText: AppLocalizations.of(context)
                                  .enterConfirmPassword,
                              hintStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: "Yu Gothic UI"),
                              prefixIcon: Image.asset(
                                'assets/images/password.png',
                                scale: 1.5,
                              ),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isHideCon = !isHideCon;
                                    });
                                  },
                                  icon: Icon(
                                    isHideCon
                                        ? Icons.remove_red_eye_outlined
                                        : Icons.visibility_off_outlined,
                                    color: Colors.black,
                                  )),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: primary,
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: primary,
                                  width: 2,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 2,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 2,
                                ),
                              ),
                            ),
                          ))
                      : Container(),
                  isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                          backgroundColor: Color(0xFFb58563),
                          strokeWidth: 2,
                        ))
                      : ButtonWidget(
                          buttonHeight: 50,
                          buttonWidth: MediaQuery.of(context).size.width,
                          buttonColor: Color(0xFFb58563),
                          roundedBorder: 10,
                          function: () async {
                            if(phoneNumbers){
                              _handlePhoneSubmitted();
                            }else{
                              _handleSubmitted();
                            }
                          },
                          widget: TextWidget(
                            text: AppLocalizations.of(context).continueButton,
                            textColor: white,
                            textSize: 18,
                          ),
                        ),
                  Align(
                    alignment: Alignment.center,
                    child: RichText(
                        text: TextSpan(children: [
                      TextSpan(
                        text: AppLocalizations.of(context).alreadyHaveAccount,
                        style: TextStyle(color: primary, fontSize: 12),
                      ),
                      TextSpan(
                          text: AppLocalizations.of(context).signIn,
                          style: TextStyle(
                              color: primary,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap =
                                () => Navigator.pushNamed(context, '/signIn'))
                    ])),
                  ),
                  SizedBox(
                    height: size.height * 0.06,
                  ),
                ],
              ),
            ) : NoInternet(),
          )),
    );
  }
}


