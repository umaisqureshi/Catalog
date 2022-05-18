import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:category/TopRow.dart';
import 'package:category/api/auth_apis.dart';
import 'package:category/api/storeApis.dart';
import 'package:category/modals/apiResponse.dart';
import 'package:category/modals/discountModel.dart';
import 'package:category/modals/get_all_orders.dart';
import 'package:category/modals/productsByStoresModal.dart';
import 'package:category/modals/route_arguments.dart';
import 'package:category/modals/subStoreModel.dart';
import 'package:category/modals/user.dart';
import 'package:category/screens/dashboard/search_bar_home.dart';
import 'package:category/utils/constant.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:category/widgets/TabWidgets.dart';
import 'package:category/widgets/carousel_banner_widget.dart';
import 'package:category/widgets/carousel_widget.dart';
import 'package:category/widgets/drawer_Widget.dart';
import 'package:category/widgets/noConnection.dart';
import 'package:category/widgets/textWidget.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import '../productDetail.dart';
import '../viewAllDeals.dart';
import 'chatHistoryScreen.dart';
import 'customerHome.dart';
import 'package:http/http.dart' as http;

enum GenderIndex { Men, Women, Kids}

class Home extends StatefulWidget {

  void onChanged(GenderIndex selectedIndex) {}

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ScrollController _scrollController = ScrollController();
  ApiResponse _apiResponse = ApiResponse();

  Welcome _userInfo;

  DiscountModel _discountModel;


  Future<ApiResponse> _handleGetAllOrders() async {
    Welcome _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
    print("TOKEN :::::::::::::::::::::: ${_userInfo.token}");
    return getAllOrders(token: _userInfo.token);
  }

