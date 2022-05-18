import 'dart:async';
import 'dart:convert';

import 'package:category/api/storeApis.dart';
import 'package:category/modals/apiResponse.dart';
import 'package:category/modals/discountModel.dart';
import 'package:category/modals/get_fav_things.dart';
import 'package:category/modals/mainStoreModal.dart';
import 'package:category/modals/new_get_all_fav_model.dart';
import 'package:category/modals/route_arguments.dart';
import 'package:category/modals/storeByCategory.dart';
import 'package:category/modals/subStoreModel.dart';
import 'package:category/modals/user.dart';
import 'package:category/screens/viewAllScreen.dart';
import 'package:category/utils/constant.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:category/widgets/bottomBarWidget.dart';
import 'package:category/widgets/dividerWidget.dart';
import 'package:category/widgets/noConnection.dart';
import 'package:category/widgets/textWidget.dart';
import 'package:category/widgets/topBarWidget.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../stores.dart';
import 'customerHomeExtended.dart';
import 'fav_items.dart';
import 'fav_stores.dart';

enum GenderIndex { Men, Women, Kids}

class Deals extends StatefulWidget {
  @override
  _DealsState createState() => _DealsState();

}
class _DealsState extends State<Deals> {
  Welcome _userInfo;
  ApiResponse _apiResponse = ApiResponse();
  DiscountModel _discountModel;
  bool isInternetAvailable = true;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  Future<ApiResponse> _favThingsItem() async {
    _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
    _apiResponse =
        await newGetFav(token: _userInfo.token, customerId: _userInfo.userData.id);
    return _apiResponse;
  }

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

