import 'dart:convert';

import 'package:category/modals/promo_codes_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs{
  static SharedPreferences _sharedPrefs;

  factory SharedPrefs() => SharedPrefs._internal();

  SharedPrefs._internal();

  Future<void> init() async {
    _sharedPrefs ??= await SharedPreferences.getInstance();
  }

  String get creditCard => _sharedPrefs.getString('creditCard') ?? "";
  set creditCard(String value) {
    _sharedPrefs.setString('creditCard', value);
  }
  bool isCreditCardAvailable(){
    return _sharedPrefs.containsKey('creditCard');
  }

  set savePromoCode(PromoCodeItemsModel value) {
    _sharedPrefs.setString('promoCode', json.encode(value.toJson()));
  }
  PromoCodeItemsModel get savePromoCode => PromoCodeItemsModel.fromJson(json.decode(_sharedPrefs.get('promoCode')));
  bool isPromoCodeAvailable(){
    return _sharedPrefs.containsKey('promoCode');
  }

  String get token => _sharedPrefs.getString('token') ?? "";
  set token(String value) {
    _sharedPrefs.setString('token', value);
  }
  bool isTokenAvailable(){
    return _sharedPrefs.containsKey('token');
  }

  String get mainStoreId => _sharedPrefs.getString('mainStoreId') ?? "";
  set mainStoreId(String value) {
    _sharedPrefs.setString('mainStoreId', value);
  }
  bool isMainStoreIdAvailable(){
    return _sharedPrefs.containsKey('mainStoreId');
  }

  bool get createdMainStore => _sharedPrefs.getBool('createdMainStore') ?? false;
  set createdMainStore(bool value)  {
     _sharedPrefs.setBool('createdMainStore', value);
  }
  bool isCreatedMainStoreAvailable(){
    return _sharedPrefs.containsKey('createdMainStore');
  }

  bool get mainStoreStatus => _sharedPrefs.getBool('mainStoreStatus') ?? false;
  set mainStoreStatus(bool value)  {
    _sharedPrefs.setBool('mainStoreStatus', value);
  }
  bool mainStoreStatusAvailable(){
    return _sharedPrefs.containsKey('mainStoreStatus');
  }

  String get locale => _sharedPrefs.getString('locale') ?? "ar";
  set locale(String value)  {
    _sharedPrefs.setString('locale', value);
  }
  bool isLocaleAvailable(){
    return _sharedPrefs.containsKey('locale');
  }

  String get userRole => _sharedPrefs.getString('userRole') ?? "";
  set userRole(String value) {
    _sharedPrefs.setString('userRole', value);
  }
  bool isUserRoleAvailable(){
    return _sharedPrefs.containsKey('userRole');
  }

  String get currency => _sharedPrefs.getString('currency') ?? "";
  set currency(String value) {
    _sharedPrefs.setString('currency', value);
  }
  bool isCurrencyAvailable(){
    return _sharedPrefs.containsKey('currency');
  }

  clear()async{
    await _sharedPrefs.clear();
  }
}