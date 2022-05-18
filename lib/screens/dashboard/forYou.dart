import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:category/api/auth_apis.dart';
import 'package:category/api/storeApis.dart';
import 'package:category/modals/apiResponse.dart';
import 'package:category/modals/discountModel.dart';
import 'package:category/modals/get_all_orders.dart';
import 'package:category/modals/route_arguments.dart';
import 'package:category/modals/subStoreModel.dart';
import 'package:category/modals/user.dart';
import 'package:category/screens/dashboard1/widgets/carousel_widget.dart';
import 'package:category/screens/dashboard1/widgets/dividerWidget.dart';
import 'package:category/utils/constant.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:category/widgets/TabWidgets.dart';
import 'package:category/widgets/backIconWidget.dart';
import 'package:category/widgets/buttonWidget.dart';
import 'package:category/widgets/drawer_Widget.dart';
import 'package:category/widgets/noConnection.dart';
import 'package:category/widgets/textWidget.dart';
import 'package:category/widgets/topBarWidget.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';

import '../../TopRow.dart';
import 'best_deals_view_all.dart';
import 'latest_sales_view_all.dart';

class ForYou extends StatefulWidget {
  @override
  _ForYouState createState() => _ForYouState();
}

class _ForYouState extends State<ForYou> {
  ApiResponse _apiResponse = ApiResponse();

  Welcome _userInfo;

  DiscountModel _discountModel;

  List<Item> _items = [];
  List<Item> _newItems = [];

  List<BestDealsItem> _items1 = [];
  List<BestDealsItem> _newItems1 = [];


  Future<ApiResponse> _getDiscountSale() async {
    Welcome _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
    print("TOKEN :::::::::::::::::::::: ${_userInfo.token}");
    _newItems1.clear();
    _items1.clear();
    await discountSale(token: _userInfo.token).then((value) {
      DiscountModel _discountModel =
      value.Data as DiscountModel;

      _discountModel.data.forEach((element) {
        _items1.add(element);
        _newItems1 = _items1;
        if(mounted){
          setState(() {});
        }

    });

      _items.sort((a, b){
        return b.sold.compareTo(a.sold);
      });
      _newItems = _items;
      if(mounted){
        setState(() {});
      }
    });

  }

  Future<ApiResponse> _handleGetAllOrders() async {
    Welcome _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
    print("TOKEN :::::::::::::::::::::: ${_userInfo.token}");
    _newItems.clear();
    _items.clear();
   await getAllOrders(token: _userInfo.token).then((value) {
     GetAllOrdersModel _getAllOrdersModel =
     value.Data as GetAllOrdersModel;
       _getAllOrdersModel.orders.forEach((element) {
         element.items.forEach((element) {
           _items.add(element);
         });
       });
       _items.sort((a, b){
         return b.sold.compareTo(a.sold);
       });
       _newItems = _items;
     if(mounted){
       setState(() {});
     }
   });

  }


  bool visible = true;
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

    Welcome user = Welcome.fromJson(json.decode(SharedPrefs().token));
    print("User Id :::::::::::::::::::::::::::: ${user.userData.id}");
    initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _handleGetAllOrders();
    });

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _getDiscountSale();



    });

    super.initState();

    print("User Token::::::::::::::::::::::" + SharedPrefs().token);



