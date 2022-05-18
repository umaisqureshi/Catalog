import 'dart:async';
import 'dart:convert';
import 'package:category/api/storeApis.dart';
import 'package:category/modals/apiError.dart';
import 'package:category/modals/apiResponse.dart';
import 'package:category/modals/productsByStoresModal.dart';
import 'package:category/modals/route_arguments.dart';
import 'package:category/modals/subStoreModel.dart';
import 'package:category/modals/user.dart';
import 'package:category/screens/dashboard1/screen/productDetail.dart';
import 'package:category/screens/dashboard1/widgets/carousel_widget.dart';
import 'package:category/screens/dashboard1/widgets/drawer_widget.dart';
import 'package:category/screens/dashboard1/widgets/textWidget.dart';
import 'package:category/utils/constant.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:category/widgets/carousel_banner_widget.dart';
import 'package:category/widgets/noConnection.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../addProduct.dart';
import '../editProduct.dart';

class SubStore extends StatefulWidget {

  SubStoreH subStore;

  SubStore({this.subStore});

  @override
  _SubStoreState createState() => _SubStoreState();
}

class _SubStoreState extends State<SubStore> {
  bool visible = true;
  bool substore = true;
  ApiResponse _apiResponse = ApiResponse();
  Welcome _userInfo;

