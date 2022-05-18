import 'dart:convert';

import 'package:alphabet_scroll_view/alphabet_scroll_view.dart';
import 'package:category/api/storeApis.dart';
import 'package:category/modals/apiResponse.dart';
import 'package:category/modals/get_fav_things.dart';
import 'package:category/modals/new_get_all_fav_model.dart';
import 'package:category/modals/route_arguments.dart';
import 'package:category/modals/user.dart';
import 'package:category/utils/constant.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:category/widgets/backIconWidget.dart';
import 'package:category/widgets/bottomBarWidget.dart';
import 'package:category/widgets/textWidget.dart';
import 'package:category/widgets/topBarWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Stores extends StatefulWidget {
  // RouteArguments text;
  // Stores({this.text});
  @override
  _StoresState createState() => _StoresState();
}

class _StoresState extends State<Stores> {
  int selectedIndex;

  Welcome _userInfo;
  ApiResponse _apiResponse = ApiResponse();

  Future<ApiResponse> _favThingsItem() async {
    _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
    _apiResponse =
        await newGetFav(token: _userInfo.token, customerId: _userInfo.userData.id);
    return _apiResponse;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: TextWidget(
          text: AppLocalizations.of(context).manageMyStores,
          textSize: 15,
          textColor: primary,
          isBold: true,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: FutureBuilder<ApiResponse>(
            future: _favThingsItem(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                NewGetFavThings _fav = snapshot.data.Data as NewGetFavThings;
                return _fav != null
                    ? Container(
                        padding: EdgeInsetsDirectional.all(16),
                        child: ListView.builder(
                          itemCount: _fav.data.stores.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return FavouriteStoreTile(fav: _fav, ind: index,);
                          },
                        ),
                      )
                    : Center(
                        child: Text("Nothing is here."),
                      );
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: primary,
                  ),
                );
              }
            }),
      ),
    );
  }
}

class FavouriteStoreTile extends StatefulWidget {
  FavouriteStoreTile({this.fav, this.ind});

  NewGetFavThings fav;
  int ind;

  @override
  _FavouriteStoreTileState createState() => _FavouriteStoreTileState();
}

class _FavouriteStoreTileState extends State<FavouriteStoreTile> {
  bool favouriteBool = true;

  Welcome _userInfo;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              widget.fav.data.stores[widget.ind].storeLogo
            ),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: primary, width: 1)
        ),
      ),
      title: Text(
        widget.fav.data.stores[widget.ind].storeName,
        style: TextStyle(
            color: Colors.black87,
            fontSize: 15,
            fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        widget.fav.data.stores[widget.ind].storeDescription,
        style: TextStyle(
            color: Colors.black45,
            fontSize: 13,
            fontWeight: FontWeight.normal),
      ),
      trailing: IconButton(
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
          await favouriteBool ? await removeFavo(token: _userInfo.token,customerId: _userInfo.userData.id, storeId: widget.fav.data.stores[widget.ind].id, subStoreId: null, productId: null ) : await favStoreAndPro(token: _userInfo.token, storeId: widget.fav.data.stores[widget.ind].id, productId: null, customerId: _userInfo.userData.id, subStoreId: null);
          setState(() {
            favouriteBool = !favouriteBool;
          });
        },
      ),
    );
  }
}