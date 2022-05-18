import 'dart:async';
import 'dart:convert';
import 'package:category/api/storeApis.dart';
import 'package:category/modals/apiResponse.dart';
import 'package:category/modals/get_fav_things.dart';
import 'package:category/modals/new_get_all_fav_model.dart';
import 'package:category/modals/user.dart';
import 'package:category/screens/dashboard/fav_subStore.dart';
import 'package:category/utils/constant.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:category/widgets/dividerWidget.dart';
import 'package:category/widgets/noConnection.dart';
import 'package:category/widgets/textWidget.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'fav_items.dart';
import 'fav_stores.dart';

class Fav extends StatefulWidget {
  @override
  _FavState createState() => _FavState();
}

class _FavState extends State<Fav> {
  ApiResponse _apiResponse = ApiResponse();
  Welcome _userInfo;

  Future<ApiResponse> _removeFav() async {
    _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
    _apiResponse = await removeFavo(token: _userInfo.token);
    return _apiResponse;
  }

  Future<ApiResponse> _favThingsItem() async {
    _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
    _apiResponse = await newGetFav(token: _userInfo.token, customerId: _userInfo.userData.id);
    return _apiResponse;
  }

  bool isInternetAvailable = true;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        setState(() {
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
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    super.initState();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: TextWidget(
            text: AppLocalizations.of(context).favourites,
            textSize: 18,
            textColor: primary,
            isBold: true,
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: isInternetAvailable
            ? SingleChildScrollView(
                child: FutureBuilder<ApiResponse>(
                    future: _favThingsItem(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        NewGetFavThings _fav = snapshot.data.Data as NewGetFavThings;
                        return _fav != null
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: med.height * 0.02,
                                  ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.only(start: 10, end: 10, bottom: 15, top: 15),
                                    child: TextWidget(
                                      text: "Favourite products",
                                      textSize: 15,
                                      textColor: primary,
                                      isBold: true,
                                    ),
                                  ),
                                  _fav.data.products.isEmpty
                                      ? Container(
                                          child: Center(
                                            child: Text(
                                              'You have no favourite products',
                                              style: TextStyle(fontSize: 14, color: Colors.black26),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          height: 160,
                                          child: ListView.builder(
                                              itemCount: _fav.data.products.length,
                                              scrollDirection: Axis.horizontal,
                                              padding: EdgeInsetsDirectional.only(start: 2),
                                              itemBuilder: (context, index) {
                                                return FavItems(
                                                  favProducts: _fav.data.products[index],
                                                );
                                              }),
                                        ),

                                  //Fav Stores......................................................
                                  SizedBox(
                                    height: med.height * 0.02,
                                  ),

                                  Padding(
                                    padding: const EdgeInsetsDirectional.only(start: 10, end: 10, bottom: 15, top: 15),
                                    child: TextWidget(
                                      text: "Favourite Stores",
                                      textSize: 15,
                                      textColor: primary,
                                      isBold: true,
                                    ),
                                  ), _fav.data.stores.isEmpty
                                      ? Container(
                                          child: Center(
                                            child: Text(
                                              'You have no favourite Stores',
                                              style: TextStyle(fontSize: 14, color: Colors.black26),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          height: 160,
                                          child: ListView.builder(
                                              itemCount: _fav.data.stores.length,
                                              scrollDirection: Axis.horizontal,
                                              padding: EdgeInsetsDirectional.only(start: 2),
                                              itemBuilder: (context, index) {
                                                return FavStores(favStore: _fav.data.stores[index]);
                                              }),
                                        ),

                                  // Fav subStore
                                  SizedBox(
                                    height: med.height * 0.02,
                                  ),

                                  Padding(
                                    padding: const EdgeInsetsDirectional.only(start: 10, end: 10, bottom: 15, top: 15),
                                    child: TextWidget(
                                      text: "Favourite Sub Stores",
                                      textSize: 15,
                                      textColor: primary,
                                      isBold: true,
                                    ),
                                  ),
                                  _fav.data.substores.isEmpty
                                      ? Container(
                                          child: Center(
                                            child: Text(
                                              'You have no favourite Sub Stores',
                                              style: TextStyle(fontSize: 14, color: Colors.black26),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          height: 160,
                                          child: ListView.builder(
                                              itemCount: _fav.data.substores.length,
                                              scrollDirection: Axis.horizontal,
                                              padding: EdgeInsetsDirectional.only(start: 2),
                                              itemBuilder: (context, index) {
                                                return FavSubStore(
                                                  favSubStore: _fav.data.substores[index],
                                                );
                                              }),
                                        ),
                                ],
                              )
                            : Center(
                                child: Text(
                                  'You have no favourites yet',
                                  style: TextStyle(fontSize: 14, color: Colors.black26),
                                ),
                              );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.brown,
                          ),
                        );
                      }
                    }),
              )
            : NoInternet(),
      ),
    );
  }
}
