import 'dart:convert';
import 'dart:ui';
import 'package:category/api/auth_apis.dart';
import 'package:category/main.dart';
import 'package:category/modals/apiError.dart';
import 'package:category/modals/apiResponse.dart';
import 'package:category/modals/user.dart';
import 'package:category/screens/dashboard1/screen/createMainStore.dart';
import 'package:category/utils/constant.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Role { Partner, Customer }

class Category extends StatefulWidget {
  Role selectedRole;
  void onChanged(Role selectedRole) {}
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  bool isselected = true;
  ApiResponse _apiResponse = ApiResponse();
  Welcome user;

  _handleRoleUpdate(userId, role)async{
    Welcome userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
    _apiResponse = await updateRole(role, userInfo.token);

    if ((_apiResponse.ApiError as ApiError) == null) {
      SharedPrefs().userRole = role;
      print("roleee"+ SharedPrefs().userRole);
      valueNotifier.value = SharedPrefs().userRole == "partner";
      print("roleee"+valueNotifier.value.toString());
      valueNotifier.notifyListeners();
      setState(() {});
/*      if(SharedPrefs().userRole == 'partner') {


        Navigator.pushNamedAndRemoveUntil(context, '/makeMainStore', ModalRoute.withName('/makeMainStore'),
            arguments: (_apiResponse.Data));

      }else{
        Navigator.pushNamedAndRemoveUntil(context, '/dashboard', ModalRoute.withName('/dashboard'),
            arguments: (_apiResponse.Data));
      }*/

    } else {
      showInSnackBar((_apiResponse.ApiError as ApiError).error);
    }
  }

  showInSnackBar(String message){
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  getUserData()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey("token")){
      user = Welcome.fromJson(json.decode((prefs.getString('token'))));
    }
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: ExactAssetImage('assets/images/bg.jpg'),
                  fit: BoxFit.cover),
            ),
            child: Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.black.withOpacity(0.75),
            ),
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            child: Column(
              children: [
                Image.asset(
                  'assets/images/category-logo.png',
                  width: size.width * 0.4,
                  height: size.height * 0.4,
                ),
                // Spacer(),
                Padding(
                  padding: EdgeInsetsDirectional.only(bottom: size.height * 0.04),
                  child: Text(
                    AppLocalizations.of(context).whatRoleDoYouHave,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.white),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.only(start: size.width * 0.04),
                      child: InkWell(
                        onTap: () async {
                          _handleRoleUpdate(user.userData.id, "partner" );
                        },
                        child: Container(
                          width: size.width * 0.4,
                          height: size.height * 0.22,
                          decoration: BoxDecoration(
                              color: widget.selectedRole == Role.Partner
                                  ? Color(0xFFFFFFFF)
                                  : Colors.white60,
                              borderRadius: BorderRadius.circular(5)),
                          child: Column(
                            children: [
                              SizedBox(
                                height: size.height * 0.04,
                              ),
                              Image.asset(
                                'assets/images/partner.png',
                                width: size.width * 0.2,
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.only(top: size.height * 0.02),
                                child: Text(
                                  AppLocalizations.of(context).partner,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.black),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(
                        start: size.width * 0.1,
                      ),
                      child: InkWell(
                        onTap: () async {
                          _handleRoleUpdate(user.userData.id, "customer" );
                        },
                        child: Container(
                          width: size.width * 0.4,
                          height: size.height * 0.22,
                          decoration: BoxDecoration(
                              color: widget.selectedRole == Role.Customer
                                  ? Color(0xFFFFFFFF)
                                  : Colors.white60,
                              borderRadius: BorderRadius.circular(5)),
                          child: Column(
                            children: [
                              SizedBox(
                                height: size.height * 0.04,
                              ),
                              Image.asset(
                                'assets/images/coustmer.png',
                                width: size.width * 0.2,
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.only(top: size.height * 0.02),
                                child: Text(
                                  AppLocalizations.of(context).customer,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.black),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.07,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
