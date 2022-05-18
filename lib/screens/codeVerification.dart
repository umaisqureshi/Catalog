import 'dart:convert';
import 'package:category/api/auth_apis.dart';
import 'package:category/modals/apiError.dart';
import 'package:category/modals/apiResponse.dart';
import 'package:category/modals/route_arguments.dart';
import 'package:category/modals/user.dart';
import 'package:category/utils/constant.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:category/widgets/pinCodeFields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'dashboard1/widgets/buttonWidget.dart';
import 'dashboard1/widgets/textWidget.dart';

class CodeVerification extends StatefulWidget {

  RouteArguments routeArguments;
  CodeVerification({this.routeArguments});

 /* String username;
  String phone;
  CodeVerification({this.username, this.phone});*/
  @override
  _CodeVerificationState createState() => _CodeVerificationState();
}

class _CodeVerificationState extends State<CodeVerification> {
  bool isLoading = false;
  bool isResend = false;
  int time = 59;

  final CountdownController _controllerTimer =
  new CountdownController(autoStart: true);

  TextEditingController _controller1 = TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  ApiResponse _apiResponse = ApiResponse();

  showInSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _handlePhoneSubmitted()async{
    if(_controller1.text.isEmpty){
      showInSnackBar(AppLocalizations.of(context).textFieldError);
    }else{
      setState(() {
        isLoading = true;
      });
      _apiResponse = await verifyCode(widget.routeArguments.param1,widget.routeArguments.param2, _controller1.text);
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

  void resendCode()async {

  }

  void _saveAndRedirectToHome() async {
    Welcome welcome = _apiResponse.Data;

    if(welcome.userData.role!=null){
      SharedPrefs().token = json.encode(welcome.toJson());
      SharedPrefs().userRole = welcome.userData.role;
      SharedPrefs().createdMainStore = welcome.mainStore;

      print("Token from pref ::::::::: ${SharedPrefs().token}");
      Welcome wel =Welcome.fromJson(json.decode((SharedPrefs().token)));

      await FirebaseFirestore.instance.collection("Users").doc(wel.userData.id).set({
        "id" : wel.userData.id,
        "username" : wel.userData.username,
        "email" : wel.userData.email,
        "role" : wel.userData.role,
        "profileImageUrl" : ""
      }, SetOptions(merge: true));

      await getCategoriesData(wel.token);

      print("Access Token :::::::::::: ${(wel.token)}");
      if(welcome.userData.role == 'partner'){
        if(SharedPrefs().isCreatedMainStoreAvailable() && SharedPrefs().createdMainStore){
          Navigator.pushNamedAndRemoveUntil(
              context, '/dashboardPartner', (_)=> false,
              arguments: (_apiResponse.Data));
        }else if(welcome.mainStore){
          Navigator.pushNamedAndRemoveUntil(context, '/dashboardPartner', (_)=> false,
              arguments: (_apiResponse.Data));
        }
        else{
          Navigator.pushNamedAndRemoveUntil(context, '/makeMainStore',(_)=> false,
              arguments: (_apiResponse.Data));
        }
      }else{
        Navigator.pushNamedAndRemoveUntil(
            context, '/dashboard', (_)=> false,
            arguments: (_apiResponse.Data));
      }
    }else{
      SharedPrefs().token = json.encode(welcome.toJson());
      SharedPrefs().createdMainStore = false;

      await getCategoriesData(welcome.token).whenComplete((){
        print("Access Token :::::::::::: ${(welcome.token)}");
        Navigator.pushNamedAndRemoveUntil(
            context, '/category', (_)=> false,
            arguments: (welcome));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        key: scaffoldKey,
        body: Center(
          child: Padding(
            padding: const EdgeInsetsDirectional.only(start: 20, end: 20),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              height: 300,
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(end: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Material(
                            type: MaterialType.circle,
                            color: Colors.white,
                            elevation: 4.0,
                            child: Container(
                              padding: EdgeInsetsDirectional.all(5.0),
                              child: Icon(Icons.clear),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.all(5.0),
                    child: Text(
                      AppLocalizations.of(context).enterCodeReceived,
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .merge(TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.all(4.0),
                    child: Text(
                      AppLocalizations.of(context).sentYouA6DigitCode,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  PinCodeTextField(
                    length: 6,
                    controller: _controller1,
                    onChanged: (value) {},
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.all(16),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child:Countdown(
                        controller: _controllerTimer,
                        seconds: time,
                        build: (_, double remaining) => Text("Code will expire within : " + remaining.toStringAsFixed(0) + " Secs"),
                        interval: Duration(milliseconds: 100),
                        onFinished: () {
                          setState((){
                            isResend = true;
                          });
                          print("ONFINISHED TIME ::::::::::::::::::::::::: $time");
                        },
                      ),
                      /*CountdownFormatted(
                        duration: Duration(seconds: 59),
                        onFinish: (){
                          setState((){
                            isResend = true;
                          });
                          print("ONFINISHED TIME ::::::::::::::::::::::::: $time");
                          //resendCode();
                        },
                        builder: (BuildContext ctx, String remaining) {
                          time = int.parse(remaining);
                          return Text("Code will expire within : " + remaining + " Secs"); // 01:00:00
                        },
                      ),*/
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Color(0xFFb58563),
                                strokeWidth: 2,
                              ),
                            )
                          : ButtonWidget(
                              buttonHeight: 50,
                              buttonWidth:
                                  MediaQuery.of(context).size.width / 2,
                              buttonColor: isResend ? Colors.lightBlue :Color(0xFFb58563),
                              roundedBorder: 10,
                              function: () async {
                                isResend ? registerUserWithPhone(widget.routeArguments.param2).whenComplete(() { setState((){
                                  isResend = false;
                                  time = 59;
                                  _controllerTimer.restart();
                                });

                                print("On RESEND TIME ::::::::::::::::::::::::: $time");
                                }) :_handlePhoneSubmitted();
                              },
                              widget: TextWidget(
                                text:
                                    isResend ? "Send Code Again" : AppLocalizations.of(context).continueButton,
                                textColor: white,
                                textSize: 18,
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
