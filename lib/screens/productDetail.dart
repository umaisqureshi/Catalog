import 'dart:async';
import 'dart:convert';
import 'package:category/api/storeApis.dart';
import 'package:category/modals/apiError.dart';
import 'package:category/modals/apiResponse.dart';
import 'package:category/modals/cartGetModel.dart';
import 'package:category/modals/get_all_stores.dart';
import 'package:category/modals/route_arguments.dart';
import 'package:category/modals/user.dart';
import 'package:category/utils/constant.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:category/widgets/noConnection.dart';
import 'package:category/widgets/products.dart';
import 'package:category/widgets/textWidget.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:category/modals/productsByStoresModal.dart';
import 'package:money_converter/Currency.dart';
import 'package:money_converter/money_converter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:category/modals/cartItemCount.dart';

import 'dashboard/photo_view.dart';

class ProductDetail extends StatefulWidget {
  RouteArguments routeArguments;
  //Product product;
  ProductDetail({this.routeArguments});

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {

  ApiResponse _apiResponse = ApiResponse();

  Welcome _userInfo;

  List<String> imagesList = [];

  bool isInternetAvailable = true;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  showInSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<ApiResponse> _handleGetProducts() async {
    print("TOKEN :::::::::::::::::::::: ${_userInfo.token}");
    return getProductsByStores(storeId: widget.routeArguments.param1.storeId, page: 1, limit: '4');
  }

  _handleAddProductToCart({String cId,}) async {
    print("Store Id :::::::::::::::::: ${widget.routeArguments.param1.storeId}");
    double price = await checkAndConvertCurrency(widget.routeArguments.param1.price.toDouble());
    print("PRICE AT ADDING TO CART ::::::::::: $price");
    _apiResponse = await addProductToCart(token: _userInfo.token, customerId: cId,
            productId: widget.routeArguments.param1.id,
            productPrice: price.toStringAsFixed(1),
            pName: widget.routeArguments.param1.productName,
            pImageUrl: widget.routeArguments.param1.images.first,
          sold: widget.routeArguments.param1.sold,
          storeId: widget.routeArguments.param1.storeId,
          storeName: widget.routeArguments.param2
        );

    if ((_apiResponse.ApiError as ApiError) == null) {
      showInSnackBar("Product added to cart successfully");

      cartNotifier.value =  cartNotifier.value+=1;
      cartNotifier.notifyListeners();

      setState(() {});
    } else {
      showInSnackBar((_apiResponse.ApiError as ApiError).error);
    }
  }

  Future<double> getAmounts(double amount) async {
    double usdConvert = await MoneyConverter.convert(
        Currency(Currency.USD, amount: amount), Currency(SharedPrefs().currency));
    return usdConvert;
  }

  Future<double> checkAndConvertCurrency(double price)async{
    if(SharedPrefs().isCurrencyAvailable()){
      return defaultCurrency != SharedPrefs().currency ? await getAmounts(price) : price;
    }
    return price;
  }

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

  @override
  void initState() {
    initConnectivity();
    _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).productDetail,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: isInternetAvailable ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.only(top: size.height * 0.05),
              child: InkWell(
                onTap: (){
                  print("pressed");
                  //FullSizePhoto(url: widget.product.images.toString());
                  Navigator.push(context, MaterialPageRoute(builder: (context) => FullSizePhoto(url: widget.routeArguments.param1.images.first.toString(),)));
                },
                child: Container(
                  width: size.width,
                  height: size.height * 0.3,
                  color: Colors.white,
                  child: Swiper(
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        child: Image.network(
                          widget.routeArguments.param1.images[index],
                              fit: BoxFit.contain,
                            )
                        );
                    },
                    autoplay: false,
                    itemCount: widget.routeArguments.param1.images.length,
                    scrollDirection: Axis.horizontal,
                    pagination: new SwiperPagination(),
                    control: new SwiperControl(
                        disableColor: Color(0xFF000000),
                        color: Color(0xFF000000)
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(top: size.height * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 20),
                    child: Text(
                      widget.routeArguments.param1.productName,
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  FutureBuilder(
                    future: checkAndConvertCurrency(widget.routeArguments.param1.price.toDouble()),
                    builder: (context, AsyncSnapshot<double> snapshot){
                      if(snapshot.hasData){
                        return Padding(
                          padding: const EdgeInsetsDirectional.only(
                            end: 25,
                          ),
                          child: Text(
                            "${SharedPrefs().isCurrencyAvailable() ? SharedPrefs().currency : defaultCurrency} ${snapshot.data.toStringAsFixed(1)}",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        );
                      }
                      else
                        return Center(child: CircularProgressIndicator(color: Colors.brown,),);
                    }
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 20, top: 10),
                  child: RatingBar.builder(
                    initialRating: 4.5,
                    ignoreGestures: true,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemSize: 18,
                    itemCount: 5,
                    itemPadding:
                    EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.black,
                    ),
                    onRatingUpdate: (rating) {
                      print(rating);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(top: 10),
                  child: Text("4.5",
                      style: TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold)),
                ),
                Spacer(),
                FutureBuilder<ApiResponse>(
                  future: _handleGetProducts(),
                  builder: (context, snapshot) {
                   if(snapshot.hasData){
                     ProductsByStore _productByStore = snapshot.data.Data as ProductsByStore;
                     return Padding(
                       padding: EdgeInsetsDirectional.only(end: 25, top: 10),
                       child: TextWidget(
                         text: AppLocalizations.of(context).leftInStock(_productByStore.products.first.stock.toString()),
                         textSize: 12,
                         isBold: true,
                         textColor: Color(0xFF0f1013).withOpacity(0.5),
                       ),
                     );
                   }
                   else{
                     return Center(child: Container());
                   }
                  }
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 20, top: 9),
              child: Text(
                AppLocalizations.of(context).sales(widget.routeArguments.param1.sold.toString()),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff707070),
                ),
              ),
            ),

            Spacer(flex: 1,),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 20, top: 25),
              child: Text(
                AppLocalizations.of(context).description,
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(
                  start: 20, end: 30, top: 5, bottom: 40),
              child: Text(
                widget.routeArguments.param1.productDescription??"",
                //"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.  Lorem Ipsum is simply dummy text of the printing and typesetting industry.  Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(
                  start: size.width * 0.06, end: size.width * 0.06),
              child: InkWell(
                onTap: () {
                  _handleAddProductToCart(cId: _userInfo.userData.id);
                  //Navigator.pushNamed(context, '/cart');
                  },
                child: Container(
                  width: size.width,
                  height: size.height * 0.07,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: brown),
                  child: Center(
                    child: TextWidget(
                      text: AppLocalizations.of(context).addToCart,
                      textColor: Colors.white,
                      textSize: 15,
                      isBold: true,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ) : NoInternet(),
      ),
    );
  }
}
