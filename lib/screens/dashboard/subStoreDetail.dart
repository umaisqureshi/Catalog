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
import 'package:category/modals/subStoreModel.dart';
import 'package:category/modals/user.dart';
import 'package:category/screens/dashboard/search_bar_products.dart';
import 'package:category/utils/constant.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:category/widgets/PopularStoreItems.dart';
import 'package:category/widgets/ProductCardView.dart';
import 'package:category/widgets/drawer_Widget.dart';
import 'package:category/widgets/noConnection.dart';
import 'package:category/widgets/storesData.dart';
import 'package:category/widgets/subStoresList.dart';
import 'package:category/widgets/textWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:category/modals/storeByCategory.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import '../productDetail.dart';

class SubStoreDetails extends StatefulWidget {
  SubStoreH store;
  SubStoreDetails({this.store});

  @override
  _SubStoreDetailsState createState() => _SubStoreDetailsState();
}

class _SubStoreDetailsState extends State<SubStoreDetails> {
  bool visible = true;
  static const int PAGE_SIZE = 2;

  ApiResponse _apiResponse = ApiResponse();
  Welcome _userInfo;

  showInSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<ApiResponse> _handleGetAllOrders() async {
    Welcome _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
    print("TOKEN :::::::::::::::::::::: ${_userInfo.token}");
    return getAllOrders(token: _userInfo.token);
  }

  Future<ApiResponse> _handleGetProducts() async {
    print("TOKEN :::::::::::::::::::::: ${_userInfo.token}");
    return getProductsByStores(storeId: widget.store.id, page: 1, limit: '4');
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
                                            readOnly: true,
                                            style: TextStyle(color: Colors.black54, fontSize: 15),
                                            onSubmitted: (value) {
                                              print(value);
                                            },
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  PageTransition(
                                                      duration: Duration(milliseconds: 250),
                                                      type: PageTransitionType.bottomToTop,
                                                      child: SearchBarProductsScreen(id: widget.store.id)));
                                            },
                                            keyboardType: TextInputType.text,
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
                                                hintText: "Enter Product Name",
                                                //AppLocalizations.of(context).searchAndDiscover,
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
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                    elevation: 5,
                                    child: Container(
                                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                      width: 120,
                                      height: 110,
                                      child: SizedBox(
                                          width: double.infinity,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: Image.network(
                                              widget.store.storeLogo,
                                              fit: BoxFit.cover,
                                            ),
                                          )),
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
                                              text: "Benghazi",
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

                                    /*Card(
                                      elevation: 3,
                                      child: Container(
                                        width: size.width * 0.23,
                                        height: size.height * 0.12,
                                        color: Colors.white,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                                width: size.width * 0.08,
                                                height: size.height * 0.06,
                                                color: Colors.white,
                                                child: Image.asset(
                                                  'assets/images/eye.png',
                                                )),
                                            TextWidget(
                                              text: "230",
                                              textSize: 10,
                                              isBold: true,
                                              textColor: Colors.black,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),*/
                                    Card(
                                      elevation: 4,
                                      child: Container(
                                        width: size.width * 0.23,
                                        height: size.height * 0.12,
                                        color: Colors.white,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                DocumentSnapshot snap =
                                                    await FirebaseFirestore.instance.collection("Users").doc(widget.store.userId).get();
                                                print("UserId ${widget.store.userId}");
                                                snap.exists
                                                    ? Navigator.of(context).pushNamed('/chat',
                                                        arguments: RouteArgument(
                                                            param1: widget.store.userId,
                                                            param2: snap.data()['profileImageUrl'].length > 0
                                                                ? snap.data()['profileImageUrl']
                                                                : 'default',
                                                            param3: snap.data()['username'] ?? 'User'))
                                                    : SnackBar(content: (Text('No User')));
                                                print("No User");
                                              },
                                              child: Container(
                                                  width: size.width * 0.08, height: size.height * 0.06, color: Colors.white, child: Icon(Icons.chat)),
                                            ),
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
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
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
                                                            Product pro = Product(
                                                                id: e.id,
                                                                price: int.tryParse(e.price.split(".").first),
                                                                images: [e.imageUrl],
                                                                productName: e.productName,
                                                                storeId: e.storeId,
                                                                sold: e.sold);
                                                            Navigator.of(context).pushNamed("/ProductDetail", arguments: RouteArguments(param1: pro));
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

                                /*Container(
                                  height: 120,
                                  child: ListView.builder(
                                      itemCount: 5,
                                      scrollDirection: Axis.horizontal,
                                      padding: EdgeInsets.only(left: 10),
                                      itemBuilder: (context, i) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Card(
                                                elevation: 3,
                                                child: SizedBox(
                                                    height: 80,
                                                    width: 120,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Image.asset(
                                                        'assets/images/shopLogo.png',
                                                        fit: BoxFit.contain,
                                                      ),
                                                    )),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              TextWidget(
                                                text:
                                                    AppLocalizations.of(context)
                                                        .discountMessage("60"),
                                                isBold: true,
                                                textSize: 10,
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                ),*/
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
                                          height: size.height * 0.29,
                                          color: Colors.white,
                                          child: ListView.builder(
                                              itemCount: products.products.length,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                return Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .pushNamed('/ProductDetail', arguments: RouteArguments(param1: products.products[index]));
                                                      },
                                                      child: ProductCardView(
                                                          token: _userInfo.token,
                                                          pId: products.products[index].id,
                                                          name: products.products[index].productName,
                                                          price: products.products[index].price.toString(),
                                                          imagesList: products.products[index].images,
                                                          Image: products.products[index].images.first),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                  ],
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
                                        //return PagewiseGridView(products: products,);
                                        return GridView.builder(
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemCount: products.products.length,
                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            childAspectRatio: 0.9,
                                            mainAxisSpacing: 10,
                                          ),
                                          itemBuilder: (BuildContext context, int index) {
                                            return InkWell(
                                                onTap: () {
                                                  Navigator.of(context)
                                                      .pushNamed('/ProductDetail', arguments: RouteArguments(param1: products.products[index]));
                                                  /* Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                                      return ProductDetail(
                                                        product:
                                                        products.products[index],
                                                      );
                                                    }));*/
                                                },
                                                child: ProductCardView(
                                                    pId: products.products[index].id,
                                                    imagesList: products.products[index].images,
                                                    name: products.products[index].productName,
                                                    price: products.products[index].price.toString(),
                                                    Image: products.products[index].images[0]));
                                          },
                                        );
                                      } else {
                                        return Center(
                                          child: CircularProgressIndicator(
                                            color: brown,
                                          ),
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
