import 'dart:convert';

import 'package:category/api/storeApis.dart';
import 'package:category/modals/get_fav_things.dart';
import 'package:category/modals/new_get_all_fav_model.dart';
import 'package:category/modals/subStoreModel.dart';
import 'package:category/modals/user.dart';
import 'package:category/screens/dashboard/subStoreDetail.dart';
import 'package:category/screens/dashboard1/screen/dashboard/subStore.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:category/widgets/storesData.dart';
import 'package:flutter/material.dart';

class FavSubStore extends StatefulWidget {
  final NewSubStore favSubStore;
  FavSubStore({this.favSubStore});

  @override
  _FavSubStoreState createState() => _FavSubStoreState();
}

class _FavSubStoreState extends State<FavSubStore> {
  Welcome _userInfo;

  bool favouriteBool = true;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(right: 10),
      child: InkWell(
        onTap: (){
          SubStoreH _subStore = SubStoreH.fromJson(widget.favSubStore.toJson());
          Navigator.of(context).pushNamed('/SubStoreDetails',arguments:_subStore );

          /*Navigator.push(context, MaterialPageRoute(builder: (context){
            return SubStoreDetails(store: _subStore,);
          }));*/
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
                      child: Image.network(
                        widget.favSubStore.storeLogo,
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
                          widget.favSubStore.storeName,
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
                          await favouriteBool ? await removeFavo(token: _userInfo.token, customerId: _userInfo.userData.id, storeId: null, subStoreId: widget.favSubStore.id, productId: null ) : await favStoreAndPro(token: _userInfo.token, storeId: null, productId: null, customerId: _userInfo.userData.id, subStoreId: widget.favSubStore.id);
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
