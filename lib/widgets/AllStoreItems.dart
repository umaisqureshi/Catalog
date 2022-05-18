import 'dart:convert';

import 'package:category/api/storeApis.dart';
import 'package:category/modals/apiResponse.dart';
import 'package:category/modals/check_already_like.dart';
import 'package:category/modals/new_get_all_fav_model.dart';
import 'package:category/modals/totalSalesModel.dart';
import 'package:category/modals/user.dart';
import 'package:category/screens/dashboard/customerHomeExtended.dart';
import 'package:category/utils/constant.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:category/widgets/storesData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:category/modals/storeByCategory.dart';

class AllStoreItems extends StatefulWidget {
  Store store;
  String customerId, token;

  AllStoreItems({this.store, this.token, this.customerId,});

  @override
  _AllStoreItemsState createState() => _AllStoreItemsState();
}

class _AllStoreItemsState extends State<AllStoreItems> {

  ApiResponse _apiResponse = ApiResponse();
  Welcome _userInfo;

  Future<ApiResponse> _favThingsItem() async {
    _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
    _apiResponse = await newGetFav(token: _userInfo.token, customerId: _userInfo.userData.id);
    return _apiResponse;
  }

  Future<ApiResponse> _getSalesByStore() async {
    _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
    _apiResponse = await totalStoreSales(token: _userInfo.token, storeId: widget.store.id);
    return _apiResponse;
  }

  Future<ApiResponse> _checkingLike() async {
    _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
    _apiResponse = await checkAlreadyLike(token: _userInfo.token,id: widget.store.id,customerId: _userInfo.userData.id);
    return _apiResponse;
  }

  bool favouriteBool = false;

  @override
   initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 12, end: 12, bottom: 10),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CustomerHomeExtended(
              store: widget.store,
            );
          }));
        },
        child: Card(
          elevation: 2,
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                child: SizedBox(
                  child: Image.network(
                    widget.store.storeLogo,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                color: Color(0xffF1F1F1),
                height: size.height * 0.15,
                width: size.width * 0.55,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.only(start: 5.0),
                          child: Container(
                            width: 100,
                            child: Text(
                              widget.store.storeName,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(end: 5.0),
                          child: InkWell(
                            onTap: () async{
                              print("store id${widget.store.id}");
                              await favStoreAndPro(token: widget.token, subStoreId: null, customerId: widget.customerId, productId: null, storeId: widget.store.id );
                              setState(() {
                                favouriteBool = !favouriteBool;
                              });
                            },
                            child: FutureBuilder<ApiResponse>(
                              future: _checkingLike(),
                              builder: (context, snapshot) {
                                if(snapshot.hasData){
                                  CheckAlreadyLike _checkAlreadyLike = snapshot.data.Data as CheckAlreadyLike;
                                  favouriteBool = _checkAlreadyLike.data;
                                  return Container(
                                    padding: EdgeInsetsDirectional.all(0),
                                    child: (favouriteBool)
                                        ? Icon(
                                      Icons.favorite,
                                      color: Colors.black,
                                      size: 20,
                                    )
                                        : Icon(
                                      Icons.favorite_border,
                                      size: 20,
                                    ),
                                  );
                                }else{
                                  return Container();
                                }

                              }
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.only(start: 5.0),
                          child: Text(
                            AppLocalizations.of(context).itemsSold,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black26),
                          ),
                        ),
                        FutureBuilder<ApiResponse>(
                          future: _getSalesByStore(),
                          builder: (context, snapshot) {
                            if(snapshot.hasData){
                              TotalSales _totalSales = snapshot.data.Data as TotalSales;
                              return _totalSales == null ? Container() :Padding(
                                padding: const EdgeInsetsDirectional.only(start: 5.0),
                                child: Text(
                                  AppLocalizations.of(context).sales(_totalSales.data.sales.toString()),
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black26),
                                ),
                              );
                            }else{
                              return Center();
                            }
                          }
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


/*
Card(
elevation: 3,
child: Column(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
mainAxisSize: MainAxisSize.min,
children: [
Container(
height: 125,
color: Colors.black,
child: Center(
child: Image.asset(
widget.allstoresdataList
    .image,
fit: BoxFit.cover,
),
)),
Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,

children: [
Padding(
padding: const EdgeInsetsDirectional.only(start:10.0),
child: Text(
widget.allstoresdataList
    .title,
style: TextStyle(
fontSize: 12,
fontWeight:
FontWeight.bold,
color:
Colors.black),
),
),
IconButton(
icon: (favouriteBool)
? Icon(
Icons.favorite,
color: Colors
    .black,
)
: Icon(
Icons
    .favorite_border,
),
onPressed: () {
setState(() {
favouriteBool = !favouriteBool;
});
},
),
],
),
Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Padding(
padding: const EdgeInsetsDirectional.only(start:10.0),
child: Text(
AppLocalizations.of(context).itemsSold,
style: TextStyle(
fontSize: 12,
fontWeight:
FontWeight.bold,
color:
Colors.black26),
),
),
Padding(
padding: const EdgeInsetsDirectional.only(end:8.0),
child: Text(
"1234",
style: TextStyle(
fontSize: 12,
fontWeight:
FontWeight.bold,
color:
Colors.black),
),
),
],
),
],
),
),
*/
