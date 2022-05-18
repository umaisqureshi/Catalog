import 'dart:convert';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:category/api/auth_apis.dart';
import 'package:category/modals/apiResponse.dart';
import 'package:category/modals/control_ads_model.dart';
import 'package:category/modals/subStoreModel.dart';
import 'package:category/modals/user.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Carousel1 extends StatefulWidget {
  @override
  _Carousel1State createState() => _Carousel1State();
}

class _Carousel1State extends State<Carousel1> {
  Future<ApiResponse> _handleGetAllAds() async {
    Welcome _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
    print("TOKEN :::::::::::::::::::::: ${_userInfo.token}");
    return getAds(token: _userInfo.token);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder<ApiResponse>(
        future: _handleGetAllAds(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            GetAdsModel _getAdsModel = snapshot.data.Data as GetAdsModel;
            return Container(
                width: size.width,
                height: 150,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _getAdsModel.data
                        .map((e) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Material(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: InkWell(
                                      onTap: () {
                                        Welcome _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));

                                        Navigator.of(context).pushNamed(
                                            '/SubStoreDetails',
                                            arguments: SubStoreH(
                                              userId: _userInfo.userData.id,
                                                id: e.storeId,
                                                storeName: e.storeName,
                                                storeCategory: e.storeCategory,
                                                storeLogo: e.storeLogo,
                                            ));
                                      },
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                              radius: 45,
                                              backgroundImage: NetworkImage(e.storeLogo?? "")
                                          ),
                                          SizedBox(height: 5,),
                                          Expanded(child: Text(e.storeName?? "",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
                                          Text("Ad",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)
                                        ],
                                      )


                                    /*Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15.0)),
                                          width: size.width * 0.8,
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              child: Image.network(
                                                e.storeLogo?? "",
                                                fit: BoxFit.cover,
                                              ))
                                      )*/
                                  )),
                            ))
                        .toList(),
                  ),
                ));
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.brown,
              ),
            );
          }
        });
  }
}
