import 'dart:async';
import 'dart:convert';
import 'package:category/TopRow.dart';
import 'package:category/api/storeApis.dart';
import 'package:category/modals/apiResponse.dart';
import 'package:category/modals/new_get_all_fav_model.dart';
import 'package:category/modals/popularStoreModel.dart';
import 'package:category/modals/route_arguments.dart';
import 'package:category/modals/storeByCategory.dart';
import 'package:category/modals/totalSalesModel.dart';
import 'package:category/modals/user.dart';
import 'package:category/screens/dashboard/popularStore.dart';
import 'package:category/screens/dashboard/popular_stores.dart';
import 'package:category/screens/dashboard/search_bar_home.dart';
import 'package:category/utils/constant.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:category/widgets/AllStoreItems.dart';
import 'package:category/widgets/TabWidgets.dart';
import 'package:category/widgets/carousel_banner_widget.dart';
import 'package:category/widgets/carousel_widget.dart';
import 'package:category/widgets/drawer_Widget.dart';
import 'package:category/widgets/noConnection.dart';
import 'package:category/widgets/textWidget.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:category/widgets/storesData.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';

enum Categories { Bags, Jewelry, Shoes, Others }

// ignore: must_be_immutable
class CustomerHome extends StatefulWidget {
  RouteArguments routeArguments;
  NewProduct newProduct;
  NewStore newStore;
  TotalSales sales;

  CustomerHome({this.routeArguments, this.newProduct, this.newStore, this.sales});

  void onChanged(Categories selectedCategory) {}

  @override
  _CustomerHomeState createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  bool favouriteBool = false;
  bool visible = true;
  ApiResponse _apiResponse = ApiResponse();
  Welcome _userInfo;

  showInSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<ApiResponse> _popStore() async {
    _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
    _apiResponse = await popularStore(token: _userInfo.token);
    return _apiResponse;
  }

  Future<ApiResponse> _favThingsItem() async {
    _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
    _apiResponse = await newGetFav(token: _userInfo.token, customerId: _userInfo.userData.id);
    return _apiResponse;
  }

  Future<ApiResponse> _favStore(String id) async {
    _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
    _apiResponse = await favStoreAndPro(token: _userInfo.token);
    return _apiResponse;
  }


  Future<List<Store>> _handleGetStores() async {
    List<Store> str = [];
    _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
    print("TOKEN :::::::::::::::::::::: ${_userInfo.token}");
    ApiResponse apiResponse = await getStoresByCategory(
      category: widget.routeArguments.param1,
      gender: widget.routeArguments.param2,
    );

    str = (apiResponse.Data as StoreByCategory)
        .stores
        .where((element) => element.storeGender.split(',').contains(widget.routeArguments.param5))
        .toList();

    return str;
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
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        drawer: DrawerCustomer(),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Color(0xFFb58563)),
          elevation: 0,
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
        backgroundColor: Colors.white,
        body: isInternetAvailable
            ? Stack(
                children: [
                  ListView(
                    children: [
                      SingleChildScrollView(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              !visible
                                  ? Container()
                                  : Padding(
                                      padding: const EdgeInsetsDirectional.all(8.0),
                                      child: Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.blueGrey[50],
                                          borderRadius: BorderRadius.circular(5.0),
                                        ),
                                        child: TextField(
                                          style: TextStyle(color: Colors.black54, fontSize: 15),
                                          onSubmitted: (value) {
                                            print(value);
                                          },
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                PageTransition(
                                                    duration: Duration(milliseconds: 250),
                                                    type: PageTransitionType.bottomToTop,
                                                    child: SearchBarHomeScreen()));
                                          },
                                          keyboardType: TextInputType.text,
                                          textAlign: TextAlign.center,
                                          textInputAction: TextInputAction.search,
                                          readOnly: true,
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsetsDirectional.only(top: 8),
                                              prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                                              suffixIcon: Visibility(
                                                  visible: false,
                                                  maintainSize: true,
                                                  maintainState: true,
                                                  maintainAnimation: true,
                                                  child: Icon(Icons.search)),
                                              hintText: AppLocalizations.of(context).searchForStores,
                                              hintStyle: TextStyle(fontSize: 13, color: Colors.grey[500]),
                                              border: InputBorder.none,
                                              enabledBorder: InputBorder.none),
                                        ),
                                      ),
                                    ),
                              /*Padding(
                          padding: EdgeInsetsDirectional.only(
                              top: visible
                                  ? size.height * 0.01
                                  : size.height * 0.01),
                          child: Container(
                            // width: size.width,
                            // height: size.height * 0.08,
                            // color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsetsDirectional.only(
                                  start: 10.0, end: 5),
                              child: Row(
                                children: [
                                  TabWidget(
                                    name: "Bags",
                                    onPressed: () {},
                                  ),
                                  TabWidget(
                                    name: "Jewlery",
                                    onPressed: () {},
                                  ),
                                  TabWidget(
                                    name: "Shoes",
                                    onPressed: () {},
                                  ),
                                  TabWidget(
                                    name: "Others",
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),*/
                              /*Padding(
                          padding: EdgeInsetsDirectional.only(
                              start: 10, end: 10, top: size.height * 0.02),
                          child: Container(
                              height: size.height * 0.17, child: Carousel1()),
                        ),*/

                              Padding(
                                padding: EdgeInsetsDirectional.only(start: size.width * 0.03, end: size.width * 0.03, top: size.height * 0.02),
                                child: Container(height: size.height * 0.19, child: CarouselBanner()),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.only(start: 10, end: 10, top: 10, bottom: 10),
                                child: TextWidget(
                                  text: "Recommended",
                                  //text: AppLocalizations.of(context).popularStores,
                                  textSize: 15,
                                  textColor: primary,
                                  isBold: true,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.only(start: size.width * 0.03, top: size.height * 0.005),
                                child: Container(child: Carousel1()),
                              ),

                              /*Container(
                          height: 160,
                          child: FutureBuilder<ApiResponse>(
                            future: _popStore(),
                            builder: (context,AsyncSnapshot<ApiResponse> snapshot) {
                              if(snapshot.hasData){
                                PopluarStoreModel _popular = snapshot.data.Data;
                                return ListView.builder(
                                    itemCount: _popular.data.length,
                                    scrollDirection: Axis.horizontal,
                                    padding: EdgeInsetsDirectional.only(start: 10),
                                    itemBuilder: (context, index) {
                                      return PopularStoresLi(popStore: _popular.data[index],);
                                      // return PopularStores(store: _stores.stores[index]);
                                    });
                              }else{
                                return Center(child: CircularProgressIndicator(color: Colors.brown));
                              }
                            }
                          ),
                        ),*/
                              SizedBox(
                                height: 15,
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  start: 10,
                                  end: 10,
                                ),
                                child: TextWidget(
                                  text: AppLocalizations.of(context).allStores,
                                  textSize: 15,
                                  textColor: primary,
                                  isBold: true,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              FutureBuilder<List<Store>>(
                                  future: _handleGetStores(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      var data = snapshot.data;
                                      return GridView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: data.length,
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: size.width * 0.00001,
                                          mainAxisSpacing: size.width * 0.00001,
                                        ),
                                        itemBuilder: (BuildContext context, int index) {
                                          return AllStoreItems(
                                            store: data[index],
                                            token: _userInfo.token,
                                            customerId: _userInfo.userData.id,
                                          );
                                        },
                                      );
                                    } else {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: brown,
                                        ),
                                      );
                                    }
                                  }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : NoInternet(),
      ),
    );
  }
}
