import 'dart:async';

import 'package:category/screens/dashboard1/widgets/dividerWidget.dart';
import 'package:category/screens/dashboard1/widgets/textWidget.dart';
import 'package:category/widgets/noConnection.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:category/utils/constant.dart';
import 'package:flutter/services.dart';

class Fav extends StatefulWidget {
  @override
  _FavState createState() => _FavState();
}

class _FavState extends State<Fav> {

  bool isInternetAvailable = true;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

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
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: TextWidget(
            text: AppLocalizations.of(context).chat,
            textSize: 18,
            textColor: primary,
            isBold: true,
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: isInternetAvailable ? Container(
          height: double.infinity,
          width: double.infinity,
          child: Stack(
            children: [
              Positioned(
                top: 5,
                child: SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height / 1.2,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        DividerWidget(),
                        Spacer(),
                        TextWidget(
                          text: AppLocalizations.of(context).noFavouriteYet,
                          textSize: 16,
                          textColor: primary,
                          isBold: true,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: TextWidget(
                            text:
                            AppLocalizations.of(context).favouriteMessage,
                            textSize: 15,
                            textColor: primary,
                          ),
                        ),
                        Spacer()
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ) : NoInternet(),
      ),
    );
  }
}
