import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:category/api/storeApis.dart';
import 'package:category/modals/apiError.dart';
import 'package:category/modals/apiResponse.dart';
import 'package:category/modals/categoryModel.dart';
import 'package:category/modals/user.dart';
import 'package:category/provider/locale_provider.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:category/widgets/noConnection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:category/utils/constant.dart';

import 'dashboard1/screen/createMainStore.dart';
import 'dashboard1/screen/showStatusMessage.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  Animation _animation;
  AnimationController _animationController;

  bool get isLogin => FirebaseAuth.instance.currentUser != null;

  String get userId => FirebaseAuth.instance.currentUser.uid;
  bool isInternetAvailable = true;

  ConnectivityResult previous;

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  Welcome userInfo;

  showInSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
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

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        setState(() {
          isInternetAvailable = true;
        });
        if (isInternetAvailable) {

          if (SharedPrefs().isTokenAvailable()) {
            if (SharedPrefs().isUserRoleAvailable()) {

              String role = SharedPrefs().userRole;
              if (role == 'partner' ) {
                if (SharedPrefs().isCreatedMainStoreAvailable() &&
                    SharedPrefs().createdMainStore) {
                  if (SharedPrefs().mainStoreStatus) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/dashboardPartner', (route) => false);
                  } else {
                    Navigator.of(context).pushNamedAndRemoveUntil('/ShowStatusMessagePartner', (route) => false);
                    /*Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (context) {
                      return StatusMessage();
                    }), (route) => false);*/
                  }
                } else
                  Navigator.of(context).pushNamedAndRemoveUntil('/makeMainStore', (route) => false, arguments: null);

                  /*Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (context) {
                    return MakeMainStore(
                      isRequest: false,
                    );
                  }), (route) => false);*/

              } else {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/dashboard', (route) => false);
              }
            } else {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/category', (route) => false);
            }
          } else {
            Navigator.pushNamedAndRemoveUntil(
                context, '/auth', (route) => false);
          }
        }
        break;
      default:
        setState(() => isInternetAvailable = false);
        break;
    }
  }


  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2500));
    _animation = Tween(begin: 0.3, end: 10.0).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeInToLinear));

    _animationController.forward();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      if (SharedPrefs().isTokenAvailable()) {
        userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
        await getCategoriesData(userInfo.token);

      }
      await Future.delayed(Duration(seconds: 3), () {});
      initConnectivity();
      _connectivitySubscription =
          _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    });
    super.initState();
  }

  @override
  void dispose() {
    if(_connectivitySubscription!=null)_connectivitySubscription.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: isInternetAvailable
              ? AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Container(
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: _animation.value * 20,
                        width: _animation.value * 20,
                      ),
                    );
                  },
                )
              : NoInternet(),
        ),
      ),
    );
  }
}
