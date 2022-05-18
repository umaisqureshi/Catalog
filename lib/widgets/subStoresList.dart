import 'dart:convert';

import 'package:category/api/storeApis.dart';
import 'package:category/modals/apiResponse.dart';
import 'package:category/modals/check_already_like.dart';
import 'package:category/modals/subStoreModel.dart';
import 'package:category/modals/user.dart';
import 'package:category/screens/dashboard/subStoreDetail.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:category/widgets/storesData.dart';
import 'package:flutter/material.dart';

class SubStoresItems extends StatefulWidget {
  final SubStoreH subStore;
  String customerId, token;
  SubStoresItems({this.subStore, this.customerId, this.token});

  @override
  _SubStoresItemsState createState() => _SubStoresItemsState();
}

class _SubStoresItemsState extends State<SubStoresItems> {
  ApiResponse _apiResponse = ApiResponse();
  Welcome _userInfo;

  Future<ApiResponse> _checkingLikeSubStore() async {
    _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
    _apiResponse = await checkAlreadyLike(token: _userInfo.token,id: widget.subStore.id, customerId: _userInfo.userData.id);
    return _apiResponse;
  }

  bool favouriteBool = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(right: 10),
      child: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return SubStoreDetails(store: widget.subStore,);
          }));
        },
        child: Container(
          width: 160,
          child: Card(
            elevation: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    height: 100,
                    child: Center(
                      child: Image.asset(
                        widget.subStore.storeLogo,
                        fit: BoxFit.contain,
                      ),
                    )),
                Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:10.0),
                        child: Text(
                          widget.subStore.storeName,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight:
                              FontWeight.bold,
                              color:
                              Colors.black),
                        ),
                      ),


                      FutureBuilder<ApiResponse>(
                        future: _checkingLikeSubStore(),
                        builder: (context, snapshot) {
                          if(snapshot.hasData){
                            CheckAlreadyLike _checkAlreadyLike = snapshot.data.Data as CheckAlreadyLike;
                            favouriteBool = _checkAlreadyLike.data;

                            print("Customer Home Extended ${favouriteBool}");
                            return IconButton(
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
                              onPressed: () async{
                                print("subStore Id${widget.subStore.id}");
                                print("subStore StoreId${widget.subStore.storeId}");
                                print("subStore UserId${widget.subStore.userId}");
                                await favStoreAndPro(token: widget.token, storeId: null, productId: null, customerId: widget.customerId, subStoreId: widget.subStore.id);

                                setState(() {
                                  favouriteBool = !favouriteBool;
                                });
                              },
                            );
                          }else{
                            return Container();
                          }
                        }
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
