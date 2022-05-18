import 'dart:async';
import 'dart:convert';
import 'package:category/TopRow.dart';
import 'package:category/api/auth_apis.dart';
import 'package:category/api/storeApis.dart';
import 'package:category/chat/repo/route_argument.dart';
import 'package:category/modals/apiResponse.dart';
import 'package:category/modals/get_all_orders.dart';
import 'package:category/modals/productsByStoresModal.dart';
import 'package:category/modals/route_arguments.dart';
import 'package:category/modals/store_views.dart';
import 'package:category/modals/store_vise_disco_model.dart';
import 'package:category/modals/subStoreModel.dart';
import 'package:category/modals/user.dart';
import 'package:category/screens/dashboard/search_bar_products.dart';
import 'package:category/utils/constant.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:category/widgets/ProductCardView.dart';
import 'package:category/widgets/drawer_Widget.dart';
import 'package:category/widgets/noConnection.dart';
import 'package:category/widgets/subStoresList.dart';
import 'package:category/widgets/textWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:category/modals/storeByCategory.dart';
import 'package:flutter/services.dart';
import 'package:money_converter/Currency.dart';
import 'package:money_converter/money_converter.dart';
import 'package:page_transition/page_transition.dart';
import '../productDetail.dart';

class CustomerHomeExtended extends StatefulWidget {
  Store store;

  CustomerHomeExtended({this.store});

  @override
  _CustomerHomeExtendedState createState() => _CustomerHomeExtendedState();
}

class _CustomerHomeExtendedState extends State<CustomerHomeExtended> {
  bool visible = true;
  static const int PAGE_SIZE = 2;
  ApiResponse _apiResponse = ApiResponse();
  Welcome _userInfo;

  StoreViseDiscoModel _storeViseDiscoModel;

  Future<ApiResponse> _getStoreViseDisco() async {
    _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
    _apiResponse = await storeViseDiscount(token: _userInfo.token, storeId: widget.store.id);
    return _apiResponse;
  }

  Future<ApiResponse> _storeView() async {
    _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
    _apiResponse = await storeViews(token: _userInfo.token, storeID: widget.store.id);
    return _apiResponse;
  }

  Future<ApiResponse> _favProduct(String id) async {
    _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
    _apiResponse = await favStoreAndPro(token: _userInfo.token);
    return _apiResponse;
  }

  Future<ApiResponse> _handleGetAllOrders() async {
    Welcome _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
    print("TOKEN :::::::::::::::::::::: ${_userInfo.token}");
    return getAllOrders(token: _userInfo.token);
  }

  showInSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<ApiResponse> _handleGetProducts() async {
    print("TOKEN :::::::::::::::::::::: ${_userInfo.token}");
    return getProductsByStores(storeId: widget.store.id, page: 1, limit: '4');
  }

  Future<ApiResponse> _handleGetSubStores({@required String mainStoreId}) async {
    return getSubStores(token: _userInfo.token, mainStoreId: mainStoreId);
  }

  Future<double> getAmounts(double amount) async {
    double usdConvert = await MoneyConverter.convert(Currency(Currency.USD, amount: amount), Currency(SharedPrefs().currency));
    return usdConvert;
  }

  Future<double> checkAndConvertCurrency(double price) async {
    if (SharedPrefs().isCurrencyAvailable()) {
      return defaultCurrency != SharedPrefs().currency ? await getAmounts(price) : price;
    }
    return price;
  }

