import 'dart:convert';
import 'package:category/api/storeApis.dart';
import 'package:category/modals/SinglePromoCode.dart';
import 'package:category/modals/apiResponse.dart';
import 'package:category/modals/cartGetModel.dart';
import 'package:category/modals/cartItemCount.dart';
import 'package:category/modals/cart_remove_item.dart';
import 'package:category/modals/get_all_stores.dart';
import 'package:category/modals/promo_codes_model.dart';
import 'package:category/modals/route_arguments.dart';
import 'package:category/modals/user.dart';
import 'package:category/screens/checkout.dart';
import 'package:category/utils/constant.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:category/widgets/buttonWidget.dart';
import 'package:category/widgets/cartItemWidget.dart';
import 'package:category/widgets/dividerWidget.dart';
import 'package:category/widgets/textWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

class CartScreen extends StatefulWidget {
  final PromoCodeItemsModel data;

  CartScreen({this.data,});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  ApiResponse _apiResponse = ApiResponse();
  ApiResponse _apiResponse1 = ApiResponse();

  Welcome _userInfo;

  double discount1;

  FocusNode focusNode = FocusNode();
  bool isApply = false;
  String promoCode;

  double totalPrice = 0.0;
  String cartId;
  CartGetModel _cartGetModel;
  AllStoreItem _allStoreItem;
  CartRemoveItem _cartRemoveItem;
  TextEditingController textEditingController = TextEditingController();

  showInSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _getCartProduct() async {
    _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
    _apiResponse = await getCartProduct(token: _userInfo.token);
    _cartGetModel = _apiResponse.Data;
    if (_cartGetModel != null) {
      cartId = _cartGetModel != null ? _cartGetModel.cart.id : "";
      _cartGetModel.cart.products.forEach((element) {
        totalPrice = totalPrice + double.parse(element.price.toString());
      });
    }
    cartNotifier.value = (_apiResponse.Data as CartGetModel).cart.products.length ?? 0;
    cartNotifier.notifyListeners();
    _cartGetModel.cart.products.forEach((element) {
      print(element.productName);
    });
    setState(() {});
  }

  Future<ApiResponse> _removeCartItem(String id) async {
    _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
    _apiResponse1 = await cartItemRemove(token: _userInfo.token, pID: id);
    return _apiResponse1;
  }

