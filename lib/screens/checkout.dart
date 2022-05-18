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
import 'package:category/widgets/myRadioList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'creditCardScreen.dart';
import 'dashboard1/widgets/textWidget.dart';

class CheckOutScreen extends StatefulWidget {

  RouteArguments routeArguments;
  //CartProduct cartData;
  CheckOutScreen({this.routeArguments});
  /*Cart cartData;
  bool isLeft;
  double price;
  String promoCode;

  CheckOutScreen({this.cartData, this.isLeft, this.price, this.promoCode});*/

  @override
  _CheckOutScreenState createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  int selectedRadio = 1;
  CreditCardModel creditCardModel;
  bool paymentMethod = false;

  Color rightColors, leftColors, rightIconColor, leftIconColor;

  PageController pageController = PageController();

  TextEditingController custStoreName = TextEditingController();
  TextEditingController custShippingAdress = TextEditingController();
  TextEditingController custPhoneNumber = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<CardModel> cardsList = [
    CardModel(image: "assets/images/visa.png", cardName: "Visa"),
    CardModel(
        image: "assets/images/americanExpress.png",
        cardName: "American Express"),
    CardModel(image: "assets/images/mastercard.png", cardName: "Credit Card"),
  ];

  ApiResponse _apiResponse = ApiResponse();

  Welcome _userInfo;

  showInSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _handlePlaceOrder({String cardType}) async {
    _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));

    /*if(paymentMethod == true){
      _apiResponse = await placeOrder(
        token: _userInfo.token,
        status: "Completed",
        address: custShippingAdress.text,
        customerId: widget.cartData.customerId,
        paymentStatus: true,
        paymentType: cardType,
        phone: custPhoneNumber.text,
        cartItems: widget.cartData,
        uName: _userInfo.userData.username,
      );
      print("Payment Status %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% $paymentMethod");
    }else{*/
    _apiResponse = await placeOrder(
      token: _userInfo.token,
      status: "Pending",
      address: custShippingAdress.text,
      customerId: widget.routeArguments.param1.customerId,
      paymentStatus: false,
      paymentType: cardType,
      phone: custPhoneNumber.text,
      cartItems: widget.routeArguments.param1,
      uName: _userInfo.userData.username,
      storeName: widget.routeArguments.param5
      //storeId: widget.cartData.storeId

    );
    print(
        "Payment Status %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% $paymentMethod");
    // }

    // _apiResponse = await placeOrder(
    //   token: _userInfo.token,
    //   status: "Completed",
    //   address: custShippingAdress.text,
    //   customerId: widget.cartData.customerId,
    //   paymentStatus: false,
    //   paymentType: cardType,
    //   phone: custPhoneNumber.text,
    //   cartItems: widget.cartData,
    //   uName: _userInfo.userData.username,
    // );
    if ((_apiResponse.ApiError as ApiError) == null) {
      showInSnackBar("Order has placed successfully");
      if(widget.routeArguments.param4!=null) {
        await applyPromo(token: _userInfo.token, promoCode: widget.routeArguments.param4);
       SharedPreferences preferences =  await SharedPreferences.getInstance();
       preferences.remove('promoCode');
      }
      setState(() {});
      Navigator.pop(context);
    } else {
      showInSnackBar((_apiResponse.ApiError as ApiError).error);
    }
  }

  @override
  void initState() {
    if (mounted) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
        creditCardModel = SharedPrefs().isCreditCardAvailable()
            ? creditCardModel =
                CreditCardModel.fromJson(json.decode(SharedPrefs().creditCard))
            : null;
        setState((){});
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Checkout",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFFb58563)),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      height: med.height * 0.06,
                      width: med.width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.brown[50],
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    Positioned(
                      left: 4,
                      top: 4,
                      bottom: 4,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            leftColors = Color(0xFFb58563);
                            widget.routeArguments.param2 = true;
                            rightColors = Colors.white;
                            rightIconColor = Colors.black12;
                            leftIconColor = Colors.white;
                            paymentMethod = false;
                          });
                          pageController.animateToPage(0,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.fastLinearToSlowEaseIn);
                        },
                        child: Container(
                          width: med.width * 0.39,
                          height: med.height * 0.05,
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: widget.routeArguments.param2
                                ? Color(0xFFb58563)
                                : Colors.brown[50] ?? Color(0xFFb58563),
                          ),
                          child: Center(
                            child: Container(
                              child: Text("Cash on delivery", style: TextStyle(color: widget.routeArguments.param2 ? Colors.white : Colors.black87),),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 4,
                      top: 4,
                      bottom: 4,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            rightColors = Color(0xFFb58563);
                            rightIconColor = Colors.white;
                            leftIconColor = Colors.black12;
                            leftColors = Colors.white;
                            widget.routeArguments.param2 = false;
                            paymentMethod = true;
                          });
                          pageController.animateToPage(1,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.fastLinearToSlowEaseIn);
                        },
                        child: Container(
                          width: med.width * 0.39,
                          height: med.height * 0.05,
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: widget.routeArguments.param2
                                ? Colors.brown[50]
                                : Color(0xFFb58563) ?? Color(0xFFb58563),
                          ),
                          child: Center(
                            child: Container(
                              child: Text("Online Payment", style: TextStyle(color: widget.routeArguments.param2 ? Colors.black87 : Colors.white),),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Toogle switch
              // StatefulBuilder(builder: (BuildContext context, StateSetter setState){
              //   return Column(
              //     children: <Widget>[
              //       Center(
              //         child: Container(
              //           height: med.height*0.055,
              //           width: med.width*0.85,
              //           decoration: BoxDecoration(
              //             color: Colors.brown[50],
              //             borderRadius: BorderRadius.circular(25),
              //           ),
              //           child: Center(
              //             child: ToggleSwitch(
              //               minWidth: med.width*0.41,
              //               minHeight: med.height*0.04,
              //               cornerRadius: 20.0,
              //               activeBgColors: [[Color(0xFFb58563)], [Color(0xFFb58563)]],
              //               activeFgColor: Colors.white,
              //               inactiveBgColor: Colors.brown[50],
              //               inactiveFgColor: Colors.brown,
              //               initialLabelIndex: 1,
              //               totalSwitches: 2,
              //               labels: ['Cash on delivery', 'Online payment'],
              //               radiusStyle: true,
              //               onToggle: (index) {
              //                 print('switched to: $index');
              //                 if(index == 0){
              //                   paymentMethod = false;
              //                   print("paymentMethod ooooooooooooooooooooooooooooooooooooooo $paymentMethod");
              //                 }else{
              //                   paymentMethod = true;
              //                   print("paymentMethod ooooooooooooooooooooooooooooooooooooooo $paymentMethod");
              //                 }
              //               },
              //             ),
              //           ),
              //         ),
              //       ),
              //     ],
              //   );
              // }),

              Padding(
                padding: const EdgeInsetsDirectional.only(start: 15, end: 10),
                child: Text(
                  "Payment",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 20,
              ),

              paymentMethod == false
                  ? Container(
                      child: Column(
                        children: <Widget>[
                          Center(
                            child: Container(
                              child: Text(
                                "Cash on delivery",
                                style: TextStyle(
                                  color: Colors.brown,
                                  fontSize: 28,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      child: Center(
                        child: Text(
                          'Coming Soon...',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 28,
                          ),
                        ),
                      ),
                      /*Column(
                  children: <Widget>[
                    MyRadioListTile<int>(
                      value: 1,
                      groupValue: selectedRadio,
                      leading: cardsList[0].image,
                      title: Text(
                        cardsList[0].cardName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black),
                      ),
                      onChanged: (value) async {
                        SharedPrefs().isCreditCardAvailable()
                            ? creditCardModel = CreditCardModel.fromJson(
                            json.decode(SharedPrefs().creditCard))
                            : creditCardModel = await Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return CreditCardScreen(
                                cardType: CardType.visa,
                              );
                            }));
                        setState(() {
                          selectedRadio = value;
                        });
                      },
                    ),
                    MyRadioListTile<int>(
                      value: 2,
                      groupValue: selectedRadio,
                      leading: cardsList[1].image,
                      title: Text(
                        cardsList[1].cardName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black),
                      ),
                      onChanged: (value) async {
                        SharedPrefs().isCreditCardAvailable()
                            ? creditCardModel = CreditCardModel.fromJson(
                            json.decode(SharedPrefs().creditCard))
                            : creditCardModel = await Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return CreditCardScreen(
                                cardType: CardType.americanExpress,
                              );
                            }));
                        setState(() {
                          selectedRadio = value;
                        });
                      },
                    ),
                    MyRadioListTile<int>(
                      value: 3,
                      groupValue: selectedRadio,
                      leading: cardsList[2].image,
                      title: Text(
                        cardsList[2].cardName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black),
                      ),
                      onChanged: (value) async {
                        SharedPrefs().isCreditCardAvailable()
                            ? creditCardModel = CreditCardModel.fromJson(
                            json.decode(SharedPrefs().creditCard))
                            : creditCardModel = await Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return CreditCardScreen(
                                cardType: CardType.mastercard,
                              );
                            }));
                        setState(() {
                          selectedRadio = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.brown[200],
                      ),
                      margin: EdgeInsetsDirectional.only(start: 16, end: 16),
                      padding: EdgeInsetsDirectional.all(12.0),
                      height: med.height * 0.12,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Name On Card",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                creditCardModel != null
                                    ? creditCardModel.cardNumber
                                    : "****8900",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                creditCardModel != null
                                    ? creditCardModel.cardHolderName
                                    : "Elenora Pena",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              Image.asset(
                                cardsList[selectedRadio - 1].image,
                                width: 50,
                                height: 50,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),*/
                    ),

              /*MyRadioListTile<int>(
                value: 1,
                groupValue: selectedRadio,
                leading: cardsList[0].image,
                title: Text(
                  cardsList[0].cardName,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black),
                ),
                onChanged: (value) async {
                  SharedPrefs().isCreditCardAvailable()
                      ? creditCardModel = CreditCardModel.fromJson(
                          json.decode(SharedPrefs().creditCard))
                      : creditCardModel = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                          return CreditCardScreen(
                            cardType: CardType.visa,
                          );
                        }));
                  setState(() {
                    selectedRadio = value;
                  });
                },
              ),
              MyRadioListTile<int>(
                value: 2,
                groupValue: selectedRadio,
                leading: cardsList[1].image,
                title: Text(
                  cardsList[1].cardName,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black),
                ),
                onChanged: (value) async {
                  SharedPrefs().isCreditCardAvailable()
                      ? creditCardModel = CreditCardModel.fromJson(
                          json.decode(SharedPrefs().creditCard))
                      : creditCardModel = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                          return CreditCardScreen(
                            cardType: CardType.americanExpress,
                          );
                        }));
                  setState(() {
                    selectedRadio = value;
                  });
                },
              ),
              MyRadioListTile<int>(
                value: 3,
                groupValue: selectedRadio,
                leading: cardsList[2].image,
                title: Text(
                  cardsList[2].cardName,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black),
                ),
                onChanged: (value) async {
                  SharedPrefs().isCreditCardAvailable()
                      ? creditCardModel = CreditCardModel.fromJson(
                          json.decode(SharedPrefs().creditCard))
                      : creditCardModel = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                          return CreditCardScreen(
                            cardType: CardType.mastercard,
                          );
                        }));
                  setState(() {
                    selectedRadio = value;
                  });
                },
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.brown[200],
                ),
                margin: EdgeInsetsDirectional.only(start: 16, end: 16),
                padding: EdgeInsetsDirectional.all(12.0),
                height: med.height * 0.12,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Name On Card",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w400),
                        ),
                        Text(
                          creditCardModel != null
                              ? creditCardModel.cardNumber
                              : "****8900",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          creditCardModel != null
                              ? creditCardModel.cardHolderName
                              : "Elenora Pena",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        Image.asset(
                          cardsList[selectedRadio - 1].image,
                          width: 50,
                          height: 50,
                        ),
                      ],
                    )
                  ],
                ),
              ),*/

              Container(
                margin: EdgeInsetsDirectional.only(start: 15, end: 15, top: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Shipping Information",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                          start: 8.0, end: 8.0, top: 15.0),
                      child: TextFormField(
                        controller: custStoreName,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "* Required";
                          } else if (custStoreName.text.length < 3) {
                            return "name should be more than 3";
                          } else {
                            return null;
                          }
                        },
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: "Enter Your Name",
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 13),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1)),
                        ),
                      ),
                      //Text("Eleanora Pena", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13, color: Colors.grey),),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                          start: 8.0, end: 8.0, top: 8.0),
                      child: TextFormField(
                        controller: custShippingAdress,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "* Required";
                          } else if (custShippingAdress.text.length < 7 ||
                              custPhoneNumber.text.length > 30) {
                            return "invalid number";
                          } else {
                            return null;
                          }
                        },
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: "Enter Shipping Address",
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 13),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1)),
                        ),
                      ),
                      //Text("Street: 18 Sun City, New York", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13, color: Colors.grey),),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                          start: 8.0, end: 8.0, top: 8.0),
                      child: TextFormField(
                        controller: custPhoneNumber,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "* Required";
                          } else if (custPhoneNumber.text.length < 10 ||
                              custPhoneNumber.text.length > 10) {
                            return "invalid number";
                          } else {
                            return null;
                          }
                        },
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: "Enter Your Phone Number",
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 13),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1)),
                        ),
                      ),
                      //Text("1-800-908-98-98", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13, color: Colors.grey),),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                          start: 10.0, top: 15, end: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "\$${widget.routeArguments.param3}",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: EdgeInsetsDirectional.only(
                    start: MediaQuery.of(context).size.width * 0.06,
                    end: MediaQuery.of(context).size.width * 0.06),
                child: InkWell(
                  onTap: () {
                    if (_formKey.currentState.validate()) {
                      if (selectedRadio == 0) {
                        widget.routeArguments.param1.products.forEach((element) {
                          element.sold = element.sold + 1;
                        });
                        _handlePlaceOrder(cardType: CardType.visa.toString());
                      } else if (selectedRadio == 1) {
                        widget.routeArguments.param1.products.forEach((element) {
                          element.sold = element.sold + 1;
                        });
                        _handlePlaceOrder(
                            cardType: CardType.americanExpress.toString(),
                        );
                      } else {
                        widget.routeArguments.param1.products.forEach((element) {
                          element.sold = element.sold + 1;
                        });
                        _handlePlaceOrder(
                            cardType: CardType.mastercard.toString());
                      }

                    } else {
                      showInSnackBar("Fill all the information");
                    }
                    // _handlePlaceOrder(cardType: creditCardModel.brand);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.07,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10), color: brown),
                    child: Center(
                      child: TextWidget(
                        text: "Checkout",
                        textColor: Colors.white,
                        textSize: 15,
                        isBold: true,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardModel {
  String image;
  String cardName;

  CardModel({this.image, this.cardName});
}
