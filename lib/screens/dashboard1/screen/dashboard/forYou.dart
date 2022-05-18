import 'dart:async';
import 'dart:convert';

import 'package:category/api/storeApis.dart';
import 'package:category/modals/apiResponse.dart';
import 'package:category/modals/revenue_model.dart';
import 'package:category/modals/sale_by_month_model.dart';
import 'package:category/modals/totalSalesModel.dart';
import 'package:category/modals/user.dart';
import 'package:category/screens/dashboard1/widgets/textWidget.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:category/widgets/noConnection.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:category/utils/constant.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class MonthSelector {
  String month;
  bool selected;

  MonthSelector({this.month, this.selected});
}

class Sale extends StatefulWidget {
  List<MonthSelector> Months = [
    MonthSelector(month: 'Jan', selected: false),
    MonthSelector(month: 'Feb', selected: false),
    MonthSelector(month: 'March', selected: false),
    MonthSelector(month: 'April', selected: false),
    MonthSelector(month: 'May', selected: false),
    MonthSelector(month: 'June', selected: false),
    MonthSelector(month: 'July', selected: false),
    MonthSelector(month: 'August', selected: false),
    MonthSelector(month: 'Sept', selected: false),
    MonthSelector(month: 'Oct', selected: false),
    MonthSelector(month: 'Nov', selected: false),
    MonthSelector(month: 'Dec', selected: false),
  ];
  bool isLeft;

  Sale({this.isLeft});

  @override
  _SaleState createState() => _SaleState();
}

class _SaleState extends State<Sale> {

  int month = 1;
  bool salesType = false;

  Color rightColors, leftColors, rightIconColor, leftIconColor;

  PageController pageController = PageController();

  Map<String , int> monthMap = {
    'Jan': 1,
    'Feb': 2,
    'March': 3,
    'April': 4,
    'May': 5,
    'June': 6,
    'July': 7,
    'August': 8,
    'Sept': 9,
    'Oct': 10,
    'Nov': 11,
    'Dec': 12,
  };

  bool isInternetAvailable = true;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  ApiResponse _apiResponse = ApiResponse();
  Welcome _userInfo;

  Future<ApiResponse> _revenue() async {
    _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
    _apiResponse =
    await revenueOfPartner(token: _userInfo.token, storeId: SharedPrefs().mainStoreId);
    return _apiResponse;
  }

  Future<ApiResponse> _totalStoreSales() async {
    _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
    _apiResponse =
    await totalStoreSales(token: _userInfo.token, storeId: SharedPrefs().mainStoreId);
    return _apiResponse;
  }

