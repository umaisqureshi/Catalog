import 'dart:convert';
import 'package:category/api/auth_apis.dart';
import 'package:category/api/storeApis.dart';
import 'package:category/modals/apiResponse.dart';
import 'package:category/modals/cartGetModel.dart';
import 'package:category/modals/promo_codes_model.dart';
import 'package:category/modals/user.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../cart.dart';

class PromoCodesScreen extends StatefulWidget {
  @override
  _PromoCodesScreenState createState() => _PromoCodesScreenState();
}

class _PromoCodesScreenState extends State<PromoCodesScreen> {
  final snackBar = SnackBar(content: Text('Promo Code Copied to Clipboard'));
  String strPromoCode;

  ApiResponse _apiResponse = ApiResponse();
  Welcome _userInfo;

  Future<ApiResponse> handleGetPromoCodes(String token) async {
    _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
    _apiResponse = await getPromoCode(token: _userInfo.token);
    return _apiResponse;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          title: Text(
            'Promo Codes',
            style: TextStyle(fontSize: 16),
          ),
          centerTitle: true,
        ),
        body: Container(
          child: FutureBuilder<ApiResponse>(
              future: handleGetPromoCodes(SharedPrefs().token),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  GetPromoCodes _getPromoCodes =
                      snapshot.data.Data as GetPromoCodes;
                  return ListView.builder(
                      itemCount: _getPromoCodes.data.length,
                      itemBuilder: (context, index) {
                        return PromoCodeItems(promoCodeItemsModel: _getPromoCodes.data[index],);
                      });
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.brown,
                    ),
                  );
                }
              }),
        ));
  }
}

class PromoCodeItems extends StatefulWidget {
  final PromoCodeItemsModel promoCodeItemsModel;
  const PromoCodeItems({Key key, this.promoCodeItemsModel}) : super(key: key);

  @override
  _PromoCodeItemsState createState() => _PromoCodeItemsState();
}

class _PromoCodeItemsState extends State<PromoCodeItems> {
  bool isUse = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 20, right: 20, top: 10, bottom: 10),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.promoCodeItemsModel.promocode,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.promoCodeItemsModel.discount,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    widget.promoCodeItemsModel.endingDate
                        .substring(0, 10),
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  )
                ],
              ),
              Spacer(),
              isUse?Center(child: CircularProgressIndicator(),):
              InkWell(
                onTap: () async {
                  setState(() {isUse = true;});
                  var _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));

                    await checkPromo(token: _userInfo.token, promoCode: widget.promoCodeItemsModel.promocode).then((value) async {

                      if(value.Data is String){
                        final snackBar = SnackBar(content: Text(value.Data));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        setState(() {isUse = false;});
                        return;
                      }
                      SharedPrefs().savePromoCode =  widget.promoCodeItemsModel;
                      await getCartProduct(token: _userInfo.token).then((value) {
                        if(value.Data is CartGetModel){
                          CartGetModel model =  value.Data as CartGetModel;
                          if(model.cart.products.isNotEmpty){
                            setState(() {isUse = false;});
                            Navigator.of(context).pushNamed('/cart',arguments: widget.promoCodeItemsModel);

                           /* Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CartScreen(
                                        data:  widget.promoCodeItemsModel
                                    )));*/
                          }else{
                            //ignore
                            setState(() {isUse = false;});
                          }
                        }
                      }).catchError((error){
                        setState(() {isUse = false;});
                      });

                    });




                },
                child: Container(
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.brown,
                  ),
                  child: Center(
                      child: Text(
                        'Use',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


/*
return ListView.builder(itemBuilder: (context,index){
return Padding(
padding: const EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
child: Container(
height: 150,
decoration: BoxDecoration(
color: Colors.grey[200],
borderRadius: BorderRadius.circular(20),


),
child: Padding(
padding: const EdgeInsets.all(25.0),
child: Row(
mainAxisAlignment: MainAxisAlignment.center,
crossAxisAlignment: CrossAxisAlignment.center,
children: [
Column(
mainAxisAlignment: MainAxisAlignment.center,
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text('Promo Codes',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
Text('Discount',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
Text('Ending Date',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)
],
),
Spacer(),
Container(
height: 40,
width: 100,
decoration: BoxDecoration(
borderRadius: BorderRadius.circular(20),
color: Colors.brown,

),
child: Center(child: Text('Copy',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
)
],
),
),
),
);
});*/
