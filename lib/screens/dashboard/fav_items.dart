import 'dart:convert';
import 'package:category/api/storeApis.dart';
import 'package:category/modals/get_fav_things.dart';
import 'package:category/modals/new_get_all_fav_model.dart';
import 'package:category/modals/productsByStoresModal.dart';
import 'package:category/modals/route_arguments.dart';
import 'package:category/modals/user.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:flutter/material.dart';
import '../productDetail.dart';

class FavItems extends StatefulWidget {
  final NewProduct favProducts;
  FavItems({this.favProducts});

  @override
  _FavItemsState createState() => _FavItemsState();
}

class _FavItemsState extends State<FavItems> {
  Welcome _userInfo;

  bool favouriteBool = true;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(right: 10),
      child: InkWell(
        onTap: (){
          Product product = Product.fromJson(widget.favProducts.toJson());
          Navigator.of(context).pushNamed('/ProductDetail',arguments: RouteArguments(param1: product));

          /*Navigator.push(context, MaterialPageRoute(builder: (context){
            return ProductDetail(
              product: product,
            );
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
                        widget.favProducts.images.first,
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
                          widget.favProducts.productName,
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
                          await favouriteBool ? await removeFavo(token: _userInfo.token, customerId: _userInfo.userData.id, storeId: null, subStoreId: null, productId: widget.favProducts.id ) : await favStoreAndPro(token: _userInfo.token, storeId: null, productId: widget.favProducts.id, customerId: _userInfo.userData.id, subStoreId: null);

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
