import 'dart:convert';
import 'package:category/api/storeApis.dart';
import 'package:category/modals/get_fav_things.dart';
import 'package:category/modals/new_get_all_fav_model.dart';
import 'package:category/modals/subStoreModel.dart';
import 'package:category/modals/user.dart';
import 'package:category/screens/dashboard/subStoreDetail.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:category/widgets/storesData.dart';
import 'package:flutter/material.dart';
import 'package:category/modals/storeByCategory.dart';
import 'customerHomeExtended.dart';

class FavStores extends StatefulWidget {
  final NewStore favStore;
  Store store;
  FavStores({this.favStore, this.store});

  @override
  _FavStoresState createState() => _FavStoresState();
}

class _FavStoresState extends State<FavStores> {
  Welcome _userInfo;
  bool favouriteBool = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(right: 10),
      child: InkWell(
        onTap: (){
          print('Button is clicked');
          Store _store = Store.fromJson(widget.favStore.toJson());
          Navigator.of(context).pushNamed('/customerHomeExtended',arguments: _store);

          /*Navigator.push(context, MaterialPageRoute(builder: (context){
            return CustomerHomeExtended(store: widget.store,);
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
                        widget.favStore.storeLogo,
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
                        child: Container(
                          width: 80,
                          child: Text(
                            widget.favStore.storeName,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight:
                                FontWeight.bold,
                                color:
                                Colors.black),
                            overflow: TextOverflow.ellipsis,
                          ),
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
                          await favouriteBool ? await removeFavo(token: _userInfo.token,customerId: _userInfo.userData.id, storeId: widget.favStore.id, subStoreId: null, productId: null ) : await favStoreAndPro(token: _userInfo.token, storeId: widget.favStore.id, productId: null, customerId: _userInfo.userData.id, subStoreId: null);
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
