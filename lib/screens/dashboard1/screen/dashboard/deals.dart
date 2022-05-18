import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:category/api/storeApis.dart';
import 'package:category/modals/apiResponse.dart';
import 'package:category/modals/barChartModel.dart';
import 'package:category/modals/revenue_model.dart';
import 'package:category/modals/user.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:category/widgets/noConnection.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:category/screens/dashboard1/widgets/textWidget.dart';
import 'package:category/screens/dashboard1/widgets/topBarWidget.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:category/utils/constant.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import '../../../currency.dart';

enum Report { Daily, Weekly, Monthly }

class Reports extends StatefulWidget {
  Report selectedReport;

  void onChanged(Report selectedCategory) {}

  @override
  _ReportsState createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  List<charts.Series> seriesList;

  String time;

  static List<charts.Series<Sales, String>> _createRandomData() {
    final random = Random();

    final desktopSalesData = [
      Sales('2015', random.nextInt(100)),
      Sales('2016', random.nextInt(100)),
      Sales('2017', random.nextInt(100)),
      Sales('2018', random.nextInt(100)),
      Sales('2019', random.nextInt(100)),
    ];

    final tabletSalesData = [
      Sales('2015', random.nextInt(100)),
      Sales('2016', random.nextInt(100)),
      Sales('2017', random.nextInt(100)),
      Sales('2018', random.nextInt(100)),
      Sales('2019', random.nextInt(100)),
    ];

    final mobileSalesData = [
      Sales('2015', random.nextInt(100)),
      Sales('2016', random.nextInt(100)),
      Sales('2017', random.nextInt(100)),
      Sales('2018', random.nextInt(100)),
      Sales('2019', random.nextInt(100)),
    ];

    return [
      charts.Series<Sales, String>(
        id: 'Sales',
        domainFn: (Sales sales, _) => sales.year,
        measureFn: (Sales sales, _) => sales.sales,
        data: desktopSalesData,
        fillColorFn: (Sales sales, _) {
          return charts.MaterialPalette.blue.shadeDefault;
        },
      ),
      charts.Series<Sales, String>(
        id: 'Sales',
        domainFn: (Sales sales, _) => sales.year,
        measureFn: (Sales sales, _) => sales.sales,
        data: tabletSalesData,
        fillColorFn: (Sales sales, _) {
          return charts.MaterialPalette.green.shadeDefault;
        },
      ),
    ];
  }