  bool isInternetAvailable = true;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        setState(() {
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
    _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
    print("STORE ID >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ${widget.store.id}");
    initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
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
      child: Scaffold(
        drawer: DrawerCustomer(),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Color(0xFFb58563)),
          elevation: 0,
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
        backgroundColor: Colors.white,
        body: isInternetAvailable
            ? Stack(
                children: [
                  ListView(
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.only(top: visible ? size.height * 0.01 : size.height * 0.01),
                        child: SingleChildScrollView(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                visible
                                    ? Container()
                                    : Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                            // color: Color(0xFFF0EFEF),
                                            color: Colors.blueGrey[50],
                                            borderRadius: BorderRadius.circular(5.0),
                                          ),
                                          child: TextField(
                                            style: TextStyle(color: Colors.black54, fontSize: 15),
                                            onSubmitted: (value) {
                                              print(value);
                                            },

                                            onTap: (){
                                              Navigator.push(context, PageTransition(
                                                  duration: Duration(milliseconds: 250),
                                                  type: PageTransitionType.bottomToTop, child: SearchBarProductsScreen(id: widget.store.id)));

                                            },
                                            keyboardType: TextInputType.text,
                                            readOnly: true,
                                            textAlign: TextAlign.center,
                                            textInputAction: TextInputAction.search,
                                            decoration: InputDecoration(
                                                contentPadding: EdgeInsetsDirectional.only(top: 8),
                                                prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                                                suffixIcon: Visibility(
                                                    visible: false,
                                                    maintainSize: true,
                                                    maintainState: true,
                                                    maintainAnimation: true,
                                                    child: Icon(Icons.search)),
                                                hintText: AppLocalizations.of(context).searchForProducts,
                                                hintStyle: TextStyle(fontSize: 13, color: Colors.grey[500]),
                                                border: InputBorder.none,
                                                enabledBorder: InputBorder.none),
                                          ),
                                        ),
                                      ),
                                SizedBox(
                                  height: visible ? 0 : 10,
                                ),
                                Center(
                                  child: Card(
                                    elevation: 5,
                                    child: Container(
                                      width: 120,
                                      height: 110,
                                      color: Colors.white,
                                      child: Center(
                                        child: SizedBox(
                                          height: 90,
                                          width: 90,
                                          child: Image.network(
                                            widget.store.storeLogo,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Center(
                                  child: TextWidget(
                                    text: widget.store.storeName,
                                    textColor: Color(0xFF0f1013),
                                    isBold: true,
                                    textSize: 20,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Card(
                                      elevation: 3,
                                      child: Container(
                                        width: size.width * 0.23,
                                        height: size.height * 0.12,
                                        color: Colors.white,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                                width: size.width * 0.08,
                                                height: size.height * 0.06,
                                                color: Colors.white,
                                                child: Image.asset(
                                                  'assets/images/offer.png',
                                                )),
                                            TextWidget(
                                              text: "50%",
                                              textSize: 10,
                                              isBold: true,
                                              textColor: Colors.black,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Card(
                                      elevation: 3,
                                      child: Container(
                                        width: size.width * 0.23,
                                        height: size.height * 0.12,
                                        color: Colors.white,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: size.width * 0.08,
                                              height: size.height * 0.06,
                                              color: Colors.white,
                                              child: Image.asset('assets/images/location_pic.png'),
                                            ),
                                            TextWidget(
                                              text: widget.store.location,
                                              textSize: 10,
                                              isBold: true,
                                              textColor: Colors.black,
                                            ),
                                            /*FutureBuilder(
                                                future: _storeView(),
                                                builder: (context, AsyncSnapshot<ApiResponse> snapshot) {
                                                  if (snapshot.hasData) {
                                                    StoreViews _views;
                                                    _views = snapshot.data.Data;
                                                    return TextWidget(
                                                      text: _views.views.counter.toString(),
                                                      textSize: 10,
                                                      isBold: true,
                                                      textColor: Colors.black,
                                                    );
                                                  } else {
                                                    return Center(
                                                      child: CircularProgressIndicator(),
                                                    );
                                                  }
                                                }),*/
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        DocumentSnapshot snap = await FirebaseFirestore.instance.collection("Users").doc(widget.store.userId).get();
                                        snap.exists
                                            ? Navigator.of(context).pushNamed('/chat',
                                                arguments: RouteArgument(
                                                    param1: widget.store.userId,
                                                    param2: snap.data()['profileImageUrl'].length > 0 ? snap.data()['profileImageUrl'] : 'default',
                                                    param3: snap.data()['username'] ?? 'User'))
                                            : print("No User");
                                      },
                                      child: Card(
                                        elevation: 4,
                                        child: Container(
                                          width: size.width * 0.23,
                                          height: size.height * 0.12,
                                          color: Colors.white,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                  width: size.width * 0.08, height: size.height * 0.06, color: Colors.white, child: Icon(Icons.chat)),
                                              TextWidget(
                                                text: AppLocalizations.of(context).chat,
                                                textSize: 10,
                                                isBold: true,
                                                textColor: Colors.black,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.only(start: 10, end: 10, bottom: 15, top: 15),
                                  child: TextWidget(
                                    text: AppLocalizations.of(context).subStore,
                                    textSize: 15,
                                    textColor: primary,
                                    isBold: true,
                                  ),
                                ),
                                FutureBuilder<ApiResponse>(
                                    future: _handleGetSubStores(mainStoreId: widget.store.id),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        SubStoreModel _subStore = snapshot.data.Data;
                                        return Container(
                                          height: 160,
                                          child: ListView.builder(
                                              itemCount: _subStore.stores.length,
                                              scrollDirection: Axis.horizontal,
                                              padding: EdgeInsetsDirectional.only(start: 2),
                                              itemBuilder: (context, index) {
                                                return SubStoresItems(
                                                  subStore: _subStore.stores[index],
                                                  customerId: _userInfo.userData.id,
                                                  token: _userInfo.token,
                                                );
                                              }),
                                        );
                                      } else {
                                        return Center(
                                          child: CircularProgressIndicator(
                                            color: brown,
                                          ),
                                        );
                                      }
                                    }),
                                Padding(
                                  padding: const EdgeInsetsDirectional.only(start: 10, end: 10, bottom: 15, top: 15),
                                  child: TextWidget(
                                    text: AppLocalizations.of(context).latestSales,
                                    textSize: 15,
                                    textColor: primary,
                                    isBold: true,
                                  ),
                                ),
                                Container(
                                  height: 120,
                                  child: FutureBuilder<ApiResponse>(
                                      future: _handleGetAllOrders(),
                                      builder: (context, AsyncSnapshot<ApiResponse> snapshot) {
                                        if (snapshot.hasData) {
                                          GetAllOrdersModel _getAllOrdersModel = snapshot.data.Data as GetAllOrdersModel;
                                          if (_getAllOrdersModel == null && _getAllOrdersModel.orders.isEmpty) {
                                            return Container();
                                          }
                                          List<Item> _items = [];
                                          List<Item> _newItems = [];
                                          _getAllOrdersModel.orders.forEach((element) {
                                            element.items.forEach((element) {
                                              _items.add(element);
                                            });
                                          });
                                          _items.sort((a, b) {
                                            return b.sold.compareTo(a.sold);
                                          });
                                          _newItems = _items;
                                          return ListView(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            children: _newItems
                                                .map((e) => Padding(
                                                padding: const EdgeInsets.all(5.0),
                                                child: Column(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        Product pro = Product(id: e.id, price: int.tryParse(e.price.split(".").first), images: [e.imageUrl], productName: e.productName,storeId: e.storeId, sold: e.sold,);
                                                        Navigator.of(context).pushNamed("/ProductDetail",arguments: RouteArguments(param1: pro));
                                                      },
                                                      child: Container(
                                                        height: 80,
                                                        width: 100,
                                                        decoration: BoxDecoration(
                                                          //color: Colors.brown,
                                                        ),
                                                        child: Image.network(
                                                          e.imageUrl,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        e.productName,
                                                        style: TextStyle(fontWeight: FontWeight.w500),
                                                      ),
                                                    )
                                                  ],
                                                )))
                                                .toList(),
                                          );
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.brown,
                                            ),
                                          );
                                        }
                                      }),

                                  /*child: FutureBuilder<ApiResponse>(
                            future: _handleGetAllOrders(),
                            builder: (context, AsyncSnapshot<ApiResponse> snapshot) {
                              if (snapshot.hasData) {
                                GetAllOrdersModel _getAllOrdersModel = snapshot.data.Data as GetAllOrdersModel;
                                return _getAllOrdersModel != null
                                    ? ListView.builder(

                                    scrollDirection: material.Axis.horizontal,
                                    padding: EdgeInsetsDirectional.only(
                                        start: 10),


                          itemCount: _getAllOrdersModel.orders.length,
                                    itemBuilder: (context, index) {

                                      return InkWell(
                                        onTap: (){
                                          Navigator.of(context).pushNamed(
                                              '/SubStoreDetails',
                                              arguments: SubStoreH(
                                                  id: _getAllOrdersModel.orders[index].id,
                                                  storeName: "",
                                                  storeCategory: "",
                                                  storeLogo: _getAllOrdersModel.orders[index].items[index].imageUrl));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .only(end: 8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                  height: 80,
                                                  width: 120,
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsetsDirectional
                                                        .all(5.0),
                                                    child: Image.network(
                                                      _getAllOrdersModel.orders[index].items[index].imageUrl,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  )),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                width: 100,
                                                child: TextWidget(
                                                  text: AppLocalizations.of(
                                                      context).discountMessage(
                                                      _getAllOrdersModel.orders[index].items[index].productName),
                                                  isBold: true,
                                                  textSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    })
                                    : Center(
                                  child: Text("No Sales Found"),
                                );
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            }),*/
                                ),
                                /*FutureBuilder<ApiResponse>(
                                    future: _getStoreViseDisco(),
                                    builder: (context, AsyncSnapshot<ApiResponse> snapshot) {
                                      if (snapshot.hasData) {
                                        _storeViseDiscoModel = snapshot.data.Data as StoreViseDiscoModel;
                                        return _storeViseDiscoModel != null
                                            ? Container(
                                                height: 120,
                                                child: ListView.builder(
                                                    itemCount: _storeViseDiscoModel.data.length,
                                                    scrollDirection: Axis.horizontal,
                                                    padding: EdgeInsets.only(left: 10),
                                                    itemBuilder: (context, index) {
                                                      return Padding(
                                                        padding: const EdgeInsets.only(right: 8.0),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            Card(
                                                              elevation: 3,
                                                              child: SizedBox(
                                                                  height: 80,
                                                                  width: 120,
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.all(5.0),
                                                                    child: Image.network(
                                                                      _storeViseDiscoModel.data[index].discountImg,
                                                                      fit: BoxFit.contain,
                                                                    ),
                                                                  )),
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            TextWidget(
                                                              text: AppLocalizations.of(context).discountMessage(
                                                                _storeViseDiscoModel.data[index].discount,
                                                              ),
                                                              isBold: true,
                                                              textSize: 10,
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }),
                                              )
                                            : Container();
                                      } else {
                                        return Center(child: CircularProgressIndicator());
                                      }
                                    }),*/
                                Padding(
                                  padding: const EdgeInsetsDirectional.only(start: 10, end: 10, top: 15, bottom: 15),
                                  child: TextWidget(
                                    text: AppLocalizations.of(context).highRatedProducts,
                                    textSize: 15,
                                    textColor: primary,
                                    isBold: true,
                                  ),
                                ),
                                FutureBuilder<ApiResponse>(
                                    future: _handleGetProducts(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        ProductsByStore products = snapshot.data.Data;
                                        return Container(
                                          height: size.height * 0.27,
                                          color: Colors.white,
                                          child: Padding(
                                            padding: EdgeInsetsDirectional.only(start: size.width * 0.0001),
                                            child: ListView.builder(
                                                itemCount: products.products.length,
                                                scrollDirection: Axis.horizontal,
                                                padding: EdgeInsetsDirectional.only(start: 10, end: 5),
                                                itemBuilder: (context, index) {
                                                  return FutureBuilder(
                                                      future: checkAndConvertCurrency(products.products[index].price.toDouble()),
                                                      builder: (context, AsyncSnapshot<double> snap) {
                                                        if (snap.hasData) {
                                                          return Row(
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  Navigator.of(context)
                                                                      .pushNamed("/ProductDetail", arguments: RouteArguments(param1: products.products[index], param2: widget.store.storeName));
                                                                },
                                                                child: ProductCardView(
                                                                  imagesList: products.products[index].images,
                                                                  name: products.products[index].productName,
                                                                  price: snap.data.toStringAsFixed(1),
                                                                  Image: products.products[index].images.first,
                                                                  cId: _userInfo.userData.id,
                                                                  pId: products.products[index].id,
                                                                  token: _userInfo.token,

                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                            ],
                                                          );
                                                        } else {
                                                          return Center(
                                                            child: CircularProgressIndicator(
                                                              color: Colors.brown,
                                                            ),
                                                          );
                                                        }
                                                      });
                                                }),
                                          ),
                                        );
                                      } else {
                                        return Center(
                                          child: CircularProgressIndicator(
                                            color: brown,
                                          ),
                                        );
                                      }
                                    }),
                                Padding(
                                  padding: const EdgeInsetsDirectional.only(start: 20, end: 20, top: 15, bottom: 15),
                                  child: TextWidget(
                                    text: AppLocalizations.of(context).products,
                                    textSize: 15,
                                    textColor: primary,
                                    isBold: true,
                                  ),
                                ),
                                FutureBuilder<ApiResponse>(
                                    future: _handleGetProducts(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        ProductsByStore products = snapshot.data.Data;
                                        return GridView.builder(
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemCount: products.products.length,
                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: size.width * 0.020,
                                            mainAxisSpacing: size.width * 0.03,
                                            childAspectRatio: 1 / 1.17,
                                          ),
                                          itemBuilder: (BuildContext context, int index) {
                                            return FutureBuilder(
                                                future: checkAndConvertCurrency(products.products[index].price.toDouble()),
                                                builder: (context, AsyncSnapshot<double> snap) {
                                                  if (snap.hasData) {
                                                    return InkWell(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .pushNamed("/ProductDetail", arguments: RouteArguments(param1: products.products[index], param2: widget.store.storeName));
                                                          /*Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) {
                                                            return ProductDetail(
                                                              product: products
                                                                      .products[
                                                                  index],
                                                            );
                                                          }));*/
                                                        },
                                                        child: Container(
                                                          margin: EdgeInsets.only(left: 10),
                                                          child: ProductCardView(
                                                              imagesList: products.products[index].images,
                                                              name: products.products[index].productName,
                                                              price: snap.data.toStringAsFixed(1),
                                                              Image: products.products[index].images[0],
                                                              token: _userInfo.token,
                                                              pId: products.products[index].id,
                                                              cId: _userInfo.userData.id),
                                                        ));
                                                  } else {
                                                    return Center(
                                                      child: CircularProgressIndicator(
                                                        color: Colors.brown,
                                                      ),
                                                    );
                                                  }
                                                });
                                          },
                                        );
                                      } else {
                                        return Center(
                                          child: CircularProgressIndicator(color: brown),
                                        );
                                      }
                                    }),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : NoInternet(),
      ),
    );
  }
}
