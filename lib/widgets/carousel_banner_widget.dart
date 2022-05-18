import 'dart:convert';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:category/api/storeApis.dart';
import 'package:category/modals/apiResponse.dart';
import 'package:category/modals/banner_ads_model.dart';
import 'package:category/modals/user.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:flutter/material.dart';

class CarouselBanner extends StatefulWidget {

  @override
  _CarouselBannerState createState() => _CarouselBannerState();
}

class _CarouselBannerState extends State<CarouselBanner> {

  ApiResponse _apiResponse = ApiResponse();
  Welcome _userInfo;

  Future<ApiResponse> _getBannerAds() async {
    _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
    _apiResponse = await getBannerAds(token: _userInfo.token);
    return _apiResponse;
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  FutureBuilder<ApiResponse>(
      future: _getBannerAds(),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          GetBannerAdsModel _getbannerAdsModel = snapshot.data.Data as GetBannerAdsModel;
          List<String> images = [];
          for(final data in  _getbannerAdsModel.data){
            for(final img in data.images){
              images.add(img);
            }
          }
          return images.isEmpty?Container():Carousel(
            boxFit: BoxFit.fitHeight,
            showIndicator: false,
            images: images.map((e) => Image.network(e, fit: BoxFit.fitWidth,)).toList(),
            autoplay: true,
            autoplayDuration: Duration(seconds: 3),
            animationCurve: Curves.fastOutSlowIn,
            animationDuration: Duration(milliseconds: 1000),
            dotSize: 3.0,
            dotBgColor: Color(0xFFFFFFFF),
            dotIncreasedColor: Color(0xFFB9B9B9),
            dotColor: Color(0xFFE2E2EA),
            indicatorBgPadding: 3.0,
          );
        }else{
          return Center(child: CircularProgressIndicator(color: Colors.brown,),);
        }

      }
    );
  }
}