  Future<ApiResponse> _removeAllItems(String cId) async {
    _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
    _apiResponse1 = await cartAllItemsRemove(token: _userInfo.token, cartID: cId);
    return _apiResponse1;
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      await _getCartProduct();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final PageController controller = PageController();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: TextWidget(
            text: AppLocalizations.of(context).cart,
            textSize: 15,
            textColor: primary,
            isBold: true,
          ),
        ),
        body: _cartGetModel != null
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    DividerWidget(),
                    Container(
                      height: 230,
                      child: PageView.builder(
                        physics: BouncingScrollPhysics(),
                        controller: controller,
                        itemCount: _cartGetModel.cart.products.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return _cartGetModel.cart.products.length == 0
                              ? Container(
                                  decoration: BoxDecoration(
                                      color: Colors.deepOrange,
                                      image: DecorationImage(
                                        image: AssetImage("assets/empty cart.png"),
                                        fit: BoxFit.cover,
                                      )),
                                  child: Text("Cart is empty",style: TextStyle(color: Colors.black),),
                                )
                              : Column(
                                  children: <Widget>[
                                    CartItemWidget(data: _cartGetModel.cart.products[index]),
                                    DividerWidget(),
                                    InkWell(
                                      onTap: () {
                                        _removeCartItem(_cartGetModel.cart.products[index].id).whenComplete(() => Navigator.of(context).pop());
                                        //_cartGetModel.cart.products.removeAt(index);
                                        print("STORE ID >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ${_cartGetModel.cart.products[index].id}");
                                      },
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/images/remove.png',
                                              scale: 1.5,
                                            ),
                                            SizedBox(
                                              width: 7,
                                            ),
                                            TextWidget(
                                              text: AppLocalizations.of(context).removeItem,
                                              textSize: 16,
                                              textColor: primary,
                                              isBold: true,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                        },
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: ExpansionTile(
                        initiallyExpanded: widget.data == null,
                        backgroundColor: white,
                        title: Row(
                          children: [
                            TextWidget(
                              textColor: primary.withOpacity(0.4),
                              text: AppLocalizations.of(context).discountCode,
                              textSize: 15,
                            )
                          ],
                        ),
                        children: [
                          Column(
                            children: [
                              DividerWidget(),
                              Padding(
                                padding: const EdgeInsetsDirectional.only(start: 20, end: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Container(
                                        height: 45,
                                        child: TextField(
                                          focusNode: focusNode,
                                          readOnly: isApply,
                                          controller: textEditingController,
                                          scrollPadding: EdgeInsets.zero,
                                          decoration: InputDecoration(
                                            hintText:
                                                widget.data != null ? widget.data.promocode : AppLocalizations.of(context).enterDiscountCode,
                                            contentPadding: EdgeInsets.only(left: 10),
                                            suffixIcon: ButtonWidget(
                                                isPadding: false,
                                                buttonHeight: 50,
                                                buttonWidth: MediaQuery.of(context).size.width / 4,
                                                function: isApply
                                                    ? null
                                                    : () async {
                                                        focusNode.unfocus();
                                                        focusNode.canRequestFocus = false;
                                                        if (textEditingController.text != null && textEditingController.text.isNotEmpty) {
                                                          var _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
                                                          setState(() {
                                                            isApply = true;
                                                          });
                                                          await checkPromo(token: _userInfo.token, promoCode: textEditingController.text)
                                                              .then((value) {
                                                            if (value.Data is String) {
                                                              final snackBar = SnackBar(content: Text(value.Data));
                                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                              setState(() {
                                                                isApply = false;
                                                              });
                                                              return;
                                                            }
                                                            SinglePromoCode singlePromo = value.Data;
                                                            promoCode = singlePromo.data.promocode;
                                                            totalPrice = applyDiscount(
                                                                totalPrice, int.parse(singlePromo.data.discount.replaceAll("%", "")));
                                                            setState(() {});
                                                            final snackBar =
                                                                SnackBar(content: Text("Promo Code ${singlePromo.data.promocode} Applied"));
                                                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                          });
                                                        } else {
                                                          if (widget.data != null) {
                                                            isApply = true;
                                                            focusNode.unfocus();
                                                            focusNode.canRequestFocus = false;
                                                            totalPrice = applyDiscount(totalPrice, int.parse(widget.data.discount.replaceAll("%", "")));
                                                            Future.delayed(Duration(milliseconds: 250), () {
                                                              focusNode.canRequestFocus = true;
                                                            });
                                                            promoCode = widget.data.promocode;
                                                            setState(() {});
                                                          }
                                                        }
                                                        Future.delayed(Duration(milliseconds: 250), () {
                                                          focusNode.canRequestFocus = true;
                                                        });
                                                      },
                                                roundedBorder: 0,
                                                buttonColor: Color(0xFFb58563),
                                                widget: TextWidget(
                                                  text: AppLocalizations.of(context).apply,
                                                  textSize: 16,
                                                  textColor: grey,
                                                )),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(0),
                                              borderSide: BorderSide(
                                                color: primary,
                                                width: 1,
                                              ),
                                            ),
                                            focusedErrorBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(0),
                                              borderSide: BorderSide(
                                                color: primary,
                                                width: 1,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(0),
                                              borderSide: BorderSide(
                                                color: primary,
                                                width: 1,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(0),
                                              borderSide: BorderSide(
                                                color: primary,
                                                width: 1,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              DividerWidget(),
                              Padding(
                                padding: EdgeInsetsDirectional.only(start: 10, end: 10),
                                child: Row(
                                  children: [
                                    Image.asset('assets/images/update.png', scale: 1.5),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    TextWidget(
                                      text: AppLocalizations.of(context).updateShoppingCart,
                                      textSize: 15,
                                      textColor: primary.withOpacity(0.4),
                                    )
                                  ],
                                ),
                              ),
                              DividerWidget(),
                              Padding(
                                padding: EdgeInsetsDirectional.only(start: 20, end: 20),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/next.png',
                                      scale: 1.5,
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    TextWidget(
                                      text: AppLocalizations.of(context).continueShopping,
                                      textSize: 15,
                                      textColor: primary.withOpacity(0.4),
                                    )
                                  ],
                                ),
                              ),
                              DividerWidget(),
                              Padding(
                                padding: EdgeInsetsDirectional.only(start: 20, end: 20),
                                child: InkWell(
                                  onTap: () {
                                    _removeAllItems(cartId);
                                  },
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/remove.png',
                                        scale: 1.5,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      TextWidget(
                                        text: AppLocalizations.of(context).emptyShoppingCart,
                                        textSize: 15,
                                        textColor: primary.withOpacity(0.4),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      color: white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.only(start: 20, end: 20),
                            child: TextWidget(
                              text: AppLocalizations.of(context).priceDetails,
                              textColor: primary.withOpacity(0.4),
                              textSize: 18,
                            ),
                          ),
                          DividerWidget(),
                          Padding(
                            padding: const EdgeInsetsDirectional.only(start: 20, end: 20, bottom: 5, top: 5),
                            child: TextWidget(
                              text: AppLocalizations.of(context).subtotal,
                              textColor: primary.withOpacity(0.4),
                              textSize: 14,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.only(start: 20, end: 20, bottom: 5, top: 5),
                            child: TextWidget(
                              text: AppLocalizations.of(context).shippingAndHandling,
                              textColor: primary.withOpacity(0.4),
                              textSize: 14,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.only(start: 20, end: 20, bottom: 5, top: 5),
                            child: TextWidget(
                              text: AppLocalizations.of(context).tax,
                              textColor: primary.withOpacity(0.4),
                              textSize: 14,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.only(start: 20, end: 20, bottom: 5, top: 5),
                            child: TextWidget(
                              text: AppLocalizations.of(context).orderTotal,
                              textColor: primary.withOpacity(0.4),
                              textSize: 14,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      color: white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          DividerWidget(),
                          ListTile(
                            tileColor: Colors.white,
                            title: Container(
                              alignment: Alignment.topLeft,
                              // color: Colors.deepOrange,
                              child: TextWidget(
                                text: AppLocalizations.of(context).amountToBePaid,
                                textColor: primary.withOpacity(0.4),
                                textSize: 14,
                              ),
                            ),
                            trailing: InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed('/Checkout',
                                    arguments: RouteArguments(param1: _cartGetModel.cart, param2: true, param3: totalPrice, param4: promoCode, param5: _cartGetModel.cart.products.first.storeName));

                                /* Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) {
                                  return CheckOutScreen(
                                    cartData: _cartGetModel.cart,
                                    isLeft: true,
                                    price: totalPrice,
                                    promoCode: promoCode,
                                  );
                                }));*/
                              },
                              child: Container(
                                width: size.width * 0.35,
                                height: size.height * 0.07,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Color(0xFFb58563),
                                    border: Border.all(color: Color(0xFF707070))),
                                child: Center(
                                  child: TextWidget(
                                    text: AppLocalizations.of(context).proceed,
                                    textSize: 12,
                                    isBold: true,
                                    textColor: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            subtitle: Padding(
                              padding: EdgeInsetsDirectional.only(end: size.width * 0.35),
                              child: TextWidget(
                                text: '\$' + totalPrice.toStringAsFixed(2),
                                textColor: primary,
                                textSize: 14,
                                isBold: true,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  applyDiscount(double totalPrice, discountPercentage) {
    print("applyDiscount");
    print(totalPrice.toString() + " " + discountPercentage.toString());

    var percentage = discountPercentage / 100;
    var discountPrice = totalPrice * percentage;
    print(discountPrice.toString() + " " + (totalPrice - discountPrice).toString());
    return totalPrice - discountPrice;
  }
}

class CartModel {
  String image, pName, price, subTotal;
  int quantity;

  CartModel({this.image, this.price, this.quantity, this.subTotal, this.pName});
}
