import 'dart:convert';
import 'package:category/api/storeApis.dart';
import 'package:category/modals/apiResponse.dart';
import 'package:category/modals/discountModel.dart';
import 'package:category/modals/user.dart';
import 'package:category/utils/constant.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:flutter/material.dart';
import '../TopRow.dart';
import 'dashboard1/widgets/textWidget.dart';

class ViewAllDeals extends StatefulWidget {
  @override
  _ViewAllDealsState createState() => _ViewAllDealsState();
}

class _ViewAllDealsState extends State<ViewAllDeals> {
  bool visible = true;

  ApiResponse _apiResponse = ApiResponse();

  Welcome _userInfo;

  DiscountModel _discountModel;

  Future<ApiResponse> _getDiscountSale() async {
    _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
    _apiResponse = await discountSale(token: _userInfo.token);
    return _apiResponse;
  }

  @override
  void initState() {
    Welcome user = Welcome.fromJson(json.decode(SharedPrefs().token));
    print("User Id :::::::::::::::::::::::::::: ${user.userData.id}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFFb58563)),
        actions: [
          TopRow(
            isVisible: visible,
            visibility: (visi) {
              visible = visi;
              setState(() {});
            },
          )
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: FutureBuilder<ApiResponse>(
            future: _getDiscountSale(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                _discountModel = snapshot.data.Data as DiscountModel;
                return _discountModel != null
                    ? GridView.builder(
                        itemCount: _discountModel.data.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: (2 / 2),
                        ),
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Card(
                                shape: CircleBorder(),
                                elevation: 5,
                                child: SizedBox(
                                    height: 80,
                                    width: 80,
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(180),
                                      child: Image.network(
                                        _discountModel
                                            .data[index].discountImg,
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextWidget(
                                text: AppLocalizations.of(context)
                                    .discountMessage(
                                        _discountModel.data[index].discount),
                                isBold: true,
                                textSize: 10,
                              ),
                            ],
                          );
                        },
                      )
                    : Center(
                        child: Text("No Sales Found"),
                      );
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.brown,
                  ),
                );
              }
            }),
      ),
    );
  }
}
