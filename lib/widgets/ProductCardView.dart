import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:category/api/storeApis.dart';
import 'package:category/modals/apiResponse.dart';
import 'package:category/modals/check_already_like.dart';
import 'package:category/modals/user.dart';
import 'package:category/utils/constant.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:category/widgets/textWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductCardView extends StatefulWidget {
  @override
  _ProductCardViewState createState() => _ProductCardViewState();
  String name;
  String price;
  String Image;
  String token;
  String pId;
  String cId;
  List<String> imagesList;

  ProductCardView({
    @required this.name,
    @required this.price,
    @required this.Image,
    @required this.token,
    @required this.pId,
    @required this.cId,
    @required this.imagesList
  });
}

class _ProductCardViewState extends State<ProductCardView> {

  Future<ApiResponse> _checkingLikeProducts() async {
    _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
    _apiResponse = await checkAlreadyLike(token: _userInfo.token,id: widget.pId, customerId: _userInfo.userData.id);
    return _apiResponse;
  }
  ApiResponse _apiResponse = ApiResponse();
  Welcome _userInfo;

  bool favouriteBool = false;
  int _currentPos = 0;

  @override
  void initState() {
    print("pid ${widget.pId}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    return  Card(
      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      color: Colors.white,
      elevation: 0.0,
      child: Container(
        height: size.height * 0.27,
        width: size.width * 0.5,
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CarouselSlider.builder(
                  itemCount: widget.imagesList.length,
                  itemBuilder: (context, index, realPgIndx) {
                    return Container(
                      width: size.width * 0.5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(22), topRight: Radius.circular(22))
                      ),
                      child: Image.network(widget.imagesList[index], fit: BoxFit.cover,),
                    );
                  },
                  options: CarouselOptions(
                      autoPlay: false,
                      autoPlayCurve: Curves.elasticInOut,
                      autoPlayAnimationDuration: Duration(seconds: 1),
                      enlargeCenterPage: false,
                      viewportFraction: 0.999,
                      height: size.height*0.15,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentPos = index;
                        });
                      }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.imagesList.map((url) {
                    int index = widget.imagesList.indexOf(url);
                    return Container(
                      width: 6.0,
                      height: 6.0,
                      margin: EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPos == index
                            ? Colors.black54
                            : Colors.black26,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 120,
                    child: Text(
                     widget.name,
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          fontWeight:
                          FontWeight
                              .w400),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "${SharedPrefs().isCurrencyAvailable() ? SharedPrefs().currency : '\$'} ${widget.price}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight:
                              FontWeight.bold,
                              color: Colors.red[600]
                            ),
                          ),
                          Text("(45% off)", style: TextStyle(
                              fontSize: 14,
                              fontWeight:
                              FontWeight.normal,
                              color: Colors.black26
                          ),)
                        ],
                      ),
                      InkWell(
                        onTap: () async{

                          print("pid ${widget.pId}");
                          print("token ${widget.token}");
                          print("customer Id ${_userInfo.userData.id}");
                          await favStoreAndPro(token: widget.token, storeId: null, productId: widget.pId, customerId: _userInfo.userData.id, subStoreId: null);
                          setState(()  {
                            favouriteBool = !favouriteBool;
                          });
                        },
                        child: FutureBuilder<ApiResponse>(
                          future: _checkingLikeProducts(),
                          builder: (context, snapshot) {
                            if(snapshot.hasData){
                              CheckAlreadyLike _checkAlreadyLike = snapshot.data.Data as CheckAlreadyLike;
                              favouriteBool = _checkAlreadyLike.data;
                              return Container(
                                child: (favouriteBool)
                                    ? Icon(
                                  Icons.favorite,
                                  color: Colors
                                      .black,
                                )
                                    : Icon(
                                  Icons.favorite_border,
                                ),
                              );
                            }else{
                              return Container();
                            }
                          }
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