  Future<ApiResponse> _salesMonth({String status}) async {
    _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
    _apiResponse =
    await salesByMonth(token: _userInfo.token, storeId: SharedPrefs().mainStoreId, month: month, status: status);
    return _apiResponse;
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
            text: AppLocalizations.of(context).salesHeading,
            textSize: 18,
            textColor: primary,
            isBold: true,
          ),
        ),
        body: isInternetAvailable ? SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsDirectional.only(top: size.height * 0.01),
            child: Column(
              children: [
                /*Padding(
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
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.center,
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsetsDirectional.only(top: 8),
                          prefixIcon:
                              Icon(Icons.search, color: Colors.grey[500]),
                          suffixIcon: Visibility(
                              visible: false,
                              maintainSize: true,
                              maintainState: true,
                              maintainAnimation: true,
                              child: Icon(Icons.search)),
                          hintText: AppLocalizations.of(context).searchAndDiscover,
                          hintStyle: TextStyle(
                              fontSize: 13, color: Colors.grey[500]),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none),
                    ),
                  ),
                ),*/
                Padding(
                  padding: EdgeInsetsDirectional.only(
                      end: size.width * 0.7, top: size.height * 0.02),
                  child: TextWidget(
                    text: AppLocalizations.of(context).overview,
                    textSize: 18,
                    isBold: true,
                    textColor: Colors.black,
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.only(top: size.width * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Card(
                        elevation: 3,
                        child: Container(
                          width: size.width * 0.43,
                          height: size.height * 0.14,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.only(
                                    start: size.width * 0.05,
                                    top: size.height * 0.02),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/icons/increased-revenue.png',
                                      width: 24,
                                      height: 24,
                                      color: Colors.grey,
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.only(
                                          start: size.width * 0.02,
                                          top: size.height * 0.01),
                                      child: TextWidget(
                                        text: AppLocalizations.of(context).revenue,
                                        textSize: 15,
                                        isBold: true,
                                        textColor: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                EdgeInsetsDirectional.only(top: size.width * 0.03),
                                child: FutureBuilder<ApiResponse>(
                                  future: _revenue(),
                                  builder: (context,AsyncSnapshot<ApiResponse> snapshot) {
                                    if (snapshot.hasData){
                                      RevenueModel _reven;
                                      _reven = snapshot.data.Data;
                                      return TextWidget(
                                        text: "\$"+ _reven.data.revenue.toString(),
                                        textSize: 20,
                                        isBold: true,
                                      );
                                    }else{
                                      return Center(child: CircularProgressIndicator(color: Colors.brown,));
                                    }
                                  }
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        elevation: 3,
                        child: Container(
                          width: size.width * 0.43,
                          height: size.height * 0.15,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.only(
                                    start: size.width * 0.05,
                                    top: size.height * 0.02),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/icons/product.png',
                                      width: 24,
                                      height: 24,
                                      color: Colors.grey,
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.only(
                                          start: size.width * 0.02,
                                          top: size.height * 0.01),
                                      child: TextWidget(
                                        text: AppLocalizations.of(context).itemsSold,
                                        textSize: 15,
                                        isBold: true,
                                        textColor: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                EdgeInsetsDirectional.only(top: size.width * 0.03),
                                child: FutureBuilder<ApiResponse>(
                                  future: _totalStoreSales(),
                                  builder: (context, AsyncSnapshot<ApiResponse> snapshot) {
                                    if(snapshot.hasData){
                                      TotalSales _totalSale;
                                      _totalSale = snapshot.data.Data;
                                      return TextWidget(
                                        text: _totalSale.data.sales.toString(),
                                        textSize: 20,
                                        isBold: true,
                                      );
                                    }else{
                                      return Center(child: CircularProgressIndicator(color: Colors.brown));
                                    }
                                  }
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.only(
                      end: size.width * 0.62, top: size.height * 0.02),
                  child: TextWidget(
                    text: AppLocalizations.of(context).recentSales,
                    textSize: 18,
                    isBold: true,
                    textColor: Colors.black,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
                Center(
                  child: Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          color: Colors.brown[50],
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      Positioned(
                        left: 4,
                        top: 4,
                        bottom: 4,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              leftColors = Color(0xFFb58563);
                              widget.isLeft = true;
                              rightColors = Colors.white;
                              rightIconColor = Colors.black12;
                              leftIconColor = Colors.white;
                              salesType = false;
                            });
                            /*pageController.animateToPage(0,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.fastLinearToSlowEaseIn);*/
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.39,
                            height: MediaQuery.of(context).size.height * 0.05,
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: widget.isLeft
                                  ? Color(0xFFb58563)
                                  : Colors.brown[50] ?? Color(0xFFb58563),
                            ),
                            child: Center(
                              child: Container(
                                child: Text("Purchases", style: TextStyle(color: widget.isLeft ? Colors.white : Colors.black87),),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 4,
                        top: 4,
                        bottom: 4,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              rightColors = Color(0xFFb58563);
                              rightIconColor = Colors.white;
                              leftIconColor = Colors.black12;
                              leftColors = Colors.white;
                              widget.isLeft = false;
                              salesType = true;
                            });
                            /*pageController.animateToPage(1,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.fastLinearToSlowEaseIn);*/
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.39,
                            height: MediaQuery.of(context).size.height * 0.05,
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: widget.isLeft
                                  ? Colors.brown[50]
                                  : Color(0xFFb58563) ?? Color(0xFFb58563),
                            ),
                            child: Center(
                              child: Container(
                                child: Text("Orders", style: TextStyle(color: widget.isLeft ? Colors.black87 : Colors.white),),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.only(
                      top: size.height * 0.03,
                      bottom: size.height * 0.02,
                      start: 10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: widget.Months.map((e) => Tab(
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 800),
                              child: TextButton(
                                  onPressed: () {
                                    e.selected = true;
                                    setState(() {
                                      month = monthMap[e.month];
                                    });
                                    widget.Months.where((element) => element.month != e.month)
                                        .forEach((element) {
                                      element.selected = false;
                                      setState(() {
                                      });
                                      print("Selected Month :::::::::::::::::::::: $month");
                                    });
                                  },
                                  child: Text(
                                    e.month,
                                    style: TextStyle(
                                        fontSize: e.selected ? 22 : 18,
                                        color: e.selected
                                            ? Colors.black
                                            : Colors.grey),
                                  )),
                            ),
                          )).toList(),
                    ),
                  ),
                ),
                //TODO: Implement the api of orders for partners here...
                salesType ? Container(
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(
                        start: size.width * 0.04, end: size.width * 0.04),
                    child: FutureBuilder<ApiResponse>(
                      future: _salesMonth(status: "Pending"),
                      builder: (context,AsyncSnapshot<ApiResponse> snapshot) {
                        if(snapshot.hasData){
                          SalesByMonth _saleby;
                          _saleby= snapshot.data.Data;
                          return _saleby.data.isNotEmpty ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: _saleby.data.first.items.length,
                            itemBuilder: (context, index) {
                               print("ALL ALL SOLED PRODUCTS ############################################### "+ _saleby.data.length.toString());
                              return Padding(
                                padding: const EdgeInsetsDirectional.only(top: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: Color(0xFF707070).withOpacity(0.2)),
                                      color: Colors.white),
                                  child: ListTile(
                                    leading: Container(
                                      height: size.height,
                                      width: size.width * 0.18,
                                      color: Color(0xFFF1F1F1),
                                      child: Image.network(
                                        _saleby.data.first.items[index].imageUrl,
                                        // 'assets/images/versacebag.png',
                                        width: 15,
                                        fit: BoxFit.cover,
                                        height: 15,
                                      ),
                                    ),
                                    title: TextWidget(
                                      text: _saleby.data.first.items[index].productName,
                                      textColor: Colors.black,
                                      isBold: true,
                                      textSize: 16,
                                    ),
                                    subtitle: TextWidget(
                                      text: DateFormat('dd MMM yyyy').format(
                                          DateTime.fromMillisecondsSinceEpoch(_saleby.data.first.items[index].time)),
                                      textColor: Colors.black.withOpacity(0.6),
                                      isBold: true,
                                      textSize: 12,
                                    ),
                                    trailing: Padding(
                                      padding:
                                      EdgeInsetsDirectional.only(end: size.width * 0.05),
                                      child: TextWidget(
                                        text: "\$"+_saleby.data.first.items[index].price,
                                        textColor: Colors.black.withOpacity(0.6),
                                        isBold: true,
                                        textSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ) : Container();
                        }else{
                          return Container();
                        }
                      }
                    ),
                  ),
                ) : Container(
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(
                        start: size.width * 0.04, end: size.width * 0.04),
                    child: FutureBuilder<ApiResponse>(
                        future: _salesMonth(status: "Completed"),
                        builder: (context,AsyncSnapshot<ApiResponse> snapshot) {
                          if(snapshot.hasData){
                            SalesByMonth _saleby;
                            _saleby= snapshot.data.Data;
                            //####################################
                            //TODO ::: Extract a single list of products map from the response model
                            List<Item> products = [];
                            _saleby.data.forEach((element) {
                              element.items.forEach((ele) {
                                products.add(ele);
                              });
                            });
                            print("LIST OF ITEMS :::::: ${products.length}");
                            //####################################
                            return _saleby.data.isNotEmpty ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: products.length,
                              physics: NeverScrollableScrollPhysics(),
                              //_saleby.data.first.items.length,
                              itemBuilder: (context, index) {
                                print("ALL ALL SOLED PRODUCTS ############################################### "+ _saleby.data.length.toString());
                                return Padding(
                                  padding: const EdgeInsetsDirectional.only(top: 8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: Color(0xFF707070).withOpacity(0.2)),
                                        color: Colors.white),
                                    child: ListTile(
                                      leading: Container(
                                        height: size.height,
                                        width: size.width * 0.18,
                                        color: Color(0xFFF1F1F1),
                                        child: Image.network(
                                          products[index].imageUrl,
                                          //_saleby.data.first.items[index].imageUrl,
                                          // 'assets/images/versacebag.png',
                                          width: 15,
                                          fit: BoxFit.cover,
                                          height: 15,
                                        ),
                                      ),
                                      title: TextWidget(
                                        text: products[index].productName,
                                        //_saleby.data.first.items[index].productName,
                                        textColor: Colors.black,
                                        isBold: true,
                                        textSize: 16,
                                      ),
                                      subtitle: TextWidget(
                                        text: DateFormat('dd MMM yyyy').format(
                                            DateTime.fromMillisecondsSinceEpoch(products[index].time)),
                                        //_saleby.data.first.items[index].time.toString(),
                                        textColor: Colors.black.withOpacity(0.6),
                                        isBold: true,
                                        textSize: 12,
                                      ),
                                      trailing: Padding(
                                        padding:
                                        EdgeInsetsDirectional.only(end: size.width * 0.05),
                                        child: TextWidget(
                                          text: "\$ "+products[index].price,
                                          textColor: Colors.black.withOpacity(0.6),
                                          isBold: true,
                                          textSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ) : Container();
                          }else{
                            return Container();
                          }
                        }
                    ),
                  ),
                ),
              ],
            ),
          ),
        ) : NoInternet(),
      ),
    );
  }
}
