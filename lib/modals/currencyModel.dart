import 'package:flutter/cupertino.dart';

class CurrencyModel with ChangeNotifier{
  String currency;

  CurrencyModel({this.currency});

  changeCurrency(String currencyCode){
    this.currency = currencyCode;
    notifyListeners();
  }
}