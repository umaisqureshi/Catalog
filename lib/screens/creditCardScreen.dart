import 'dart:convert';

import 'package:category/utils/constant.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';

import 'dashboard1/widgets/textWidget.dart';

class CreditCardScreen extends StatefulWidget {

  CardType cardType;

  CreditCardScreen({this.cardType});

  @override
  _CreditCardScreenState createState() => _CreditCardScreenState();
}

class _CreditCardScreenState extends State<CreditCardScreen> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Card Details",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFFb58563)),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            CreditCardWidget(
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
              cardType: widget.cardType,
              obscureCardNumber: true,
              obscureCardCvv: true,
              cardBgColor: Colors.brown[200],
              textStyle: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w600),
              /*isHolderNameVisible: true,
              onCreditCardWidgetChange: (creditCardBrand) {},*/
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    CreditCardForm(
                      formKey: formKey,
                      obscureCvv: true,
                      obscureNumber: true,
                      cardNumber: cardNumber,
                      cvvCode: cvvCode,
                      cardHolderName: cardHolderName,
                      expiryDate: expiryDate,
                      themeColor: brown,
                      cardNumberDecoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Number',
                        hintText: 'XXXX XXXX XXXX XXXX',
                        hintStyle: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.normal),
                      ),
                      expiryDateDecoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Expired Date',
                        hintText: 'XX/XX',
                        hintStyle: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.normal),
                      ),
                      cvvCodeDecoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'CVV',
                        hintText: 'XXX',
                        hintStyle: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.normal),
                      ),
                      cardHolderDecoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Card Holder',
                        hintStyle: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.normal),
                      ),
                      onCreditCardModelChange: onCreditCardModelChange,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(
                          start: MediaQuery.of(context).size.width * 0.06, end: MediaQuery.of(context).size.width * 0.06),
                      child: InkWell(
                        onTap: (){
                          if (formKey.currentState.validate()) {
                            CreditCardModel creditCardModel = CreditCardModel(cardNumber, expiryDate, cardHolderName, cvvCode, isCvvFocused);
                            SharedPrefs().creditCard = json.encode(creditCardModel.toJson());
                            Navigator.pop(context, creditCardModel);
                            print('valid!');
                          } else {
                            print('invalid!');
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.07,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: brown),
                          child: Center(
                            child: TextWidget(
                              text: "Validate",
                              textColor: Colors.white,
                              textSize: 15,
                              isBold: true,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
