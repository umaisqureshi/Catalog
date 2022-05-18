import 'dart:convert';
import 'package:category/api/storeApis.dart';
import 'package:category/modals/apiResponse.dart';
import 'package:category/modals/mainStoreModal.dart';
import 'package:category/modals/route_arguments.dart';
import 'package:category/modals/user.dart';
import 'package:category/utils/constant.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'createMainStore.dart';
import 'dashboard/editMainStore.dart';

class StatusMessage extends StatefulWidget {
  @override
  _StatusMessageState createState() => _StatusMessageState();
}

class _StatusMessageState extends State<StatusMessage> {
  ApiResponse _apiResponse = ApiResponse();
  Welcome _userInfo;
  MainStore _mainStore;

  Future<ApiResponse> _handleGetMainStore() async {
    _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
    print("TOKEN :::::::::::::::::::::: ${_userInfo.token}");
    return getMainStore(token: _userInfo.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Store Status",
          style: TextStyle(fontSize: 18, color: Color(0xffb58563)),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: FutureBuilder<ApiResponse>(
            future: _handleGetMainStore(),
            builder: (context, AsyncSnapshot<ApiResponse> snapshot) {
              if (snapshot.hasData) {
                _mainStore = snapshot.data.Data;
                if(_mainStore != null){
                  if (_mainStore.store.status.approvalStatus == "pending" ||
                      _mainStore.store.status.approvalStatus == "decline") {
                    SharedPrefs().mainStoreStatus = false;
                  } else {
                    SharedPrefs().mainStoreStatus = true;
                  }
                }
                return _mainStore == null ? Container(): Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        "assets/images/message1.png",
                        scale: 4,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Status: ",
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                _mainStore.store.status.approvalStatus
                                    .toUpperCase(),
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xffB58563),
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          _mainStore.store.status.approvalStatus == "decline"
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Reason: ",
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    Center(
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        margin: EdgeInsetsDirectional.all(8.0),
                                        child: Text(
                                          _mainStore.store.reason,
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : Text(
                                  _mainStore.store.status.approvalStatus !=
                                          "pending"
                                      ? "Congratulations! Your request for Main Store has been approved. You can now move forward by clicking the button below"
                                      : "We are working on it. It will be approved\nas soon as possible",
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.12,
                    ),
                    _mainStore.store.status.approvalStatus == "decline"
                        ? Center(
                            child: Container(
                              alignment: Alignment.center,
                              height: 60,
                              width: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: brown
                              ),
                              child: InkWell(
                                onTap: (){
                                  Navigator.of(context).pushNamed('/EditMainStorePartner', arguments: RouteArguments(param1: _mainStore, param2: true));
                                  /*Navigator.push(context, MaterialPageRoute(builder: (context){
                                    return EditMainStore(mainStore: _mainStore,isRequest: true,);
                                  }));*/
                                },
                                child: Text(
                                  "Request Again",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Center(
                            child: Container(
                              alignment: Alignment.centerRight,
                              height: 60,
                              width: 300,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Color(0xffb58563))),
                              child: Center(
                                child: _mainStore.store.status.approvalStatus !=
                                        "pending"
                                    ? InkWell(
                                        onTap: () {
                                          Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            '/dashboardPartner',
                                            ModalRoute.withName(
                                                '/dashboardPartner'),
                                          );
                                        },
                                        child: Text(
                                          "Congratulations",
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ))
                                    : InkWell(
                                        onTap: () {
                                          SystemChannels.platform.invokeMethod(
                                              'SystemNavigator.pop');
                                        },
                                        child: Text(
                                          "Check Back Later",
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                          )
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Oops! Something went wrong.",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: brown,
                        fontSize: 15),
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    color: brown,
                  ),
                );
              }
            }),
      ),
    );
  }
}