  Future<ApiResponse> _getDiscountSale() async {
    _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
    _apiResponse = await discountSale(token: _userInfo.token);
    return _apiResponse;
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
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: TextWidget(
            textSize: 18,
            textColor: primary,
            text: AppLocalizations.of(context).deals,
            isBold: true,
          ),
        ),
        body: isInternetAvailable
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    DividerWidget(),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.only(end: 20, start: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextWidget(
                            textSize: 15,
                            textColor: primary,
                            text: AppLocalizations.of(context).latestDeals,
                            isBold: true,
                          ),
                          InkWell(
                            onTap: () {

                              Navigator.of(context).pushNamed('/ViewAllScreen', arguments: AppLocalizations.of(context).latestDeals);

                              /*Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return ViewAllScreen(
                                  screenTitle:
                                      AppLocalizations.of(context).latestSales,
                                );
                              })
                              );*/
                            },
                            child: TextWidget(
                              textSize: 15,
                              textColor: primary,
                              text: AppLocalizations.of(context).viewAll,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FutureBuilder<ApiResponse>(
                        future: _getDiscountSale(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            _discountModel =
                                snapshot.data.Data as DiscountModel;
                            return _discountModel != null
                                ? InkWell(
                                  onTap: (){
                                    Navigator.of(context).pushNamed('/SubStoreDetails',
                                        arguments: SubStoreH(
                                            userId: _userInfo.userData.id,
                                            id: _discountModel.data.first.storeId,
                                            storeName: "",
                                            storeCategory: "",
                                            storeLogo: _discountModel.data.first.discountImg));
                                  },
                                  child: Container(
                                      height: 300,
                                      child: ListView.separated(
                                          shrinkWrap: true,
                                          itemBuilder: (context, ind) {
                                            return Padding(
                                              padding: EdgeInsetsDirectional.only(
                                                  start: 20,
                                                  end: 20,
                                                  top: 10,
                                                  bottom: 10),
                                              child: Row(
                                                children: [
                                                  Card(
                                                    elevation: 5,
                                                    child: Container(
                                                      height: 100,
                                                      width: 100,
                                                      child: Image.network(
                                                        _discountModel.data[ind]
                                                            .discountImg,
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      /*TextWidget(
                                                        textSize: 15,
                                                        textColor: primary,
                                                        text: _discountModel
                                                            .data[ind].productId,
                                                        isBold: true,
                                                      ),*/
                                                      TextWidget(
                                                        textSize: 15,
                                                        textColor: primary,
                                                        text: AppLocalizations.of(
                                                                context)
                                                            .discountMessage(
                                                                _discountModel
                                                                    .data[ind]
                                                                    .discount),
                                                      ),
                                                      TextWidget(
                                                        textSize: 15,
                                                        textColor: primary
                                                            .withOpacity(0.4),
                                                        text: _discountModel
                                                            .data[ind].endingDate.substring(0,10),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                          separatorBuilder: (context, index) {
                                            return DividerWidget();
                                          },
                                          itemCount: _discountModel.data.length),
                                    ),
                                )
                                : Center(
                                    child: Text('No Sales Found'),
                                  );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                color: Colors.brown,
                              ),
                            );
                          }
                        }),
                    Container(
                        color: grey,
                        height: 10,
                        margin: EdgeInsetsDirectional.only(top: 10, bottom: 10),
                        width: MediaQuery.of(context).size.width),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                          end: 20, start: 20, top: 20, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextWidget(
                            textSize: 15,
                            textColor: primary,
                            text: AppLocalizations.of(context).yourFavStores,
                            isBold: true,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed("/Stores");

                              /*Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return Stores();
                              }));*/
                            },
                            child: TextWidget(
                              textSize: 15,
                              textColor: primary,
                              text: AppLocalizations.of(context).manage,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                          end: 20, start: 20, top: 0, bottom: 10),
                      child: FutureBuilder<ApiResponse>(
                          future: _favThingsItem(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              NewGetFavThings _fav = snapshot.data.Data as NewGetFavThings;
                              return _fav == null? Container(
                                child: Center(
                                  child: Text(
                                    'You have no favourite Stores',
                                    style: TextStyle(fontSize: 14, color: Colors.black26),
                                  ),
                                ),
                              ): Container(
                                height: 160,
                                child: ListView.builder(
                                    itemCount: _fav.data.stores.length,
                                    scrollDirection: Axis.horizontal,
                                    padding: EdgeInsetsDirectional.only(start: 2),
                                    itemBuilder: (context, index) {
                                      return FavStores(favStore: _fav.data.stores[index]);
                                    }),
                              );

                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Colors.brown,
                                ),
                              );
                            }
                          }),
                    ),

                    /*Container(
                  color: grey,
                  height: 10,
                  margin: const EdgeInsetsDirectional.only(top: 10, bottom: 10),
                  width: MediaQuery.of(context).size.width),
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 20, start: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                      textSize: 15,
                      textColor: primary,
                      text: AppLocalizations.of(context).topCashBack,
                      isBold: true,
                    ),
                    TextWidget(
                      textSize: 15,
                      textColor: primary,
                      text: AppLocalizations.of(context).viewAll,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 20, start: 20, top: 10, bottom: 10),
                child: Row(
                  children: [
                    Card(
                      elevation: 5,
                      child: Container(
                        height: 100,
                        width: 100,
                        child: Image.asset(
                          'assets/images/shopLogo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          textSize: 15,
                          textColor: primary,
                          text: 'Addidas',
                          isBold: true,
                        ),
                        Row(
                          children: [
                            TextWidget(
                              textSize: 15,
                              textColor: primary,
                              text: AppLocalizations.of(context).cashBackDiscount("20"), ///////
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            TextWidget(
                              textSize: 15,
                              textColor: primary.withOpacity(0.4),
                              text: AppLocalizations.of(context).oldCashBackDiscount("12"),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 20, start: 20, top: 10, bottom: 10),
                child: Row(
                  children: [
                    Card(
                      elevation: 5,
                      child: Container(
                        height: 100,
                        width: 100,
                        child: Image.asset(
                          'assets/images/shopLogo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          textSize: 15,
                          textColor: primary,
                          text: 'Addidas',
                          isBold: true,
                        ),
                        Row(
                          children: [
                            TextWidget(
                              textSize: 15,
                              textColor: primary,
                              text: AppLocalizations.of(context).cashBackDiscount("20"), ///////
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            TextWidget(
                              textSize: 15,
                              textColor: primary.withOpacity(0.4),
                              text: AppLocalizations.of(context).oldCashBackDiscount("12"),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),*/
                  ],
                ),
              )
            : NoInternet(),
      ),
    );
  }
}