  barChart() {
    return charts.BarChart(
      seriesList,
      animate: true,
      vertical: true,
      barGroupingType: charts.BarGroupingType.grouped,
      defaultRenderer: charts.BarRendererConfig(
        groupingType: charts.BarGroupingType.grouped,
        strokeWidthPx: 1.0,
      ),
      domainAxis: charts.OrdinalAxisSpec(
        renderSpec: charts.NoneRenderSpec(),
      ),
    );
  }

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
    seriesList = _createRandomData();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      time = AppLocalizations.of(context).weekly;
      setState(() {
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: TextWidget(
            textSize: 18,
            textColor: primary,
            text: AppLocalizations.of(context).reports,
            isBold: true,
          ),
          centerTitle: true,
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: isInternetAvailable ? Padding(
          padding: EdgeInsetsDirectional.only(top: size.width * 0.05),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(start:20, end: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        textSize: 18,
                        textColor: primary,
                        text: "$time"+" "+AppLocalizations.of(context).reports,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.only(top: size.height * 0.04),
                  child: Container(
                    width: size.width,
                    height: size.height*0.08,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.only(
                              start: size.width *0.09,
                              top: size.height *0.02,
                              bottom: size.height*0.01,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                time = AppLocalizations.of(context).daily;
                              });
                            },
                            child: Container(
                              width: size.width * 0.2,
                              height: size.height * 0.3,
                              decoration: BoxDecoration(
                                color: time == AppLocalizations.of(context).daily
                                    ? Color(0xFFb58563)
                                    : Colors.white,
                                border: Border.all(
                                    color: Color(0xFF707070)
                                        .withOpacity(0.2)),
                              ),
                              child: Center(
                                  child: Text(
                                    AppLocalizations.of(context).daily,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  fontFamily: "Yu Gothic UI",
                                  color: time == AppLocalizations.of(context).daily
                                      ? Color(0xFFFFFFFF)
                                      : Colors.black,
                                ),
                              )),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.only(
                              start: size.width * 0.06,
                              top: size.height * 0.02,
                              bottom: size.height * 0.01),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                time = AppLocalizations.of(context).weekly;
                              });
                            },
                            child: Container(
                              width: size.width * 0.2,
                              height: size.height * 0.3,
                              decoration: BoxDecoration(
                                color: time == AppLocalizations.of(context).weekly
                                    ? Color(0xFFb58563)
                                    : Colors.white,
                                border: Border.all(
                                    color: Color(0xFF707070)
                                        .withOpacity(0.2)),
                              ),
                              child: Center(
                                  child: Text(
                                    AppLocalizations.of(context).weekly,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  fontFamily: "Yu Gothic UI",
                                  color: time == AppLocalizations.of(context).weekly
                                      ? Color(0xFFFFFFFF)
                                      : Colors.black,
                                ),
                              )),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.only(
                              start: size.width * 0.06,
                              top: size.height * 0.02,
                              bottom: size.height * 0.01),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                time = AppLocalizations.of(context).monthly;
                              });
                            },
                            child: Container(
                              width: size.width * 0.2,
                              height: size.height * 0.3,
                              decoration: BoxDecoration(
                                color: time == AppLocalizations.of(context).monthly
                                    ? Color(0xFFb58563)
                                    : Colors.white,
                                border: Border.all(
                                    color: Color(0xFF707070)
                                        .withOpacity(0.2)),
                              ),
                              child: Center(
                                  child: Text(
                                    AppLocalizations.of(context).monthly,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  fontFamily: "Yu Gothic UI",
                                  color: time == AppLocalizations.of(context).monthly
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.only(
                      start: size.width * 0.05, top: size.height * 0.05),
                  child: Container(
                    width: size.width,
                    height: size.height * 0.4,
                    color: Colors.white,
                    // child: Image.asset('assets/images/chart.png'),
                    child: barChart(),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.only(
                      start: size.width * 0.05,
                      end: size.width * 0.05,
                      top: size.height * 0.05),
                  child: Card(
                    elevation: 2,
                    child: Container(
                      width: size.width,
                      height: size.height * 0.07,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                          border: Border.all(
                              color: Color(0xFF0f1013).withOpacity(0.2))),
                      child: Row(
                        children: [
                          Padding(
                            padding:
                            EdgeInsetsDirectional.only(start: size.width * 0.05),
                            child: Image.asset(
                              'assets/icons/increased-revenue.png',
                              width: 24,
                              height: 24,
                              color: Colors.grey,
                            ),
                          ),
                          Padding(
                            padding:
                            EdgeInsetsDirectional.only(start: size.width * 0.045),
                            child: TextWidget(
                              text: AppLocalizations.of(context).netAmount,
                              textSize: 16,
                              isBold: true,
                            ),
                          ),
                          Padding(
                            padding:
                            EdgeInsetsDirectional.only(start: size.width * 0.25),
                            child: TextWidget(
                              text: "\$30,000",
                              textSize: 20,
                              isBold: true,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.only(
                      start: size.width * 0.05,
                      end: size.width * 0.05,
                      top: size.height * 0.01),
                  child: FutureBuilder<ApiResponse>(
                    future: _revenue(),
                    builder: (context,AsyncSnapshot<ApiResponse> snapshot) {
                      if(snapshot.hasData){
                        RevenueModel _reven;
                        _reven = snapshot.data.Data;
                        return Card(
                          elevation: 1.5,
                          child: Container(
                            width: size.width,
                            height: size.height * 0.07,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                                border: Border.all(
                                    color: Color(0xFF0f1013).withOpacity(0.2))),
                            child: Row(
                              children: [
                                Padding(
                                  padding:
                                  EdgeInsetsDirectional.only(start: size.width * 0.05),
                                  child: Image.asset(
                                    'assets/icons/sale.png',
                                    width: 24,
                                    height: 24,
                                    color: Colors.grey,
                                  ),
                                ),
                                Padding(
                                  padding:
                                  EdgeInsetsDirectional.only(start: size.width * 0.045),
                                  child: TextWidget(
                                    text: AppLocalizations.of(context).salesHeading,
                                    textSize: 16,
                                    isBold: true,
                                  ),
                                ),
                                Padding(
                                  padding:
                                  EdgeInsetsDirectional.only(start: size.width * 0.36),
                                  child: TextWidget(
                                    text: "\$"+ _reven.data.revenue.toString(),
                                    textSize: 20,
                                    isBold: true,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }else{
                        return Center(child: CircularProgressIndicator(color: Colors.brown,),);
                      }
                    }
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

class Sales {
  final String year;
  final int sales;

  Sales(this.year, this.sales);
}
