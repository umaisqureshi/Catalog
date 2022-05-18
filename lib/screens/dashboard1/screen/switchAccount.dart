import 'dart:convert';
import 'package:category/api/auth_apis.dart';
import 'package:category/main.dart';
import 'package:category/modals/mainStoreModal.dart';
import 'package:category/api/storeApis.dart';
import 'package:category/modals/apiResponse.dart';
import 'package:category/modals/subStoreModel.dart';
import 'package:category/modals/user.dart';
import 'package:category/screens/dashboard1/Component/products.dart';
import 'package:category/screens/dashboard1/widgets/buttonWidget.dart';
import 'package:category/screens/dashboard1/widgets/textWidget.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:flutter/material.dart';
import 'package:category/utils/constant.dart';

import 'dashboard/subStore.dart';
import 'makeStore.dart';

class SwitchAccount extends StatefulWidget {
  @override
  _SwitchAccountState createState() => _SwitchAccountState();
}

class _SwitchAccountState extends State<SwitchAccount> {
  Welcome _userInfo;
  MainStore _mainStore;
  ApiResponse _apiResponse = ApiResponse();

  Future<ApiResponse> _handleGetMainStore() async {
    _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
    print("TOKEN :::::::::::::::::::::: ${_userInfo.token}");
    return getMainStore(token: _userInfo.token);
  }

  Future<ApiResponse> _handleGetSubStores(
      {@required String mainStoreId}) async {
    return getSubStores(token: _userInfo.token, mainStoreId: mainStoreId);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: TextWidget(
            text: AppLocalizations.of(context).switchAccount,
            textSize: 18,
            textColor: primary,
            isBold: true,
          ),
          centerTitle: true,
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          // scrollDirection: Axis.vertical,
          child: FutureBuilder<ApiResponse>(
              future: _handleGetMainStore(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _mainStore = snapshot.data.Data;
                  print(
                      "Main Store's Id :::::::::::::::::::::::: ${_mainStore.store.id}");
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Stack(
                          children: [
                            Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                  border: Border.all(color: brown, width: 5),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.network(
                                        _mainStore.store.storeLogo))),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          _mainStore.store.storeName,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Yu Gothic UI"),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.only(
                              start: size.width * 0.06,
                              top: size.height * 0.05),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context).subStore,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Yu Gothic UI",
                                    fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.only(end: 10),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Color(0xFFb58563)),
                                  onPressed: () {
                                    Navigator.of(context).pushNamed('/makestorePartner', arguments: _mainStore.store.id);
                                   /* Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return MakeStore(
                                        storeId: _mainStore.store.id,
                                      );
                                    }));*/
                                  },
                                  child: Text(
                                    AppLocalizations.of(context).newButton,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.only(
                              start: size.width * 0.05,
                              end: size.width * 0.05,
                              top: size.height * 0.03),
                          child: FutureBuilder<ApiResponse>(
                              future: _handleGetSubStores(mainStoreId: _mainStore.store.id),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  SubStoreModel _subStore = snapshot.data.Data;
                                  List<SubStoreH> _subStores = [];
                                  for(int i =0 ; i<_subStore.stores.length; i++){
                                    if(_subStore.stores[i].approvalStatus != "pending"){
                                      _subStores.add(_subStore.stores[i]);
                                    }
                                  }
                                  return snapshot.data.Data == null
                                      ? Center(
                                          child: Text(
                                            "No Stores yet",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.black,
                                            ),
                                          ),
                                        )
                                      : GridView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: _subStores.length,
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: size.width * 0.04,
                                          mainAxisSpacing: size.width * 0.04,
                                        ),
                                        itemBuilder: (BuildContext context,
                                            int index) {
                                          return InkWell(
                                            onTap: (){
                                              
                                              Navigator.of(context).pushNamed('/substorePartner', arguments: _subStores[index]);
                                              
                                              /*Navigator.push(context,
                                                  MaterialPageRoute(builder: (context) {
                                                        return SubStore(subStore: _subStores[index],);
                                                  })
                                              );*/
                                            },
                                            child: Container(
                                              width: 200,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                border: Border.all(
                                                    color: Color(0xFF0f1013)
                                                        .withOpacity(0.2)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.2),
                                                    spreadRadius: 2,
                                                    blurRadius:
                                                        2, // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    top: size.height * 0.01),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      height: 65,
                                                      width: 100,
                                                      child: Image.network(
                                                        _subStores[index]
                                                            .storeLogo,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          size.height * 0.012,
                                                    ),
                                                    Text(
                                                      _subStores[index]
                                                          .storeName,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight
                                                                  .bold),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
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
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.only(
                              start: size.width * 0.07, end: size.width * 0.07),
                          child: ButtonWidget(
                            buttonHeight: 50,
                            buttonWidth: MediaQuery.of(context).size.width,
                            function: () async {

                              var role =   SharedPrefs().userRole;
                              Welcome userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));

                              if(role == "partner"){
                                valueNotifier.value = false;
                                SharedPrefs().userRole = "customer";
                                await updateRole("customer", userInfo.token);
                                valueNotifier.notifyListeners();

                              }else{
                                valueNotifier.value = true;
                                SharedPrefs().userRole = "partner";
                                await updateRole("partner", userInfo.token);
                                valueNotifier.notifyListeners();
                              }
                            },
                            roundedBorder: 10,
                            buttonColor: Color(0xFFb58563),
                            widget: TextWidget(
                              text:
                                  AppLocalizations.of(context).switchToCustomer,
                              textSize: 18,
                              textColor: grey,
                            ),
                          ),
                        ),
                      ],
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
      ),
    );
  }
}