  Future<ApiResponse> _getDiscountSale() async {
    _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
    _apiResponse = await discountSale(token: _userInfo.token);
    return _apiResponse;
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
    super.initState();

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
                  /*Navigator.of(context).pop(true)*/
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
            iconTheme: IconThemeData(color: material.Color(0xFFb58563)),
            title: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed('/ChatHistory');

                /*Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return ChatHistory();
                }));*/
              },
              child: Image.asset("assets/icons/flashChat.png", height: 18, width: 20, color: material.Color(0xFFb58563)),
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
              controller: _scrollController,
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
                                  style: material.TextStyle(color: Colors.black54, fontSize: 15),
                                  onSubmitted: (value) {
                                    print(value);
                                  },
                                  onTap: (){
                                    Navigator.push(context, PageTransition(
                                        duration: Duration(milliseconds: 250),
                                        type: PageTransitionType.bottomToTop, child: SearchBarHomeScreen()));

                                  },
                                  keyboardType: TextInputType.text,
                                  readOnly: true,
                                  textAlign: TextAlign.center,
                                  textInputAction: TextInputAction.search,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsetsDirectional.only(top: 8),
                                      prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                                      hintText: AppLocalizations.of(context).searchForStores,
                                      hintStyle: material.TextStyle(fontSize: 13, color: Colors.grey[500]),
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none),
                                ),
                              ),
                            ),
                      /*Padding(
                        padding: const EdgeInsetsDirectional.only(start: 10, end: 10, top: 10, bottom: 10),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TabWidget(
                                name: AppLocalizations.of(context).categories,
                                onPressed: () {
                                  _scrollController.animateTo(500, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                                },
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              TabWidget(
                                  name: AppLocalizations.of(context).stores,
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/Stores',
                                        arguments: RouteArguments(param1: "Text", param2: "Text2"));
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
                      ),*/
                      Padding(
                        padding:
                            EdgeInsetsDirectional.only(start: size.width * 0.03, end: size.width * 0.03, top: 10, bottom: 10),
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
                            future: _handleGetAllOrders(),
                            builder: (context, AsyncSnapshot<ApiResponse> snapshot) {
                              if (snapshot.hasData) {
                                GetAllOrdersModel _getAllOrdersModel = snapshot.data.Data as GetAllOrdersModel;
                                if (_getAllOrdersModel == null && _getAllOrdersModel.orders.isEmpty) {
                                  return Container();
                                }
                                List<Item> _items = [];
                                List<Item> _newItems = [];
                                _getAllOrdersModel.orders.forEach((element) {
                                  element.items.forEach((element) {
                                    _items.add(element);
                                  });
                                });
                                _items.sort((a, b) {
                                  return b.sold.compareTo(a.sold);
                                });
                                _newItems = _items;
                                return ListView(
                                  shrinkWrap: true,
                                  scrollDirection: material.Axis.horizontal,
                                  children: _newItems
                                      .map((e) => material.Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Column(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Product pro = Product(id: e.id, price: int.tryParse(e.price.split(".").first), images: [e.imageUrl], productName: e.productName,storeId: e.storeId, sold: e.sold,);
                                                  Navigator.of(context).pushNamed("/ProductDetail",arguments: RouteArguments(param1: pro));
                                                },
                                                child: Container(
                                                  height: 80,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                      //color: Colors.brown,
                                                      ),
                                                  child: Image.network(
                                                    e.imageUrl,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  e.productName,
                                                  style: material.TextStyle(fontWeight: FontWeight.w500),
                                                ),
                                              )
                                            ],
                                          )))
                                      .toList(),
                                );
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.brown,
                                  ),
                                );
                              }
                            }),

                        /*child: FutureBuilder<ApiResponse>(
                            future: _handleGetAllOrders(),
                            builder: (context, AsyncSnapshot<ApiResponse> snapshot) {
                              if (snapshot.hasData) {
                                GetAllOrdersModel _getAllOrdersModel = snapshot.data.Data as GetAllOrdersModel;
                                return _getAllOrdersModel != null
                                    ? ListView.builder(

                                    scrollDirection: material.Axis.horizontal,
                                    padding: EdgeInsetsDirectional.only(
                                        start: 10),


                          itemCount: _getAllOrdersModel.orders.length,
                                    itemBuilder: (context, index) {

                                      return InkWell(
                                        onTap: (){
                                          Navigator.of(context).pushNamed(
                                              '/SubStoreDetails',
                                              arguments: SubStoreH(
                                                  id: _getAllOrdersModel.orders[index].id,
                                                  storeName: "",
                                                  storeCategory: "",
                                                  storeLogo: _getAllOrdersModel.orders[index].items[index].imageUrl));
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
                                                      _getAllOrdersModel.orders[index].items[index].imageUrl,
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
                                                      _getAllOrdersModel.orders[index].items[index].productName),
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
                            }),*/
                      ),

                      /*Container(
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
                                        scrollDirection: material.Axis.horizontal,
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
                      ),*/

                      Padding(
                        padding:
                            EdgeInsetsDirectional.only(start: size.width * 0.03, end: size.width * 0.03, top: size.height * 0.02),
                        child: Container(height: size.height * 0.19, child: CarouselBanner()),
                      ),

                      /*Padding(
                        padding: EdgeInsetsDirectional.only(
                            start: size.width * 0.03, top: size.height * 0.005),
                        child: Container(child: Carousel1()),
                      ),*/
                      Padding(
                        padding:
                            EdgeInsetsDirectional.only(start: size.width * 0.03, end: size.width * 0.03, top: 10, bottom: 10),
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

                                /*Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return ViewAllDeals();
                                }));*/
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
                            builder: (context, AsyncSnapshot<ApiResponse> snapshot) {
                              if (snapshot.hasData) {
                                _discountModel = snapshot.data.Data as DiscountModel;
                                return _discountModel != null
                                    ? ListView.builder(
                                        itemCount: _discountModel.data.length,
                                        scrollDirection: material.Axis.horizontal,
                                        padding: EdgeInsetsDirectional.only(start: 10),
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              Navigator.of(context).pushNamed('/SubStoreDetails',
                                                  arguments: SubStoreH(
                                                      userId: _userInfo.userData.id,
                                                      id: _discountModel.data[index].storeId,
                                                      storeName: "",
                                                      storeCategory: "",
                                                      storeLogo: _discountModel.data[index].discountImg));
                                            },
                                            child: Padding(
                                              padding: const EdgeInsetsDirectional.only(end: 8.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Card(
                                                    shape: CircleBorder(),
                                                    elevation: 5,
                                                    child: SizedBox(
                                                        height: 80,
                                                        width: 80,
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(180),
                                                          child: Image.network(
                                                            _discountModel.data[index].discountImg,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        )),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  TextWidget(
                                                    text: AppLocalizations.of(context)
                                                        .discountMessage(_discountModel.data[index].discount),
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
                        padding:
                            EdgeInsetsDirectional.only(start: size.width * 0.03, end: size.width * 0.03, bottom: 10, top: 10),
                        child: TextWidget(
                          text: AppLocalizations.of(context).categories,
                          textSize: 15,
                          textColor: primary,
                          isBold: true,
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: EdgeInsetsDirectional.only(start: size.width * 0.03, end: size.width * 0.03),
                          child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: categoriesObj.category.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    InkWell(
                                      onTap: () async {


                                        /*Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                                    return CustomerHome(
                                                      category: categoriesObj
                                                          .category[index].category,
                                                    );
                                                  }));*/
                                        //  }

                                        if(categoriesObj.category[index].category.genderSpecific == true){
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
                                                            Text("Select Gender"),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                              children: <Widget>[
                                                                InkWell(
                                                                  onTap: (){
                                                                    Navigator.of(context).pushNamed('/customerHome',
                                                                        arguments: RouteArguments(param1: categoriesObj.category[index].category.category, param5: GenderIndex.Men.index.toString()));
                                                                    /*Navigator.push(context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) {
                                                                            return CustomerHome(
                                                                              category: categoriesObj
                                                                                  .category[index].category,
                                                                              genderFilter: "Male",
                                                                            );
                                                                          }));*/
                                                                  },
                                                                  child: Container(
                                                                    height: 120,
                                                                    width: 100,
                                                                    child: Card(
                                                                      elevation: 2,
                                                                      color:  Colors.white,
                                                                      child: Column(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Container(
                                                                            width: 100,
                                                                            height: 90,
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
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                  onTap: (){
                                                                    Navigator.of(context).pushNamed('/customerHome',
                                                                        arguments: RouteArguments(param1: categoriesObj.category[index].category.category,param5: GenderIndex.Women.index.toString()));
                                                                    /*Navigator.push(context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) {
                                                                            return CustomerHome(
                                                                              category: categoriesObj
                                                                                  .category[index].category,
                                                                              genderFilter: "Female",
                                                                            );
                                                                          }));*/
                                                                  },
                                                                  child: Container(

                                                                    height: 120,
                                                                    width: 100,
                                                                    child: Card(
                                                                      color: Colors.white,
                                                                      elevation: 2,
                                                                      child: Column(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Container(
                                                                            width: 100,
                                                                            height: 90,
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
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                  onTap: (){
                                                                    Navigator.of(context).pushNamed('/customerHome',
                                                                        arguments: RouteArguments(param1: categoriesObj.category[index].category.category, param5: GenderIndex.Kids.index.toString()));
                                                                    /*Navigator.push(context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) {
                                                                            return CustomerHome(
                                                                              category: categoriesObj
                                                                                  .category[index].category,
                                                                              genderFilter: "Female",
                                                                            );
                                                                          }));*/
                                                                  },
                                                                  child: Container(
                                                                    height: 120,
                                                                    width: 100,
                                                                    child: Card(
                                                                      color: Colors.white,
                                                                      elevation: 2,
                                                                      child: Column(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Container(
                                                                            width: 100,
                                                                            height: 90,
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
                                                                                "assets/images/senjuti-kundu-JfolIjRnveY-unsplash.jpg",
                                                                                fit: BoxFit
                                                                                    .cover,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Center(
                                                                            child: Text(
                                                                              "Kids",
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
                                          Navigator.of(context).pushNamed('/customerHome',
                                              arguments: RouteArguments(param1: categoriesObj.category[index].category.category));

                                        }

                                      },
                                      child: Container(
                                        height: 120,
                                        child: Stack(
                                          children: [
                                            Opacity(
                                              opacity: 0.7,
                                              child: Image.network(
                                                categoriesObj.category[index].categoryImg,
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                              ),
                                            ),
                                            Center(
                                              child: Container(
                                                height: 40,
                                                width: 150,
                                                decoration:
                                                    BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.black26),
                                                child: Center(
                                                  child: Text(
                                                    categoriesObj.category[index].category.category,
                                                    style: material.TextStyle(
                                                      fontSize: 17,
                                                      fontWeight: FontWeight.bold,
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
  }



}
