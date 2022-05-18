import 'dart:convert';
import 'package:category/api/storeApis.dart';
import 'package:category/modals/popularStoreModel.dart';
import 'package:category/modals/subStoreModel.dart';
import 'package:category/modals/user.dart';
import 'package:category/screens/dashboard/subStoreDetail.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:flutter/material.dart';

class PopularStoresLi extends StatefulWidget {
  final StoresData popStore;
  PopularStoresLi({this.popStore});

  @override
  _PopularStoresLiState createState() => _PopularStoresLiState();
}

class _PopularStoresLiState extends State<PopularStoresLi> {

  Welcome _userInfo;
  bool favouriteBool = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(right: 10),
      child: InkWell(
        onTap: (){
          SubStoreH _store = SubStoreH.fromJson(widget.popStore.toJson());

          Navigator.of(context).pushNamed('/SubStoreDetails',arguments: _store);

         /* Navigator.push(context, MaterialPageRoute(builder: (context){
            return SubStoreDetails(store: _store,);
          }));*/
        },
        child: Container(
          width: 160,
          child: Card(
            elevation: 0.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    height: 100,
                    child: Center(
                      child: Image.network(
                        widget.popStore.storeLogo,
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
                          widget.popStore.storeName,
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
                        onPressed: () async{
                          _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
                          await favouriteBool ? await removeFavo(token: _userInfo.token,customerId: _userInfo.userData.id, storeId: widget.popStore.id, subStoreId: null, productId: null ) : await favStoreAndPro(token: _userInfo.token, storeId: widget.popStore.id, productId: null, customerId: _userInfo.userData.id, subStoreId: null);
                          setState(() {
                            favouriteBool = !favouriteBool;
                          });
                        },
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
