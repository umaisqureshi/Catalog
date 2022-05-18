import 'dart:async';
import 'dart:convert';
import 'package:category/modals/route_arguments.dart';
import 'package:category/screens/codeVerification.dart';
import 'package:category/utils/constant.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:category/widgets/buttonWidget.dart';
import 'package:category/widgets/noConnection.dart';
import 'package:category/widgets/textWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:category/modals/local_user.dart';
import 'package:category/widgets/pinCodeFields.dart';
import 'package:category/db/FirebaseCredentials.dart';
import 'package:category/modals/apiResponse.dart';
import 'package:category/modals/apiError.dart';
import 'package:category/modals/user.dart';
import 'package:category/api/auth_apis.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../main.dart';
import 'forgot_password.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  LocalUser localUser = LocalUser.name();
  bool phoneNumbers = true;
  bool isHide = true;
  bool isHideCon = true;
  String pass;
  bool isLoading = false;
  String _email;
  String _password;
  String phone;

  bool isInternetAvailable = true;

  FocusNode myFocusNode;

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  ApiResponse _apiResponse = ApiResponse();

  showInSnackBar(String message){
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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

  void _handleSubmitted() async {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      showInSnackBar(AppLocalizations.of(context).textFieldError);
    } else {
      setState((){
        isLoading = true;
      });
      form.save();
      _apiResponse = await authenticateUser(_email, _password);
      if ((_apiResponse.ApiError as ApiError) == null) {
        _saveAndRedirectToHome();
      } else {
        setState(() {
          isLoading = false;
        });
        showInSnackBar((_apiResponse.ApiError as ApiError).error);
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

        Navigator.of(context).pushNamed('/CodeVerification',arguments: RouteArguments(param1: "", param2: phone));

        /*Navigator.push(context, MaterialPageRoute(builder: (context){
          return CodeVerification(username: "",phone: phone,);
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
    print("User Role ${SharedPrefs().userRole}");
    print("Welcome User Role ${welcome.userData.role}");
    SharedPrefs().token = json.encode(welcome.toJson());
    SharedPrefs().userRole = welcome.userData.role;
    SharedPrefs().createdMainStore = welcome.mainStore;

    print("Token from pref ::::::::: ${SharedPrefs().token}");
    Welcome wel =Welcome.fromJson(json.decode((SharedPrefs().token)));

    await getCategoriesData(wel.token);

    await FirebaseFirestore.instance.collection("Users").doc(wel.userData.id).set({
      "id" : wel.userData.id,
      "username" : wel.userData.username,
      "email" : wel.userData.email,
      "role" : wel.userData.role,
      "profileImageUrl" : ""
    }, SetOptions(merge: true));

    valueNotifier.value =  welcome.userData.role == "partner";
    valueNotifier.notifyListeners();

    print("Access Token :::::::::::: ${(wel.token)}");
    if(welcome.userData.role == 'partner' || welcome.userData.role == 'Partner'){
      if(SharedPrefs().isCreatedMainStoreAvailable() && SharedPrefs().createdMainStore){
        Navigator.pushNamedAndRemoveUntil(
            context, '/dashboardPartner', ModalRoute.withName('/dashboardPartner'),
            arguments: (_apiResponse.Data));
      }else if(welcome.mainStore){
        Navigator.pushNamedAndRemoveUntil(context, '/dashboardPartner', ModalRoute.withName('/dashboardPartner'),
            arguments: (_apiResponse.Data));
      }
      else{
        Navigator.pushNamedAndRemoveUntil(context, '/makeMainStore', ModalRoute.withName('/makeMainStore'),
            arguments: (_apiResponse.Data));
      }
    }else{
      Navigator.pushNamedAndRemoveUntil(
          context, '/dashboard', (route)=> false,
          arguments: (_apiResponse.Data));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    myFocusNode = FocusNode();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    myFocusNode.dispose();
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
                    AppLocalizations.of(context).login,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.only(
                        start: size.width * 0.06, top: size.height * 0.06),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(
                          textSize: 15,
                          isBold: true,
                          text: phoneNumbers ? AppLocalizations.of(context).phone : AppLocalizations.of(context).email,
                          textColor: primary,
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.only(end: size.width * 0.047),
                          child: InkWell(
                              onTap: () {
                                setState(() {
                                  phoneNumbers = !phoneNumbers;
                                  _formKey.currentState.reset();
                                  myFocusNode.unfocus();
                                });
                              },
                              child: Text(
                                phoneNumbers
                                    ? AppLocalizations.of(context).useEmailInstead
                                    : AppLocalizations.of(context).usePhoneInstead,
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
                      padding:
                          EdgeInsetsDirectional.only(start: 20, end: 20, top: 10, bottom: 10),
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
                        focusNode: myFocusNode,
                        validator: (value) {
                          return value.isEmpty
                              ? /*phoneNumbers
                                  ? AppLocalizations.of(context).enterPhoneNumber
                                  :*/ AppLocalizations.of(context).enterEmail
                              : null;
                        },
                        onSaved: (value) {
                         /* phoneNumbers
                              ? phone = value
                              :*/ _email = value;
                        },
                        keyboardType: phoneNumbers
                            ? TextInputType.phone
                            : TextInputType.text,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsetsDirectional.only(top: 5, bottom:5, start:10, end:10),
                          hintText: /*phoneNumbers
                              ? AppLocalizations.of(context).enterPhoneNumber
                              :*/ AppLocalizations.of(context).enterEmail,
                          hintStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: "Yu Gothic UI"),
                          prefixIcon: /*phoneNumbers
                              ? Image.asset(
                                  'assets/images/phone.png',
                                  scale: 1.5,
                                )
                              :*/ Image.asset(
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
                      ),),
                  !phoneNumbers
                      ? Padding(
                          padding: EdgeInsetsDirectional.only(end: size.width * 0.72),
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
                                return AppLocalizations.of(context).passwordFieldError;
                              } else if (value.length < 6) {
                                return AppLocalizations.of(context).passwordLengthError;
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _password = value;
                            },
                            onChanged: (input) {
                              setState(() => pass = input);
                            },
                            obscureText: isHide,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsetsDirectional.only(
                                  top: 5, bottom: 5, start: 10, end: 10),
                              hintText: AppLocalizations.of(context).enterPassword,
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
                            phoneNumbers ? _handlePhoneSubmitted():_handleSubmitted();
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
                        text: AppLocalizations.of(context).dontHaveAnAccount,
                        style: TextStyle(color: primary, fontSize: 12),
                      ),
                      TextSpan(
                          text: AppLocalizations.of(context).signUp,
                          style: TextStyle(
                              color: primary,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap =
                                () => Navigator.pushNamed(context, '/signUp'))
                    ])),
                  ),

                  SizedBox(
                    height: size.height * 0.06,
                  ),

                  Align(
                    alignment: Alignment.center,
                    child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: "Forgot password?",
                            style: TextStyle(color: primary, fontSize: 12),
                          ),
                          TextSpan(
                              text: "RESET NOW",
                              style: TextStyle(
                                  color: primary,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap =
                                    () {
                                      Navigator.of(context).pushNamed('/ForgotPassword');

                                    }

                                        //Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPassword()))
                    )
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
