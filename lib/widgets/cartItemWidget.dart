import 'package:category/modals/cartGetModel.dart';
import 'package:category/screens/cart.dart';
import 'package:category/utils/constant.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:category/widgets/dividerWidget.dart';
import 'package:category/widgets/textWidget.dart';
import 'package:flutter/material.dart';
import 'package:money_converter/Currency.dart';
import 'package:money_converter/money_converter.dart';

class CartItemWidget extends StatefulWidget {
  CartProduct data;

  CartItemWidget({this.data});

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {

  int quantity;

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return Container(
      width: MediaQuery.of(context).size.width,
      color: white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.only(start: 10, end: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 120,
                      width: 120,
                      child: Image.network(widget.data.imageUrl,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 1,),
                    Container(
                      color: Colors.white,
                      width: 80,
                      height: 35,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                            icon: Icon(Icons.arrow_drop_down),
                            isExpanded: true,
                            onChanged: (_value){
                              quantity = int.parse(_value);
                              setState(() {});
                            },
                            hint: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  quantity==null ? "Qty" : quantity.toString(),
                                )
                            ),
                            items: [
                              DropdownMenuItem<String>(
                                value: "1",
                                child: Center(
                                  child: Text("1"),
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: "2",
                                child: Center(
                                  child: Text("2"),
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: "3",
                                child: Center(
                                  child: Text("3"),
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: "4",
                                child: Center(
                                  child: Text("4"),
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: "5",
                                child: Center(
                                  child: Text("5"),
                                ),
                              )
                            ]),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextWidget(
                    textColor: primary,
                    textSize: 15,
                    text: widget.data.productName,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextWidget(
                    textColor: primary,
                    textSize: 16,
                    text: '${SharedPrefs().isCurrencyAvailable() ? SharedPrefs().currency : defaultCurrency} '+ widget.data.price.toString(),
                    isBold: true,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextWidget(
                    textColor: primary,
                    textSize: 16,
                    text: '${AppLocalizations.of(context).subtotal}\$ '+ widget.data.price.toString(),
                    isBold: true,
                  ),
                ],
              ),
              Spacer(),
              /*Padding(
                padding: EdgeInsetsDirectional.only(start: 10, end: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/edit.png',
                      scale: 1.5,
                    ),
                  ],
                ),
              )*/
            ],
          ),
        ],
      ),
    );
  }
}
