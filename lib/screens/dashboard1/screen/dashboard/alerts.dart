import 'dart:async';
import 'dart:convert';
import 'package:category/api/auth_apis.dart';
import 'package:category/modals/apiResponse.dart';
import 'package:category/modals/get_all_notifications.dart';
import 'package:category/modals/user.dart';
import 'package:category/screens/dashboard1/screen/dashboard/alert_details.dart';
import 'package:category/utils/constant.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:category/widgets/dividerWidget.dart';
import 'package:category/widgets/noConnection.dart';
import 'package:category/widgets/textWidget.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';


class Alerts extends StatefulWidget {
  @override
  _AlertsState createState() => _AlertsState();
}

class _AlertsState extends State<Alerts> {

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

  Future<ApiResponse> _handleGetNotifications() async {
    Welcome _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
    print("TOKEN :::::::::::::::::::::: ${_userInfo.token}");
    return getNotifications(token: _userInfo.token);
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
            text: AppLocalizations.of(context).alerts,
            textSize: 18,
            textColor: primary,
            isBold: true,
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: isInternetAvailable ? FutureBuilder<ApiResponse>(
          future: _handleGetNotifications(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              GetNotificationsModel _getNotifications = snapshot.data.Data as GetNotificationsModel;
              return Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: Container(
                    child: ListView.builder(
                        itemCount: _getNotifications.data.length,
                        itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        decoration: BoxDecoration(

                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.brown,width: 2)
                        ),
//color: Colors.brown[50],
                        height: 70,
                        child: Row(
                          children: [
                            SizedBox(width: 2,),
                            ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child:
                                Image.network(_getNotifications.data[index].image,height: double.infinity,width: 80,fit: BoxFit.cover,)),
                                /*Image.network(_getNotifications.data[index].image,height: double.infinity,width: 80,fit: BoxFit.cover,)),*/
                            SizedBox(width: 40,),

                            InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => AlertDetails(title: _getNotifications.data[index].title, image: _getNotifications.data[index].image,message: _getNotifications.data[index].message,)));

                              },
                              child: Container(
                                height: 50,
                                width: 200,
                                child: Column(
                                  children: [
                                    Text(_getNotifications.data[index].title,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                    SizedBox(height: 5,),
                                    Container(

                                        child: Text(_getNotifications.data[index].subTitle,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 16),)),
                                  ],
                                ),

                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                  ));
            }else{
              return Stack(
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
                              text: AppLocalizations.of(context).noAlertsYet,
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
                                AppLocalizations.of(context).alertsMessage,
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
              );

            }

          }
        ) : NoInternet(),
      ),
    );
  }
}



/*
Container(
height: double.infinity,
width: double.infinity,
child: Container(
child: ListView.builder(itemBuilder: (context, index) => Padding(
padding: const EdgeInsets.all(5.0),
child: Container(
decoration: BoxDecoration(

borderRadius: BorderRadius.circular(8),
border: Border.all(color: Colors.brown,width: 2)
),
//color: Colors.brown[50],
height: 70,
child: Row(
children: [
SizedBox(width: 10,),
Image.asset("assets/images/catbag.png",height: double.infinity,width: 50,fit: BoxFit.cover,),
SizedBox(width: 40,),

InkWell(
onTap: (){
Navigator.pushNamed(context, '/AlertDetailsPartner');

},
child: Container(
height: 50,
width: 200,
child: Column(
children: [
Text("Title",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
SizedBox(height: 5,),
Container(

child: Text("This is the Message",overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 16),)),
],
),

),
),
],
),
),
)),
)

*/
/*Stack(
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
                          text: AppLocalizations.of(context).noAlertsYet,
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
                            AppLocalizations.of(context).alertsMessage,
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
          ),*//*

) */
