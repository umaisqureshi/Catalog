import 'dart:convert';

import 'package:category/api/storeApis.dart';
import 'package:category/modals/apiResponse.dart';
import 'package:category/modals/mainStoreModal.dart';
import 'package:category/modals/productsByStoresModal.dart';
import 'package:category/modals/route_arguments.dart';
import 'package:category/modals/user.dart';
import 'package:category/utils/constant.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:category/widgets/ProductCardView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:money_converter/Currency.dart';
import 'package:money_converter/money_converter.dart';

class SearchBarProductsScreen extends StatefulWidget {

  String id;
  SearchBarProductsScreen({this.id});

  @override
  _SearchBarProductsScreenState createState() => _SearchBarProductsScreenState();
}

class _SearchBarProductsScreenState extends State<SearchBarProductsScreen> {

  static const int PAGE_SIZE = 2;
  ApiResponse _apiResponse = ApiResponse();
  Welcome _userInfo;
  List<Product> fixItems = [];
  List<Product> filterItems = [];

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

  Future<void> _handleGetProducts() async {
    /*print("TOKEN :::::::::::::::::::::: ${_userInfo.token}");*/
    fixItems.clear();
    filterItems.clear();
    setState(() {});

    await getProductsByStores(storeId: widget.id, page: 1, limit: '4', ).then((value){
      fixItems.addAll((value.Data as ProductsByStore).products);
      filterItems = ((value.Data as ProductsByStore).products);
    });
    setState(() {});
  }

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) _handleGetProducts();
    });

    _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));

    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsetsDirectional.all(8.0),
          child: Container(
            height: 45,
            decoration: BoxDecoration(
              // color: Color(0xFFF0EFEF),
              color: Colors.blueGrey[50],
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey[500]),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 150,
                    child: TextFormField(
                      onChanged: (input) {
                        if (input.isEmpty) {
                          filterItems = fixItems;
                        } else {
                          filterItems = fixItems.where((element) => element.productName.toLowerCase().contains(input.toLowerCase())).toList();
                        }
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        hintText: "Enter Product Name",
                        hintStyle: TextStyle(fontSize: 13, color: Colors.grey[500]),

                      ),
                      style: TextStyle(),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {
                SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                  if (mounted) _handleGetProducts();
                });
              },
              icon: Icon(Icons.refresh))
        ],
      ),
      body: filterItems.isNotEmpty
          ? Column(
        children: [
          SizedBox(
            height: 15,
          ),

          SizedBox(
            height: 30,
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                //height: Responsive.isMobile(context)?MediaQuery.of(context).size.height / 0.9 : MediaQuery.of(context).size.height * 0.7,
                  width: double.infinity,
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: filterItems.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: size.width * 0.020,
                      mainAxisSpacing: size.width * 0.03,
                      childAspectRatio: 1 / 1.17,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return FutureBuilder(
                          future: checkAndConvertCurrency(filterItems[index].price.toDouble()),
                          builder: (context, AsyncSnapshot<double> snap) {
                            if (snap.hasData) {
                              return InkWell(
                                  onTap: () {
                                    Navigator.of(context).pushNamed('/ProductDetail', arguments: RouteArguments(param1: filterItems[index]));
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
                                        imagesList: filterItems[index].images,
                                        name: filterItems[index].productName,
                                        price: snap.data.toStringAsFixed(1),
                                        Image: filterItems[index].images[0],
                                        token: _userInfo.token,
                                        //token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MTc5NDk5NmZiMTZhOTAwMTY2ZTA4M2MiLCJyb2xlIjoiY3VzdG9tZXIiLCJpYXQiOjE2MzU0MTU5NTAsImV4cCI6MTY2Njk3MzU1MH0.2IX1Mt1Ik3yuFwEqJuj3uADACRdpcq3ho1K7FIQkODA",
                                        pId: filterItems[index].id,
                                        cId: _userInfo.userData.id,
                                        //cId: "61794996fb16a900166e083c"
                                        ),
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
                  )),
            ),
          ),
        ],
      )
          : Center(
          child: CircularProgressIndicator(
            color: Colors.brown,
          )),
    );
  }
}