  bool isInternetAvailable = true;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        setState((){
          isInternetAvailable = true;
        });
        break;
      default:
        setState(() => isInternetAvailable = false);
        break;
    }
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  showInSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<ApiResponse> _handleGetSubStore() async {
    _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
    print("TOKEN :::::::::::::::::::::: ${_userInfo.token}");
    return getSubStore(token: _userInfo.token, subStore_id: widget.subStore.storeId);
  }


  _handleDestroyProduct({String productId}) async {
    _apiResponse =
    await destroyProduct(token: _userInfo.token, productId: productId);

    if ((_apiResponse.ApiError as ApiError) == null) {
      showInSnackBar(AppLocalizations.of(context).productDeletedSuccessfully);
      setState(() {});
    } else {
      showInSnackBar((_apiResponse.ApiError as ApiError).error);
    }
  }

  @override
  void initState() {
    _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
    print("SUBSTORE ID :::::::::::::::::::::: ${widget.subStore.id}");
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    super.initState();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: isInternetAvailable ? Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Color(0xFFb58563)),
          title: Text(
            AppLocalizations.of(context).subStore,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFFb58563)),
          ),
          centerTitle: true,
          elevation: 0,
          actions: [
            Padding(
              padding: EdgeInsetsDirectional.only(
                  end: size.width * 0.04, top: 5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.network(
                      widget.subStore.storeLogo,
                      fit: BoxFit.cover,
                    )),
              ),
            ),
          ],
        ),
        drawer: DrawerPartner(),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: FutureBuilder<ApiResponse>(
            future: _handleGetSubStore(),
            builder: (context, snapshot) {
              if(snapshot.hasData){
                return Column(
                  children: [
                    /*Padding(
                      padding: const EdgeInsetsDirectional.all(8.0),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey[50],
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: TextField(
                          style: TextStyle(
                              color: Colors.black54, fontSize: 15),
                          onSubmitted: (value) {
                            print(value);
                          },
                          keyboardType: TextInputType.text,
                          textAlign: TextAlign.center,
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(top: 8),
                              prefixIcon: Icon(Icons.search,
                                  color: Colors.grey[500]),
                              suffixIcon: Visibility(
                                  visible: false,
                                  maintainSize: true,
                                  maintainState: true,
                                  maintainAnimation: true,
                                  child: Icon(Icons.search)),
                              hintText: AppLocalizations.of(context)
                                  .searchAndDiscover,
                              hintStyle: TextStyle(
                                  fontSize: 13, color: Colors.grey[500]),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none),
                        ),
                      ),
                    ),*/

                    Padding(
                      padding:
                      EdgeInsetsDirectional.only(start: size.width * 0.03, end: size.width * 0.03, top: size.height * 0.02),
                      child: Container(height: size.height * 0.19, child: CarouselBanner()),
                    ),

                    /*Padding(
                      padding: EdgeInsetsDirectional.only(
                          start: size.width * 0.03,
                          end: size.width * 0.03,
                          top: size.height * 0.02),
                      child: Container(
                          height: size.height * 0.19, child: Carousel1()),
                    ),*/
                    Padding(
                      padding: EdgeInsetsDirectional.only(
                          top: size.height * 0.02),
                      child: Container(
                        width: size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.only(
                                  start: 20),
                              child: Text(
                                AppLocalizations.of(context).myUpload,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Color(0xFF0F1013)),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.only(end: 10),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Color(0xFFb58563)),
                                onPressed: () {
                                  Navigator.of(context).pushNamed('/addProduct',arguments: RouteArguments(param1: widget.subStore.id, param2: widget.subStore.storeCategory)).whenComplete(() => setState((){}));
                                  /*Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                        return AddProduct(
                                          storeId: widget.subStore.id,
                                        );
                                      })).whenComplete(() => setState(() {}));*/
                                },
                                child: Text(
                                  AppLocalizations.of(context).newButton,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(
                          top: size.height * 0.02),
                      child: Container(
                          height: size.height * 0.17,
                          child: /*widget.subStore.products.length > 0
                          ? */
                          FutureBuilder<ApiResponse>(
                              future: getProductsByStores(storeId: widget.subStore.id, limit: "40", page: 1),
                              builder: (context, snapshot) {
                                if(snapshot.hasData){
                                  ProductsByStore _product = snapshot.data.Data;
                                  if(_product.products.length==0)
                                    widget.subStore.products.clear();
                                  return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                      _product.products.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Padding(
                                          padding:
                                          const EdgeInsets.only(left: 15),
                                          child: Card(
                                            elevation: 3,
                                            child: Container(
                                              width: size.width * 0.44,
                                              height: size.height * 0.14,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      width: 1.0,
                                                      color: Color(0xFFF1F1F1))),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: size.width * 0.3,
                                                    color: Color(0xFFF1F1F1),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius: BorderRadius.circular(5),
                                                          child: Container(
                                                            width:
                                                            size.width * 0.29,
                                                            height: size.height *
                                                                0.11,
                                                            color:
                                                            Color(0xFFF1F1F1),
                                                            child: Image.network(
                                                              _product.products[index].images.first,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 0.7,
                                                        ),
                                                        Padding(
                                                          padding:
                                                          const EdgeInsetsDirectional
                                                              .only(
                                                              start: 5.0,
                                                              top: 3),
                                                          child: Text(
                                                            _product.products[index].productName,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                fontSize: 14,
                                                                color: Color(
                                                                    0xFF0F1013)),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 1,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width: size.width * 0.129,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .center,
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            Navigator.of(context).pushNamed('/EditProductPartner',arguments: _product.products[index]).whenComplete(() => setState((){}));

                                                            /*Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) {
                                                                      return EditProduct(
                                                                        prod: _product.products[index],
                                                                      );
                                                                    })).then((value) =>
                                                                setState(() {}));*/
                                                          },
                                                          child: Icon(
                                                            Icons.edit,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        Container(
                                                          width:
                                                          size.width * 0.115,
                                                          height:
                                                          size.height * 0.001,
                                                          color:
                                                          Color(0xFF707070),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            dialog(
                                                                context,
                                                                _product.products[index].id);
                                                          },
                                                          child: Icon(
                                                            Icons.close,
                                                            color:
                                                            Colors.red[700],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                }else{
                                  return Center(child: CircularProgressIndicator(color: brown,),);
                                }

                              }
                          )
                        /* : Center(
                        child: Text(
                          AppLocalizations.of(context)
                              .uploadedProductMessage,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.black38,
                          ),
                        ),
                      ),*/
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: size.height * 0.02,
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.only(
                                start: size.width * 0.05),
                            child: Text(
                              AppLocalizations.of(context).products,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Color(0xFF0F1013)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding: EdgeInsetsDirectional.only(
                            top: size.height * 0.02),
                        child:/* widget.subStore.products.length > 0
                        ? */
                        FutureBuilder<ApiResponse>(
                            future: getProductsByStores(storeId: widget.subStore.id, limit: "40", page: 1),
                            builder: (context, snapshot) {
                              if(snapshot.hasData){
                                ProductsByStore _product = snapshot.data.Data;
                                return GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount:
                                  _product.products.length,
                                  gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: size.width * 0.00001,
                                    mainAxisSpacing: size.width * 0.0001,
                                  ),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                          start: 12, end: 12, bottom: 10),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).pushNamed('/productDetailPartner',arguments: _product.products[index]);
                                          /*Navigator.push(context,
                                              MaterialPageRoute(builder:
                                                  (BuildContext context) {
                                                return ProductDetails(
                                                  product: _product.products[index],
                                                );
                                              }));*/
                                        },
                                        child: Card(
                                          elevation: 3,
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                                                child: Container(
                                                  child: SizedBox(
                                                    child: Image.network(_product.products[index].images.first,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  color: Color(0xffF1F1F1),
                                                  height: 100,
                                                  width: 100,
                                                ),
                                              ),
                                              Container(
                                                margin:
                                                EdgeInsetsDirectional.only(
                                                    bottom: 5),
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceEvenly,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                          const EdgeInsetsDirectional
                                                              .only(
                                                              start: 5.0),
                                                          child: Text(
                                                            _product.products[index].productName,
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black87,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                          const EdgeInsetsDirectional
                                                              .only(
                                                              end: 5.0),
                                                          child: Text(
                                                            "\$ ${_product.products[index].price}",
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                          ),
                                                        ),
                                                      ],
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                          const EdgeInsetsDirectional
                                                              .only(
                                                              start: 5.0),
                                                          child:
                                                          RatingBar.builder(
                                                            initialRating: 3,
                                                            ignoreGestures:
                                                            true,
                                                            minRating: 1,
                                                            direction:
                                                            Axis.horizontal,
                                                            allowHalfRating:
                                                            true,
                                                            itemSize: 13,
                                                            itemCount: 5,
                                                            itemPadding:
                                                            EdgeInsetsDirectional
                                                                .only(
                                                                start:
                                                                1.0,
                                                                end:
                                                                1.0),
                                                            itemBuilder:
                                                                (context, _) =>
                                                                Icon(
                                                                  Icons.star,
                                                                  color: Color(
                                                                      0xffb58563),
                                                                ),
                                                            onRatingUpdate:
                                                                (rating) {
                                                              print(rating);
                                                            },
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                          const EdgeInsetsDirectional
                                                              .only(
                                                              end: 5.0),
                                                          child: Text(
                                                            AppLocalizations.of(
                                                                context)
                                                                .sales(_product.products[index].sold.toString()),
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black54,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
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
                                      ),
                                    );
                                  },
                                );
                              }else{
                                return Center(child: CircularProgressIndicator(color: brown,),);
                              }

                            }
                        )
                      /*: Center(
                      child: Text(
                        AppLocalizations.of(context).noProductsYet,
                        style: TextStyle(
                          color: Colors.black38,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),*/
                    ),
                  ],
                );
              }else{
                return Center(child: CircularProgressIndicator(color: brown,),);
              }

            }
          ),
        ),
      ) : NoInternet(),
    );
  }

  dialog(BuildContext context, String productId) {
    Size size = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                width: size.width * 0.8,
                height: size.height * 0.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Color(0xFF707070)),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: size.height * 0.03),
                      child: TextWidget(
                        text:
                        AppLocalizations.of(context).removeProductQuestion,
                        textColor: Color(0xFF0f1013),
                        textSize: 14,
                        isBold: true,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: size.height * 0.05),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () async {
                              await _handleDestroyProduct(productId: productId);
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              width: size.width * 0.3,
                              height: size.height * 0.06,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color:
                                      Color(0xFF0f1013).withOpacity(0.2)),
                                  color: Colors.white),
                              child: Center(
                                child: TextWidget(
                                  text: AppLocalizations.of(context).yes,
                                  textSize: 14,
                                  textColor: Colors.black,
                                  isBold: true,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: size.width * 0.3,
                              height: size.height * 0.06,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color:
                                      Color(0xFF0f1013).withOpacity(0.2)),
                                  color: Colors.white),
                              child: Center(
                                child: TextWidget(
                                  text: AppLocalizations.of(context).no,
                                  textSize: 14,
                                  textColor: Colors.black,
                                  isBold: true,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