/*    _firebaseMessaging.getToken().then((value) {
     var _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
      FirebaseFirestore.instance
          .collection('token')
          .doc(_userInfo.userData.id)
          .set({
        'token': value,
      }, SetOptions(merge: true));
    });*/
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
            text: AppLocalizations.of(context).forYou,
            textSize: 18,
            textColor: primary,
            isBold: true,
          ),
        ),
        body: isInternetAvailable ? ListView(
          shrinkWrap: true,
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsetsDirectional.only(
                    start: size.width * 0.03,
                    end: size.width * 0.03,
                    top: 10,
                    bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                      text: AppLocalizations.of(context).latestSales,
                      textSize: 15,
                      textColor: primary,
                      isBold: true,
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, PageTransition(
                            duration: Duration(milliseconds: 250),
                            type: PageTransitionType.bottomToTop, child: LatestSalesViewAllScreen()));
                      },
                      child: TextWidget(
                        text: AppLocalizations.of(context).viewAll,
                        textSize: 15,
                        textColor: primary,
                        isBold: false,
                      ),
                    ),
                  ],
                ),
              ),
            ),
         ..._newItems.take(4)
               .map((e) => Padding(
               padding: const EdgeInsets.all(5.0),
               child: Stack(
                 alignment: Alignment.bottomCenter,
                 children: [
                   Container(
                     height: 130,
                     width: double.infinity,
                     decoration: BoxDecoration(
                       color: Colors.brown,
                     ),
                     child: Image.network(
                       e.imageUrl,
                       fit: BoxFit.cover,
                     ),
                   ),
                   Container(
                     padding: EdgeInsets.all(5.0),
                     width: double.infinity,
                     color: Colors.black26,
                     child: Text(
                       e.productName,
                       style: TextStyle(
                         color: Colors.white,
                         fontSize: 16,
                           fontWeight:
                           FontWeight.w500),
                     ),
                   )
                 ],
               )))
               .toList(),


            Container(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsetsDirectional.only(
                    start: size.width * 0.03,
                    end: size.width * 0.03,
                    top: 10,
                    bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                      text: AppLocalizations.of(context).bestDeals,
                      textSize: 15,
                      textColor: primary,
                      isBold: true,
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, PageTransition(
                            duration: Duration(milliseconds: 250),
                            type: PageTransitionType.bottomToTop, child: BestDealsViewAllScreen()));
                      },
                      child: TextWidget(
                        text: AppLocalizations.of(context).viewAll,
                        textSize: 15,
                        textColor: primary,
                        isBold: false,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ..._newItems1
                .map((e) => Padding(
                padding: const EdgeInsets.all(5.0),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      height: 130,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.brown,
                      ),
                      child: Image.network(
                        e.discountImg,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(5.0),
                      width: double.infinity,
                      color: Colors.black26,
                      child: Text(
                        e.discount,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight:
                            FontWeight.w500),
                      ),
                    )
                  ],
                )))
                .toList(),


          /*  SizedBox(height: 50,),
            Container(
              height: 120,
              child: FutureBuilder<ApiResponse>(
                  future: _getDiscountSale(),
                  builder:
                      (context, AsyncSnapshot<ApiResponse> snapshot) {
                    if (snapshot.hasData) {
                      _discountModel =
                      snapshot.data.Data as DiscountModel;
                      return _discountModel != null
                          ? ListView.builder(
                          itemCount: _discountModel.data.length,
                          scrollDirection:
                          Axis.horizontal,
                          padding: EdgeInsetsDirectional.only(
                              start: 10),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    '/SubStoreDetails',
                                    arguments: SubStoreH(
                                        id: _discountModel
                                            .data[index].storeId,
                                        storeName: "",
                                        storeCategory: "",
                                        storeLogo: _discountModel
                                            .data[index]
                                            .discountImg));
                              },
                              child: Padding(
                                padding:
                                const EdgeInsetsDirectional
                                    .only(end: 8.0),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  children: [
                                    Card(
                                      shape: CircleBorder(),
                                      elevation: 5,
                                      child: SizedBox(
                                          height: 80,
                                          width: 80,
                                          child: ClipRRect(
                                            borderRadius:
                                            BorderRadius
                                                .circular(
                                                180),
                                            child: Image.network(
                                              _discountModel
                                                  .data[index]
                                                  .discountImg,
                                              fit: BoxFit.cover,
                                            ),
                                          )),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextWidget(
                                      text: AppLocalizations.of(
                                          context)
                                          .discountMessage(
                                          _discountModel
                                              .data[index]
                                              .discount),
                                      isBold: true,
                                      textSize: 10,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })
                          : Center(
                        child: Text("No Sales Found"),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ),*/

          ],
        ) : NoInternet(),
      ),
    );
  }

  /*Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  DividerWidget(),
  SizedBox(
  height: 20,
  ),
  Padding(
  padding:
  const EdgeInsetsDirectional.only(start: 20,end: 20, bottom: 10, top: 10),
  child: Image.asset(
  'assets/images/darkForYou.png',
  scale: 1.5,
  ),
  ),
  Padding(
  padding:
  const EdgeInsetsDirectional.only(start: 20,end: 20, bottom: 5, top: 5),
  child: TextWidget(
  text: AppLocalizations.of(context).forYou,
  textSize: 14,
  textColor: primary,
  isBold: true,
  ),
  ),
  Padding(
  padding: const EdgeInsetsDirectional.only(start: 20,end: 20, bottom: 10, top: 10),
  child: Text(
  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sedhendrerit nisl sed mauris mattis, in convallis mauris lacini. Fusce vitae elit non dui bibendum mollis',
  style: TextStyle(fontSize: 12),
  ),
  ),
  ButtonWidget(
  buttonHeight: 45,
  buttonWidth: MediaQuery.of(context).size.width / 3,
  function: () => Navigator.pushNamed(context, '/k'),
  roundedBorder: 10,
  buttonColor: primary,
  widget: TextWidget(
  text: AppLocalizations.of(context).addBrands,
  textSize: 15,
  textColor: grey,
  ),
  ),
  Padding(
  padding: const EdgeInsetsDirectional.only(start: 20,end: 20,),
  child: TextWidget(
  text: AppLocalizations.of(context).recommended,
  textColor: primary.withOpacity(0.3),
  textSize: 15,
  ),
  ),
  Padding(
  padding: const EdgeInsetsDirectional.only(start: 20,end: 20, bottom: 10, top: 10),
  child: Image.asset(
  'assets/images/Gucci.png',
  height: 60,
  width: 100,
  fit: BoxFit.contain,
  )),
  Padding(
  padding: const EdgeInsetsDirectional.only(start: 15,end: 15, bottom: 10, top: 10),
  child: Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
  Image.asset(
  'assets/images/brand.png',
  width: size.width * 0.3,
  ),
  Image.asset(
  'assets/images/brand.png',
  width: size.width * 0.3,
  ),
  Image.asset(
  'assets/images/brand.png',
  width: size.width * 0.3,
  )
  ],
  ),
  ),
  Padding(
  padding: EdgeInsetsDirectional.only(
  start: size.width * 0.06, top: size.height * 0.05),
  child: Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
  Container(
  width: size.width * 0.35,
  height: size.height * 0.07,
  decoration: BoxDecoration(
  color: Colors.black,
  borderRadius: BorderRadius.circular(4)),
  child: Row(
  children: [
  SizedBox(
  width: 10,
  ),
  Icon(
  Icons.favorite_border,
  color: Colors.white,
  ),
  SizedBox(
  width: 20,
  ),
  TextWidget(
  text: AppLocalizations.of(context).favourites,
  textSize: 12,
  fontFamily: "Yu Gothic UI",
  isBold: true,
  textColor: Colors.white,
  ),
  ],
  ),
  ),
  Padding(
  padding: EdgeInsetsDirectional.only(start: size.width * 0.05),
  child: Container(
  width: size.width * 0.35,
  height: size.height * 0.07,
  decoration: BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(4),
  border: Border.all(color: Color(0xFF0f1013))),
  child: Center(
  child: TextWidget(
  text: AppLocalizations.of(context).notInterested,
  textColor: Colors.black,
  textSize: 12,
  isBold: true,
  fontFamily: "Yu Gothic UI",
  ),
  ),
  ),
  ),
  ],
  ),
  )
  ],
  ),*/



  /*@override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async =>
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context).areYouSure),
          content: Padding(
            padding: const EdgeInsetsDirectional.only(start: 24),
            child: Text(AppLocalizations.of(context).exitApp),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(AppLocalizations.of(context).no),
            ),
            FlatButton(
              onPressed: () => exit(0),
              *//*Navigator.of(context).pop(true)*//*
              child: Text(AppLocalizations.of(context).yes),
            ),
          ],
        ),
      ) ??
          false,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            iconTheme: IconThemeData(color: Color(0xFFb58563)),
            title: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed('/ChatHistory');

                *//*Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return ChatHistory();
                }));*//*
              },
              child: Image.asset("assets/icons/flashChat.png",
                  height: 18, width: 20, color: Color(0xFFb58563)),
            ),
            actions: [
              TopRow(
                isVisible: visible,
                visibility: (visi) {
                  visible = visi;
                  setState(() {});
                },
              )
            ],
          ),
          drawer: DrawerCustomer(),
          backgroundColor: Colors.white,
          body: isInternetAvailable
              ? SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                visible
                    ? Container()
                    : Padding(
                  padding: const EdgeInsetsDirectional.all(8.0),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      // color: Color(0xFFF0EFEF),
                      color: Colors.blueGrey[50],
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: TextField(
                      style: TextStyle(
                          color: Colors.black54, fontSize: 15),
                      onSubmitted: (value) {
                        print(value);
                      },
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.center,
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                          contentPadding:
                          EdgeInsetsDirectional.only(top: 8),
                          prefixIcon: Icon(Icons.search,
                              color: Colors.grey[500]),
                          suffixIcon: Visibility(
                              visible: false,
                              maintainSize: true,
                              maintainState: true,
                              maintainAnimation: true,
                              child: Icon(Icons.search)),
                          hintText: AppLocalizations.of(context)
                              .searchAndDiscover,
                          hintStyle: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[500]),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                      start: 10, end: 10, top: 10, bottom: 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TabWidget(
                          name: AppLocalizations.of(context).categories,
                          onPressed: () {},
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        TabWidget(
                            name: AppLocalizations.of(context).stores,
                            onPressed: () {
                              Navigator.pushNamed(context, '/Stores',
                                  arguments: RouteArguments(
                                      param1: "Text", param2: "Text2"));
                            }),
                        SizedBox(
                          width: 5,
                        ),
                        TabWidget(
                            name: AppLocalizations.of(context).brands,
                            onPressed: () {
                              Navigator.pushNamed(context, '/brands');
                            })
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.only(
                      start: size.width * 0.03,
                      end: size.width * 0.03,
                      top: 10,
                      bottom: 10),
                  child: TextWidget(
                    text: AppLocalizations.of(context).latestSales,
                    textSize: 15,
                    textColor: primary,
                    isBold: true,
                  ),
                ),
                Container(
                  height: 120,
                  child: FutureBuilder<ApiResponse>(
                      future: _getDiscountSale(),
                      builder:
                          (context, AsyncSnapshot<ApiResponse> snapshot) {
                        if (snapshot.hasData) {
                          _discountModel =
                          snapshot.data.Data as DiscountModel;
                          return _discountModel != null
                              ? ListView.builder(
                              itemCount: _discountModel.data.length,
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsetsDirectional.only(
                                  start: 10),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: (){
                                    Navigator.of(context).pushNamed(
                                        '/SubStoreDetails',
                                        arguments: SubStoreH(
                                            id: _discountModel.data[index].storeId,
                                            storeName: "",
                                            storeCategory: "",
                                            storeLogo: _discountModel.data[index].discountImg));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional
                                        .only(end: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                            height: 80,
                                            width: 120,
                                            child: Padding(
                                              padding:
                                              const EdgeInsetsDirectional
                                                  .all(5.0),
                                              child: Image.network(
                                                _discountModel
                                                    .data[index]
                                                    .discountImg,
                                                fit: BoxFit.contain,
                                              ),
                                            )),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          width: 100,
                                          child: TextWidget(
                                            text: AppLocalizations.of(
                                                context).discountMessage(
                                                _discountModel
                                                    .data[index]
                                                    .discount),
                                            isBold: true,
                                            textSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              })
                              : Center(
                            child: Text("No Sales Found"),
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),

                ),

                Padding(
                  padding: EdgeInsetsDirectional.only(
                      start: size.width * 0.03,
                      end: size.width * 0.03,
                      top: 10,
                      bottom: 10),
                  child: TextWidget(
                    text: "Promotions",
                    textSize: 15,
                    textColor: primary,
                    isBold: true,
                  ),
                ),

                Padding(
                  padding: EdgeInsetsDirectional.only(
                      start: size.width * 0.03,
                      top: size.height * 0.005),
                  child: Container(child: Carousel1()),
                ),

                Padding(
                  padding: EdgeInsetsDirectional.only(
                      start: size.width * 0.03,
                      end: size.width * 0.03,
                      top: 10,
                      bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        text: AppLocalizations.of(context).bestDeals,
                        textSize: 15,
                        textColor: primary,
                        isBold: true,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed('/ViewAllDeals');

                          *//*Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return ViewAllDeals();
                                }));*//*
                        },
                        child: TextWidget(
                          text: "View",
                          textSize: 14,
                          isBold: false,
                          textColor: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ),

                //Best Deals List
                Container(
                  height: 120,
                  child: FutureBuilder<ApiResponse>(
                      future: _getDiscountSale(),
                      builder:
                          (context, AsyncSnapshot<ApiResponse> snapshot) {
                        if (snapshot.hasData) {
                          _discountModel =
                          snapshot.data.Data as DiscountModel;
                          return _discountModel != null
                              ? ListView.builder(
                              itemCount: _discountModel.data.length,
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsetsDirectional.only(
                                  start: 10),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: (){
                                    Navigator.of(context).pushNamed(
                                        '/SubStoreDetails',
                                        arguments: SubStoreH(
                                            id: _discountModel.data[index].storeId,
                                            storeName: "",
                                            storeCategory: "",
                                            storeLogo: _discountModel.data[index].discountImg));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional
                                        .only(end: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: [
                                        Card(
                                          shape: CircleBorder(),
                                          elevation: 5,
                                          child: SizedBox(
                                              height: 80,
                                              width: 80,
                                              child: ClipRRect(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(180),
                                                child: Image.network(
                                                  _discountModel
                                                      .data[index]
                                                      .discountImg,
                                                  fit: BoxFit.cover,
                                                ),
                                              )),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TextWidget(
                                          text: AppLocalizations.of(
                                              context)
                                              .discountMessage(
                                              _discountModel
                                                  .data[index]
                                                  .discount),
                                          isBold: true,
                                          textSize: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              })
                              : Center(
                            child: Text("No Sales Found"),
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                ),

                Padding(
                  padding: EdgeInsetsDirectional.only(
                      start: size.width * 0.03,
                      end: size.width * 0.03,
                      bottom: 10,
                      top: 10),
                  child: TextWidget(
                    text: AppLocalizations.of(context).categories,
                    textSize: 15,
                    textColor: primary,
                    isBold: true,
                  ),
                ),
                Container(
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(
                        start: size.width * 0.03, end: size.width * 0.03),
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: categoriesObj.category.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              InkWell(
                                onTap: () async {
                                  if(categoriesObj.category[index].categoryGender != null){
                                    await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Material(
                                                borderRadius: BorderRadius.circular(10),
                                                child: Container(
                                                  height:
                                                  MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                      0.3,
                                                  width:
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                      60,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        10),
                                                  ),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      Text("Select Gender", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: <Widget>[
                                                          InkWell(
                                                            onTap: (){
                                                              Navigator.of(context).pushNamed('/customerHome',arguments:  RouteArguments(param1: categoriesObj
                                                                  .category[index].category, param2: "Male" ));

                                                              *//*Navigator.push(context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) {
                                                                              return CustomerHome(
                                                                                category: categoriesObj
                                                                                    .category[index].category,
                                                                                genderFilter: "Male",
                                                                              );
                                                                            }));*//*
                                                            },
                                                            child: Container(
                                                              height: 150,
                                                              width: 150,
                                                              child: Card(
                                                                elevation: 2,
                                                                color:  Colors.white,
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Container(
                                                                      width: 150,
                                                                      height: 110,
                                                                      decoration:
                                                                      BoxDecoration(
                                                                        borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                            10),
                                                                      ),
                                                                      child:
                                                                      ClipRRect(
                                                                        borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                            10),
                                                                        child: Image
                                                                            .asset(
                                                                          "assets/images/male.jpg",
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Center(
                                                                      child: Text(
                                                                        "Male",
                                                                        style:
                                                                        TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                          15,
                                                                          fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          InkWell(
                                                            onTap: (){
                                                              Navigator.of(context).pushNamed('/customerHome',arguments: RouteArguments(param1: categoriesObj
                                                                  .category[index].category, param2: "Female"));


                                                              *//*Navigator.push(context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) {
                                                                              return CustomerHome(
                                                                                category: categoriesObj
                                                                                    .category[index].category,
                                                                                genderFilter: "Female",
                                                                              );
                                                                            }));*//*
                                                            },
                                                            child: Container(
                                                              height: 150,
                                                              width: 150,
                                                              child: Card(
                                                                color: Colors.white,
                                                                elevation: 2,
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Container(
                                                                      width: 150,
                                                                      height: 110,
                                                                      decoration:
                                                                      BoxDecoration(
                                                                        borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                            10),
                                                                      ),
                                                                      child:
                                                                      ClipRRect(
                                                                        borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                            10),
                                                                        child: Image
                                                                            .asset(
                                                                          "assets/images/female.jpg",
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Center(
                                                                      child: Text(
                                                                        "Female",
                                                                        style:
                                                                        TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                          15,
                                                                          fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        });
                                  }else{
                                    Navigator.of(context).pushNamed('/customerHome',arguments: RouteArguments(param1: categoriesObj.category[index].category));

                                    *//*Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                                    return CustomerHome(
                                                      category: categoriesObj
                                                          .category[index].category,
                                                    );
                                                  }));*//*
                                  }
                                },
                                child: Container(
                                  height: 120,
                                  child: Stack(
                                    children: [
                                      Opacity(
                                        opacity: 0.7,
                                        child: Image.network(
                                          categoriesObj.category[index]
                                              .categoryImg,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        ),
                                      ),
                                      Center(
                                        child: Container(
                                          height: 40,
                                          width: 150,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  10),
                                              color: Colors.black26),
                                          child: Center(
                                            child: Text(
                                              categoriesObj
                                                  .category[index]
                                                  .category,
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight:
                                                FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                            ],
                          );
                        }),
                  ),
                ),
              ],
            ),
          )
              : NoInternet(),
        ),
      ),
    );
  }*/

  /*bool isInternetAvailable = true;
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
            text: AppLocalizations.of(context).forYou,
            textSize: 18,
            textColor: primary,
            isBold: true,
          ),
        ),
        body: isInternetAvailable ? SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DividerWidget(),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.only(start: 20,end: 20, bottom: 10, top: 10),
                child: Image.asset(
                  'assets/images/darkForYou.png',
                  scale: 1.5,
                ),
              ),
              Padding(
                padding:
                const EdgeInsetsDirectional.only(start: 20,end: 20, bottom: 5, top: 5),
                child: TextWidget(
                  text: AppLocalizations.of(context).forYou,
                  textSize: 14,
                  textColor: primary,
                  isBold: true,
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 20,end: 20, bottom: 10, top: 10),
                child: Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sedhendrerit nisl sed mauris mattis, in convallis mauris lacini. Fusce vitae elit non dui bibendum mollis',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              ButtonWidget(
                buttonHeight: 45,
                buttonWidth: MediaQuery.of(context).size.width / 3,
                function: () => Navigator.pushNamed(context, '/k'),
                roundedBorder: 10,
                buttonColor: primary,
                widget: TextWidget(
                  text: AppLocalizations.of(context).addBrands,
                  textSize: 15,
                  textColor: grey,
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 20,end: 20,),
                child: TextWidget(
                  text: AppLocalizations.of(context).recommended,
                  textColor: primary.withOpacity(0.3),
                  textSize: 15,
                ),
              ),
              Padding(
                  padding: const EdgeInsetsDirectional.only(start: 20,end: 20, bottom: 10, top: 10),
                  child: Image.asset(
                    'assets/images/Gucci.png',
                    height: 60,
                    width: 100,
                    fit: BoxFit.contain,
                  )),
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 15,end: 15, bottom: 10, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/images/brand.png',
                      width: size.width * 0.3,
                    ),
                    Image.asset(
                      'assets/images/brand.png',
                      width: size.width * 0.3,
                    ),
                    Image.asset(
                      'assets/images/brand.png',
                      width: size.width * 0.3,
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.only(
                    start: size.width * 0.06, top: size.height * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: size.width * 0.35,
                      height: size.height * 0.07,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(4)),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          TextWidget(
                            text: AppLocalizations.of(context).favourites,
                            textSize: 12,
                            fontFamily: "Yu Gothic UI",
                            isBold: true,
                            textColor: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(start: size.width * 0.05),
                      child: Container(
                        width: size.width * 0.35,
                        height: size.height * 0.07,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Color(0xFF0f1013))),
                        child: Center(
                          child: TextWidget(
                            text: AppLocalizations.of(context).notInterested,
                            textColor: Colors.black,
                            textSize: 12,
                            isBold: true,
                            fontFamily: "Yu Gothic UI",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ) : NoInternet(),
      ),
    );
  }*/
}
