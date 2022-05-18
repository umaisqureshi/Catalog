import 'dart:convert';

import 'package:category/api/storeApis.dart';
import 'package:category/modals/apiResponse.dart';
import 'package:category/modals/discountModel.dart';
import 'package:category/modals/subStoreModel.dart';
import 'package:category/modals/user.dart';
import 'package:category/utils/constant.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:flutter/material.dart';

import 'dashboard1/widgets/dividerWidget.dart';
import 'dashboard1/widgets/textWidget.dart';

class ViewAllScreen extends StatefulWidget {
  String screenTitle;

  ViewAllScreen({this.screenTitle});
  @override
  _ViewAllScreenState createState() => _ViewAllScreenState();
}

class _ViewAllScreenState extends State<ViewAllScreen> {

  Welcome _userInfo;
  ApiResponse _apiResponse = ApiResponse();
  DiscountModel _discountModel;

  Future<ApiResponse>_getDiscountSale() async {
    _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
    _apiResponse = await discountSale(token: _userInfo.token);
    return _apiResponse;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: TextWidget(
          textSize: 18,
          textColor: primary,
          text: widget.screenTitle,
          isBold: true,
        ),
      ),
      body: FutureBuilder<ApiResponse>(
          future: _getDiscountSale(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              _discountModel = snapshot.data.Data as DiscountModel;
              return _discountModel != null ? InkWell(
                onTap: (){
                  Navigator.of(context).pushNamed('/SubStoreDetails',
                      arguments: SubStoreH(
                          userId: _userInfo.userData.id,
                          id: _discountModel.data.first.storeId,
                          storeName: "",
                          storeCategory: "",
                          storeLogo: _discountModel.data.first.discountImg));
                },
                child: Container(
                  child: ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, ind){
                        return Padding(
                          padding: EdgeInsetsDirectional.only(start: 20,end: 20, top: 10, bottom: 10),
                          child: Row(
                            children: [
                              Card(
                                elevation: 5,
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  child: Image.network(
                                    _discountModel.data[ind].discountImg,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /*TextWidget(
                                    textSize: 15,
                                    textColor: primary,
                                    text: _discountModel.data[ind].storeId,
                                    isBold: true,
                                  ),*/
                                  TextWidget(
                                    textSize: 15,
                                    textColor: primary,
                                    text: AppLocalizations.of(context).discountMessage(_discountModel.data[ind].discount),
                                  ),
                                  TextWidget(
                                    textSize: 15,
                                    textColor: primary.withOpacity(0.4),
                                    text: _discountModel.data[ind].endingDate.substring(0,10),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      }, separatorBuilder: (context, index){
                    return DividerWidget();
                  }, itemCount: _discountModel.data.length),
                ),
              ) : Center(child: Text('No Sales Found'),);

            }
            else{
              return Center(child: CircularProgressIndicator(color: Colors.brown,),);
            }
          }
      ),
    );
  }
}
