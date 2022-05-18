import 'dart:convert';
import 'dart:io';
import 'package:category/modals/SinglePromoCode.dart';
import 'package:category/modals/apiError.dart';
import 'package:category/modals/apiResponse.dart';
import 'package:category/modals/banner_ads_model.dart';
import 'package:category/modals/cartGetModel.dart';
import 'package:category/modals/cart_all_items_remove_model.dart';
import 'package:category/modals/cart_remove_item.dart';
import 'package:category/modals/categoryModel.dart';
import 'package:category/modals/check_already_like.dart';
import 'package:category/modals/discountModel.dart';
import 'package:category/modals/get_all_stores.dart';
import 'package:category/modals/get_fav_things.dart';
import 'package:category/modals/mainStoreModal.dart';
import 'package:category/modals/new_get_all_fav_model.dart';
import 'package:category/modals/popularStoreModel.dart';
import 'package:category/modals/productsByStoresModal.dart';
import 'package:category/modals/promo_codes_model.dart';
import 'package:category/modals/revenue_model.dart';
import 'package:category/modals/sale_by_month_model.dart';
import 'package:category/modals/storeByCategory.dart';
import 'package:category/modals/store_views.dart';
import 'package:category/modals/store_vise_disco_model.dart';
import 'package:category/modals/subStoreModel.dart';
import 'package:category/modals/totalSalesModel.dart';
import 'package:category/utils/constant.dart';
import 'package:category/utils/exceptions.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;

Future<ApiResponse> getMainStore({@required String token}) async {
  Dio dio = Dio();
  ApiResponse _apiResponse = ApiResponse();

  String url = "$BASE_URL/api/store";

  try {
    final response = await dio.get(url,
        options: Options(
            headers: {HttpHeaders.authorizationHeader: 'Bearer $token'}));
    print("Status Code :::::::::::::::::::::::: ${response.statusCode}");
    switch (response.statusCode) {
      case HttpStatus.ok:
        _apiResponse.Data = MainStore.fromJson(response.data);
        break;
      default:
        _apiResponse.ApiError = response.data;
    }
  } catch (e) {
    print("Exception here :::::::::::::::::: ${e.toString()}");
    final errorMessage = DioException.fromDioError(e);
    _apiResponse.ApiError = ApiError(error: errorMessage.message);
  }
  return _apiResponse;
}

Future<ApiResponse> getSubStore({@required String token, @required String subStore_id}) async {
  Dio dio = Dio();
  ApiResponse _apiResponse = ApiResponse();

  String url = "$BASE_URL/api/subStore/$subStore_id";

  try {
    final response = await dio.get(url,
        options: Options(
            headers: {HttpHeaders.authorizationHeader: 'Bearer $token'}));
    switch (response.statusCode) {
      case HttpStatus.ok:
        _apiResponse.Data = MainStore.fromJson(response.data);
        break;
      default:
        _apiResponse.ApiError = response.data;
    }
  } catch (e) {
    final errorMessage = DioException.fromDioError(e);
    _apiResponse.ApiError = ApiError(error: errorMessage.message);
  }
  return _apiResponse;
}

Future<ApiResponse> addProducts(
    {String name,
    String desc,
    String price,
    String stock,
    String category,
    String filter,
    String token,
    String size,
    int color,
    String weight,
      String storeId,

    List<File> images}) async {
  Dio dio = Dio();

  ApiResponse _apiResponse = ApiResponse();

  String url = "${BASE_URL}/api/product";

/*  String fileName = images[0].path.split('/').last;
  String imageType = fileName.split('.').last;*/

  List<MultipartFile> _imagesFiles = [];
  for (int i = 0; i < images.length; i++) {
    String fileName = images[i].path.split('/').last;
    String imageType = fileName.split('.').last;
    print("FileName ::::::: $fileName");
    print("FileType ::::::: $imageType");
    print("FilePath ::::::: ${images[i].path}");
    _imagesFiles.add(await MultipartFile.fromFile(images[i].path,
        filename: fileName, contentType: MediaType("image", imageType)));
  }

  FormData data = FormData.fromMap({
    "image": _imagesFiles,
    "product_name": name,
    "product_category": category,
    "product_filters": filter,
    "product_description": desc,
    "price": price,
    "stock": stock,
    "store_id": storeId,
    "size": size,
    "color": color,
    "weight": weight,
  });

  try {
    final response = await dio.post(url,
        data: data,
        options: Options(
            headers: {HttpHeaders.authorizationHeader: "Bearer $token"}));

    switch (response.statusCode) {
      case (HttpStatus.created):
        _apiResponse.Data = response.data;
        break;
      default:
        _apiResponse.ApiError = response.data;
    }
  } catch (e) {
    //final errorMessage = DioException.fromDioError(e);
    print("ERROR ADD PRODUCT :::::::::::::::::::::::::::::::::::::::: ${e.toString()}");
    _apiResponse.ApiError = ApiError(error: e.toString());
  }
  return _apiResponse;
}

Future<ApiResponse> destroyProduct({String productId, String token}) async {
  Dio dio = Dio();
  ApiResponse _apiResponse = ApiResponse();
  String url = "${BASE_URL}/api/destroy-product/$productId";

  try {
    final response = await dio.get(url,
        options: Options(
            headers: {HttpHeaders.authorizationHeader: "Bearer $token"}));
    switch (response.statusCode) {
      case HttpStatus.accepted:
        _apiResponse.Data = response.data;
        break;
      default:
        _apiResponse.ApiError = response.data;
    }
  } catch (e) {
    final errorMessage = DioException.fromDioError(e);
    print("ERROR ::::::::::::::: ${errorMessage.message}");
    _apiResponse.ApiError = ApiError(error: errorMessage.message);
  }

  return _apiResponse;
}

Future<ApiResponse> editProducts(
    {String id,
    String name,
    String desc,
    String price,
    String stock,
    String category,
    String filter,
    String token,
      String size,
      String weight,
      int color,
    List<File> images}) async {
  Dio dio = Dio();

  ApiResponse _apiResponse = ApiResponse();

  String url = "${BASE_URL}/api/edit-product/$id";

  List<MultipartFile> _imagesFiles = [];
  for (int i = 0; i < images.length; i++) {
    String fileName = images[i].path.split('/').last;
    String imageType = fileName.split('.').last;
    print("FileName ::::::: $fileName");
    print("FileType ::::::: $imageType");
    print("FilePath ::::::: ${images[i].path}");
    _imagesFiles.add(await MultipartFile.fromFile(images[i].path,
        filename: fileName, contentType: MediaType("image", imageType)));
  }

  FormData data = FormData.fromMap({
    "image": _imagesFiles,
    "product_name": name,
    "product_category": category,
    "filters": filter,
    "product_description": desc,
    "price": price,
    "stock": stock,
    "color": color,
    "weight": weight,
    "size": size
  });

  try {
    final response = await dio.post(url,
        data: data,
        options: Options(
            headers: {HttpHeaders.authorizationHeader: "Bearer $token"}));

    switch (response.statusCode) {
      case (HttpStatus.accepted):
        _apiResponse.Data = response.data;
        break;
      default:
        _apiResponse.ApiError = response.data;
    }
  } catch (e) {
    //final errorMessage = DioException.fromDioError(e);
    print("ERROR :::::::::::::::::::::: $e}");
    _apiResponse.ApiError = ApiError(error: e.toString());
  }
  return _apiResponse;
}

Future<ApiResponse> getCategories({@required String token}) async {
  Dio dio = Dio();
  ApiResponse _apiResponse = ApiResponse();

  String url = "$BASE_URL/api/category";

  try {
    final response = await dio.get(url,
        options: Options(
            headers: {HttpHeaders.authorizationHeader: 'Bearer $token'}));
    switch (response.statusCode) {
      case HttpStatus.ok:
        _apiResponse.Data = GetCategoryList.fromJson(response.data);
        break;
      default:
        _apiResponse.ApiError = response.data;
    }
  } catch (e) {
    final errorMessage = e is DioError?DioException.fromDioError(e).message:e.toString();
    _apiResponse.ApiError = ApiError(error: errorMessage);
  }
  return _apiResponse;
}

Future<ApiResponse> getStoresByCategory({String category, String gender}) async {
  Dio dio = Dio();
  ApiResponse _apiResponse = ApiResponse();

  String url = "$BASE_URL/api/cbs";
  dynamic data;

 /* if(gender == "Male" || gender == "Female"){
    data = {'category': category, 'gender': gender.toLowerCase()};
  }else{

  }*/

  data = {'category': category};
  try {
    final response = await dio.get(
      url,
      options:
          Options(headers: {HttpHeaders.contentTypeHeader: 'application/json'}),
      queryParameters: data,
    );
    switch (response.statusCode) {
      case HttpStatus.ok:
        _apiResponse.Data = StoreByCategory.fromJson(response.data);
        break;
      default:
        _apiResponse.ApiError = response.data;
    }
  } catch (e) {
    //final errorMessage = DioException.fromDioError(e);
    print("CBS ERROR :::::::::::::::::::::: ${e.toString()}");
    _apiResponse.ApiError = ApiError(error: e.toString());
  }
  return _apiResponse;
}

Future<ApiResponse> getProductsByStores({String storeId, int page, String limit}) async {
  Dio dio = Dio();

  ApiResponse _apiResponse = ApiResponse();

  String url = "$BASE_URL/api/storebyproducts";

  dynamic data = {'store_id': storeId, 'page' : page.toString(), 'limit': limit};
  print(storeId);

  try {
    final response = await dio.get(
      url,
      options:
      Options(headers: {HttpHeaders.contentTypeHeader: 'application/json'}),
      queryParameters: data,
    );
    switch (response.statusCode) {
      case HttpStatus.ok:
        _apiResponse.Data = ProductsByStore.fromJson(response.data);
        break;
      default:
        _apiResponse.ApiError = response.data;
    }
  } catch (e) {
    //final errorMessage = DioException.fromDioError(e);
    print("SBP ERROR :::::::::::::::::::::: ${e.toString()}");
    _apiResponse.ApiError = ApiError(error: e.toString());
  }
  return _apiResponse;
}

Future<ApiResponse> getSubStores({@required String token, @required String mainStoreId}) async {
  Dio dio = Dio();
  ApiResponse _apiResponse = ApiResponse();

  String url = "$BASE_URL/api/sbss/$mainStoreId";

  try {
    final response = await dio.get(url,
        options: Options(
            headers: {HttpHeaders.authorizationHeader: 'Bearer $token'}));
    switch (response.statusCode) {
      case HttpStatus.ok:
        _apiResponse.Data = SubStoreModel.fromJson(response.data);
        break;
      default:
        _apiResponse.ApiError = response.data;
    }
  } catch (e) {
    final errorMessage = DioException.fromDioError(e);
    _apiResponse.ApiError = ApiError(error: errorMessage.message);
  }
  return _apiResponse;
}

Future<ApiResponse> createDiscount({String token, File discountImage, String discount, String storeId, String prodId, String endingDate, String prodName})async{
  Dio dio = Dio();

  ApiResponse _apiResponse = ApiResponse();

  String url = "${BASE_URL}/api/discount";

  String fileName = discountImage.path.split('/').last;
  String imageType = fileName.split('.').last;

/*  List<MultipartFile> _imagesFiles = [];
  for (int i = 0; i < images.length; i++) {
    String fileName = images[i].path.split('/').last;
    String imageType = fileName.split('.').last;
    print("FileName ::::::: $fileName");
    print("FileType ::::::: $imageType");
    print("FilePath ::::::: ${images[i].path}");
    _imagesFiles.add(await MultipartFile.fromFile(images[i].path,
        filename: fileName, contentType: MediaType("image", imageType)));
  }*/

  FormData data = FormData.fromMap({
    "discount_img": await MultipartFile.fromFile(discountImage.path,
        filename: fileName, contentType: MediaType("image", imageType)),
    "discount": discount,
    "ending_date": endingDate,
    "store_id": storeId,
    "product_id": prodId,
    "product_name":prodName
  });

  try {
    final response = await dio.post(url,
        data: data,
        options: Options(
            headers: {HttpHeaders.authorizationHeader: "Bearer $token"}));

    switch (response.statusCode) {
      case (HttpStatus.created):
        _apiResponse.Data = response.data;
        break;
      default:
        _apiResponse.ApiError = response.data;
    }
  } catch (e) {
    final errorMessage = DioException.fromDioError(e);
    print("ERROR POSTING DISCOUNT :::::::::::::::::::::::::::::::::::::::: ${e.toString()}");
    _apiResponse.ApiError = ApiError(error: errorMessage.toString());
  }
  return _apiResponse;
}

Future<ApiResponse> addProductToCart({String token,int sold, String storeId,String customerId, String productId, String productPrice, String pImageUrl, String pName, String storeName}) async {
  ApiResponse _apiResponse = new ApiResponse();
  var dio = Dio();

  try {
    // var loginUri = Uri.parse("$BASE_URL/api/login");
    String url = "$BASE_URL/api/cart";

    dynamic body = {
      "customerId": customerId,
      "product": {
        "id": productId,
        "price": productPrice,
        "imageUrl": pImageUrl,
        "productName": pName,
        "sold": sold,
        "store_id": storeId,
        "store_name": storeName,
      }
    };

    final response = await dio.post(url,
        data: body,
        options: Options(
            headers: {HttpHeaders.authorizationHeader: 'Bearer $token'}));

    switch (response.statusCode) {
      case HttpStatus.ok:
        _apiResponse.Data = response.data;
        break;
      default:
        _apiResponse.ApiError = ApiError(error: response.data);
        break;
    }
  } catch (e) {
    final errorMessage = DioException.fromDioError(e);
    _apiResponse.ApiError = ApiError(error: errorMessage.message);
  }
  return _apiResponse;
}

Future<ApiResponse> checkPromo({String token, String promoCode}) async {
  ApiResponse _apiResponse = new ApiResponse();
  var dio = Dio();

  try {
    String url = "$BASE_URL/api/applypromo";

    final response = await dio.get("$url?promo=$promoCode",
        options: Options(
            headers: {HttpHeaders.authorizationHeader: 'Bearer $token'}));

    print("status code??????????????????????????????????????????? ${response.statusCode}");
    print("Data ??????????????????????????????????????????? ${response.data}");

    switch (response.statusCode) {
      case HttpStatus.ok:
        _apiResponse.Data = response.data['data'] is String?response.data['data']:singlePromoCodeFromJson(response.data);
        break;
      default:
        _apiResponse.ApiError = ApiError(error: response.data);
        break;
    }
  } catch (e) {
    print("Exception error????????????????????????????????? ${e.toString()}");
    /*final errorMessage = DioException.fromDioError(e);
    _apiResponse.ApiError = ApiError(error: errorMessage.message);*/
  }
  return _apiResponse;
}

Future<ApiResponse> applyPromo({String token, String promoCode}) async {
  ApiResponse _apiResponse = new ApiResponse();
  var dio = Dio();

  try {
    String url = "$BASE_URL/api/applypromo";

    final response = await dio.put("$url?promo=$promoCode",
        options: Options(
            headers: {HttpHeaders.authorizationHeader: 'Bearer $token'}));

    print("status code??????????????????????????????????????????? ${response.statusCode}");
    print("Data ??????????????????????????????????????????? ${response.data}");

    switch (response.statusCode) {
      case HttpStatus.ok:
        _apiResponse.Data = response.data['message'];
        break;
      default:
        _apiResponse.ApiError = ApiError(error: response.data);
        break;
    }
  } catch (e) {
    print("Exception error????????????????????????????????? ${e.toString()}");
    /*final errorMessage = DioException.fromDioError(e);
    _apiResponse.ApiError = ApiError(error: errorMessage.message);*/
  }
  return _apiResponse;
}

Future<ApiResponse> getCartProduct({String token, String customerId, String productId, String productPrice, String pImageUrl, String pName}) async {
  ApiResponse _apiResponse = new ApiResponse();
  var dio = Dio();

  try {
    // var loginUri = Uri.parse("$BASE_URL/api/login");
    String url = "$BASE_URL/api/cart";

    final response = await dio.get(url,
        options: Options(
            headers: {HttpHeaders.authorizationHeader: 'Bearer $token'}));

    print("status code??????????????????????????????????????????? ${response.statusCode}");
    print("Data ??????????????????????????????????????????? ${response.data}");

    switch (response.statusCode) {
      case HttpStatus.ok:
        _apiResponse.Data = CartGetModel.fromJson(response.data);
        break;
      default:
        _apiResponse.ApiError = ApiError(error: response.data);
        break;
    }
  } catch (e) {
    print("Exception error????????????????????????????????? ${e.toString()}");
    /*final errorMessage = DioException.fromDioError(e);
    _apiResponse.ApiError = ApiError(error: errorMessage.message);*/
  }
  return _apiResponse;
}

// Place order
Future<ApiResponse> placeOrder({
  String token,
  String customerId,
  String phone,
  String address,
  String paymentType,
  bool paymentStatus,
  String status,
  String uName,
  Cart cartItems,
  String storeName,
  //String storeId,
}) async {
  ApiResponse _apiResponse = new ApiResponse();
  var dio = Dio();

  List<CartProduct> items = cartItems.products;
  List<Map<String, dynamic>> itemsMap = [];

  items.forEach((element) {
    element.time = DateTime.now().millisecondsSinceEpoch;
    // element.time = DateTime.now();
    print("DATE AND TIME %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ${element.time}");
  });

  items.forEach((element) {
    itemsMap.add(element.toJson());
    print("Products : ${element.toJson().toString()}");
  });
  print(itemsMap.toString());

  try {
    String url = "$BASE_URL/api/order";

    print("\nITEM MAP //////////////////////////////////////////////////////////////////// $items");
    print("\nPHONE //////////////////////////////////////////////////////////////////// $phone");
    print("\nADDRESS //////////////////////////////////////////////////////////////////// $address");
    print("\npayment Type //////////////////////////////////////////////////////////////////// $paymentType");
    print("\nPAYMENT STATUS //////////////////////////////////////////////////////////////////// $paymentStatus");
    print("\nSTATUS //////////////////////////////////////////////////////////////////// $status");
    print("\nSTATUS //////////////////////////////////////////////////////////////////// $uName");
    //print("\nStoreId //////////////////////////////////////////////////////////////////// $storeId");


    dynamic body = {
      "items":items,
      //'customerId': customerId,
      "phone": phone,
      "address": address,
      "paymentType": paymentType,
      "paymentStatus": paymentStatus,
      "status": status,
      "userName": uName,
      //"storeName": storeName
    };

    final response = await dio.post(url,
        data: body,
        options: Options(
            headers: {HttpHeaders.authorizationHeader: 'Bearer $token'}));

    switch (response.statusCode) {
      case HttpStatus.ok:
        _apiResponse.Data = response.data;
        break;
      default:
        _apiResponse.ApiError = ApiError(error: response.data);
        break;
    }
  } catch (e) {
    //final errorMessage = DioException.fromDioError(e);
    print(e.toString());
    _apiResponse.ApiError = ApiError(error: e.message);
  }
  return _apiResponse;
}

// GET DISCOUNT API
Future<ApiResponse> discountSale({String token, String customerId, String productId, String productPrice, String pImageUrl, String pName}) async {
  ApiResponse _apiResponse = new ApiResponse();
  var dio = Dio();

  try {
    // var loginUri = Uri.parse("$BASE_URL/api/login");
    String url = "$BASE_URL/api/discounts";

    final response = await dio.get(url,
        options: Options(
            headers: {HttpHeaders.authorizationHeader: 'Bearer $token'}));

    print("status code??????????????????????????????????????????? ${response.statusCode}");
    print("Discount Data ??????????????????????????????????????????? ${response.data}");

    switch (response.statusCode) {
      case HttpStatus.ok:
        _apiResponse.Data = DiscountModel.fromJson(response.data);
        break;
      default:
        _apiResponse.ApiError = ApiError(error: response.data);
        break;
    }
  } catch (e) {
    print("Exception error????????????????????????????????? ${e.toString()}");
    /*final errorMessage = DioException.fromDioError(e);
    _apiResponse.ApiError = ApiError(error: errorMessage.message);*/
  }
  return _apiResponse;
}



// STORE VISE DISCOUNT
Future<ApiResponse> storeViseDiscount({String token, String storeId}) async {
  ApiResponse _apiResponse = new ApiResponse();
  var dio = Dio();

  try {
    // var loginUri = Uri.parse("$BASE_URL/api/login");
    String url = "$BASE_URL/api/discounts/$storeId";

    final response = await dio.get(url,
        options: Options(
            headers: {HttpHeaders.authorizationHeader: 'Bearer $token'}));

    print("status code??????????????????????????????????????????? ${response.statusCode}");
    print("Data ??????????????????????????????????????????? ${response.data}");

    switch (response.statusCode) {
      case HttpStatus.ok:
        _apiResponse.Data = StoreViseDiscoModel.fromJson(response.data);
        break;
      default:
        _apiResponse.ApiError = ApiError(error: response.data);
        break;
    }
  } catch (e) {
    print("Exception error????????????????????????????????? ${e.toString()}");
    /*final errorMessage = DioException.fromDioError(e);
    _apiResponse.ApiError = ApiError(error: errorMessage.message);*/
  }
  return _apiResponse;
}


// cart item remove
Future<ApiResponse> cartItemRemove({String token, String pID}) async {
  ApiResponse _apiResponse = new ApiResponse();
  var dio = Dio();

  try {
    // var loginUri = Uri.parse("$BASE_URL/api/login");
    String url = "$BASE_URL/api/removeitem/$pID";

    final response = await dio.get(url,
        options: Options(
            headers: {HttpHeaders.authorizationHeader: 'Bearer $token'}));

    // print("status code??????????????????????????????????????????? ${response.statusCode}");
    // print("Data ??????????????????????????????????????????? ${response.data}");

    switch (response.statusCode) {
      case HttpStatus.ok:
        _apiResponse.Data = CartRemoveItem.fromJson(response.data);
        break;
      default:
        _apiResponse.ApiError = ApiError(error: response.data);
        break;
    }
  } catch (e) {
    print("Exception error????????????????????????????????? ${e.toString()}");
    /*final errorMessage = DioException.fromDioError(e);
    _apiResponse.ApiError = ApiError(error: errorMessage.message);*/
  }
  return _apiResponse;
}


// cart all items remove
Future<ApiResponse> cartAllItemsRemove({String token, String cartID}) async {
  ApiResponse _apiResponse = new ApiResponse();
  var dio = Dio();

  try {
    // var loginUri = Uri.parse("$BASE_URL/api/login");
    String url = "$BASE_URL/api/allitem/$cartID";

    final response = await dio.delete(url,
        options: Options(
            headers: {HttpHeaders.authorizationHeader: 'Bearer $token'}));

    // print("status code??????????????????????????????????????????? ${response.statusCode}");
    // print("Data ??????????????????????????????????????????? ${response.data}");

    switch (response.statusCode) {
      case HttpStatus.ok:
        _apiResponse.Data = CartAllItemsRemove.fromJson(response.data);
        break;
      default:
        _apiResponse.ApiError = ApiError(error: response.data);
        break;
    }
  } catch (e) {
    print("Exception error????????????????????????????????? ${e.toString()}");
    /*final errorMessage = DioException.fromDioError(e);
    _apiResponse.ApiError = ApiError(error: errorMessage.message);*/
  }
  return _apiResponse;
}

// Store views API
Future<ApiResponse> storeViews({String token, String storeID}) async {
  ApiResponse _apiResponse = new ApiResponse();
  var dio = Dio();

  try {
    // var loginUri = Uri.parse("$BASE_URL/api/login");
    String url = "$BASE_URL/api/views/$storeID";

    final response = await dio.get(url,
        options: Options(
            headers: {HttpHeaders.authorizationHeader: 'Bearer $token'}));

    // print("status code??????????????????????????????????????????? ${response.statusCode}");
    // print("Data ??????????????????????????????????????????? ${response.data}");

    switch (response.statusCode) {
      case HttpStatus.ok:
        _apiResponse.Data = StoreViews.fromJson(response.data);
        break;
      default:
        _apiResponse.ApiError = ApiError(error: response.data);
        break;
    }
  } catch (e) {
    print("Exception error????????????????????????????????? ${e.toString()}");
    /*final errorMessage = DioException.fromDioError(e);
    _apiResponse.ApiError = ApiError(error: errorMessage.message);*/
  }
  return _apiResponse;
}

// Fav stores and products

Future<ApiResponse> favStoreAndPro({String token, String customerId, String productId, String storeId, String subStoreId}) async {
  ApiResponse _apiResponse = new ApiResponse();
  var dio = Dio();

  try {
    // var loginUri = Uri.parse("$BASE_URL/api/login");
    String url = "$BASE_URL/api/favorite";

    dynamic body;

    if(storeId != null){
      body = {
        "customerId": customerId,
        "storeId": storeId,
      };
    }else if(subStoreId != null){
      body = {
        "customerId": customerId,
        "subStoreId": subStoreId,
      };
    }else{
      body = {
        "customerId": customerId,
        "productId": productId,
      };
    }

    final response = await dio.post(url,
        data: body,
        options: Options(
            headers: {HttpHeaders.authorizationHeader: 'Bearer $token'}));

    switch (response.statusCode) {
      case HttpStatus.ok:
        _apiResponse.Data = response.data;
        break;
      default:
        _apiResponse.ApiError = ApiError(error: response.data);
        break;
    }
  } catch (e) {
    final errorMessage = DioException.fromDioError(e);
    _apiResponse.ApiError = ApiError(error: errorMessage.message);
  }
  return _apiResponse;
}

// get favouite
Future<ApiResponse> getFav({String token, String customerId}) async {
  ApiResponse _apiResponse = new ApiResponse();
  var dio = Dio();

  try {
    print("CustomerId ::::::::: $customerId");
    print("Token :::::::::::::$token");
    String url = "$BASE_URL/api/favorite/$customerId";

    final response = await dio.get(url,
        options: Options(
            headers: {HttpHeaders.authorizationHeader: 'Bearer $token'}));

    switch (response.statusCode) {
      case HttpStatus.ok:
        _apiResponse.Data = GetFavThings.fromJson(response.data);
        break;
      default:
        _apiResponse.ApiError = ApiError(error: response.data);
        break;
    }
  } catch (e) {
    print("Exception error????????????????????????????????? ${e.toString()}");
    /*final errorMessage = DioException.fromDioError(e);
    _apiResponse.ApiError = ApiError(error: errorMessage.message);*/
  }
  return _apiResponse;
}

// REMOVE FAV

Future<ApiResponse> removeFavo({String token, String customerId, String productId, String storeId, String subStoreId}) async {
  ApiResponse _apiResponse = new ApiResponse();
  var dio = Dio();

  try {
    String url = "$BASE_URL/api/removefavorite";

    dynamic body;

    if(storeId != null){
      body = {
        "customerId": customerId,
        "storeId": storeId,
      };
    }else if(subStoreId != null){
      body = {
        "customerId": customerId,
        "subStoreId": subStoreId,
      };
    }else{
      body = {
        "customerId": customerId,
        "productId": productId,
      };
    }

    final response = await dio.post(url,
        data: body,
        options: Options(
            headers: {HttpHeaders.authorizationHeader: 'Bearer $token'}));

    switch (response.statusCode) {
      case HttpStatus.ok:
        _apiResponse.Data = response.data;
        break;
      default:
        _apiResponse.ApiError = ApiError(error: response.data);
        break;
    }
  } catch (e) {
    final errorMessage = DioException.fromDioError(e);
    _apiResponse.ApiError = ApiError(error: errorMessage.message);
  }
  return _apiResponse;
}

// Revenue API
Future<ApiResponse> revenueOfPartner({String token, String storeId}) async {
  ApiResponse _apiResponse = new ApiResponse();
  var dio = Dio();

  try {
    // var loginUri = Uri.parse("$BASE_URL/api/login");
    String url = "$BASE_URL/api/revenue/$storeId";

    final response = await dio.get(url,
        options: Options(
            headers: {HttpHeaders.authorizationHeader: 'Bearer $token'}));

    print("status code??????????????????????????????????????????? ${response.statusCode}");
    print("Data ??????????????????????????????????????????? ${response.data}");

    switch (response.statusCode) {
      case HttpStatus.ok:
        _apiResponse.Data = RevenueModel.fromJson(response.data);
        break;
      default:
        _apiResponse.ApiError = ApiError(error: response.data);
        break;
    }
  } catch (e) {
    print("Exception error????????????????????????????????? ${e.toString()}");
    /*final errorMessage = DioException.fromDioError(e);
    _apiResponse.ApiError = ApiError(error: errorMessage.message);*/
  }
  return _apiResponse;
}

// Total Store Sales
Future<ApiResponse> totalStoreSales({String token, String storeId}) async {
  ApiResponse _apiResponse = new ApiResponse();
  var dio = Dio();

  try {
    // var loginUri = Uri.parse("$BASE_URL/api/login");
    String url = "$BASE_URL/api/sales/$storeId";

    final response = await dio.get(url,
        options: Options(
            headers: {HttpHeaders.authorizationHeader: 'Bearer $token'}));

    print("status code??????????????????????????????????????????? ${response.statusCode}");
    print("Data ??????????????????????????????????????????? ${response.data}");

    switch (response.statusCode) {
      case HttpStatus.ok:
        _apiResponse.Data = TotalSales.fromJson(response.data);
        break;
      default:
        _apiResponse.ApiError = ApiError(error: response.data);
        break;
    }
  } catch (e) {
    print("Exception error????????????????????????????????? ${e.toString()}");
    /*final errorMessage = DioException.fromDioError(e);
    _apiResponse.ApiError = ApiError(error: errorMessage.message);*/
  }
  return _apiResponse;
}

// Popular Store
Future<ApiResponse> popularStore({String token}) async {
  ApiResponse _apiResponse = new ApiResponse();
  var dio = Dio();

  try {
    // var loginUri = Uri.parse("$BASE_URL/api/login");
    String url = "$BASE_URL/api/popular";

    final response = await dio.get(url,
        options: Options(
            headers: {HttpHeaders.authorizationHeader: 'Bearer $token'}));

    print("status code??????????????????????????????????????????? ${response.statusCode}");
    print("Data ??????????????????????????????????????????? ${response.data}");

    switch (response.statusCode) {
      case HttpStatus.ok:
        _apiResponse.Data = PopluarStoreModel.fromJson(response.data);
        break;
      default:
        _apiResponse.ApiError = ApiError(error: response.data);
        break;
    }
  } catch (e) {
    print("Exception error????????????????????????????????? ${e.toString()}");
    /*final errorMessage = DioException.fromDioError(e);
    _apiResponse.ApiError = ApiError(error: errorMessage.message);*/
  }
  return _apiResponse;
}

// SALES BY MONTH
Future<ApiResponse> salesByMonth({String token, String storeId, int month, String status}) async {
  ApiResponse _apiResponse = new ApiResponse();
  var dio = Dio();

  print("Store ID :::::::::: $storeId");
  print("Token ::::::::::::: $token");
  print("Status ::::::::::::: $status");


  try {
    // var loginUri = Uri.parse("$BASE_URL/api/login");
    String url = "$BASE_URL/api/report?storeId=$storeId&month=$month&status=$status";

    final response = await dio.get(url,
        options: Options(
            headers: {HttpHeaders.authorizationHeader: 'Bearer $token'}));

    // print("status code??????????????????????????????????????????? ${response.statusCode}");
    // print("Data ??????????????????????????????????????????? ${response.data}");

    switch (response.statusCode) {
      case HttpStatus.ok:
        _apiResponse.Data = SalesByMonth.fromJson(response.data);
        break;
      default:
        _apiResponse.ApiError = ApiError(error: response.data);
        break;
    }
  } catch (e) {
    print("Exception error????????????????????????????????? ${e.toString()}");
    /*final errorMessage = DioException.fromDioError(e);
    _apiResponse.ApiError = ApiError(error: errorMessage.message);*/
  }
  return _apiResponse;
}


// Forgot password
Future<ApiResponse> forgotPassword({String token, String oldPass, String newPass}) async {
  ApiResponse _apiResponse = new ApiResponse();
  var dio = Dio();
  try {
    String url = "$BASE_URL/api/password";

    dynamic body = {
      "oldPassword": oldPass,
      "password": newPass
    };

    final response = await dio.post(url,
        data: body,
        options: Options(
            headers: {HttpHeaders.authorizationHeader: 'Bearer $token'}));
    switch (response.statusCode) {
      case HttpStatus.ok:
        _apiResponse.Data = response.data;
        break;
      default:
        _apiResponse.ApiError = ApiError(error: response.data);
        break;
    }
  } catch (e) {
    //final errorMessage = DioException.fromDioError(e);
    print(e.toString());
    _apiResponse.ApiError = ApiError(error: e.message);
  }
  return _apiResponse;
}


Future<ApiResponse> checkPromoCode({String token, String promoCode}) async {
  ApiResponse _apiResponse = new ApiResponse();
  var dio = Dio();

  try {
    // var loginUri = Uri.parse("$BASE_URL/api/login");
    String url = "$BASE_URL/api/cart";

    final response = await dio.get(url,
        options: Options(
            headers: {HttpHeaders.authorizationHeader: 'Bearer $token'}));

    print("status code??????????????????????????????????????????? ${response.statusCode}");
    print("Data ??????????????????????????????????????????? ${response.data}");

    switch (response.statusCode) {
      case HttpStatus.ok:
        _apiResponse.Data = CartGetModel.fromJson(response.data);
        break;
      default:
        _apiResponse.ApiError = ApiError(error: response.data);
        break;
    }
  } catch (e) {
    print("Exception error????????????????????????????????? ${e.toString()}");
  }
  return _apiResponse;
}


Future<ApiResponse> newGetFav({String token, String customerId}) async {
  ApiResponse _apiResponse = new ApiResponse();
  var dio = Dio();

  try {
    print("CustomerId ::::::::: $customerId");
    print("Token :::::::::::::$token");
    String url = "$BASE_URL/api/favorite/$customerId";

    final response = await dio.get(url,
        options: Options(
            headers: {HttpHeaders.authorizationHeader: 'Bearer $token'}));

    switch (response.statusCode) {
      case HttpStatus.ok:
        _apiResponse.Data = NewGetFavThings.fromJson(response.data);
        break;
      default:
        _apiResponse.ApiError = ApiError(error: response.data);
        break;
    }
  } catch (e) {
    print("Exception error????????????????????????????????? ${e.toString()}");
    /*final errorMessage = DioException.fromDioError(e);
    _apiResponse.ApiError = ApiError(error: errorMessage.message);*/
  }
  return _apiResponse;
}


Future<ApiResponse> getBannerAds({String token}) async {
  ApiResponse _apiResponse = new ApiResponse();
  var dio = Dio();

  try {
    // var loginUri = Uri.parse("$BASE_URL/api/login");
    String url = "$BASE_URL/api/bannerads";

    final response = await dio.get(url,
        options: Options(
            headers: {HttpHeaders.authorizationHeader: 'Bearer $token'}));

    print("status code??????????????????????????????????????????? ${response.statusCode}");
    print("Data ??????????????????????????????????????????? ${response.data}");

    switch (response.statusCode) {
      case HttpStatus.ok:
        _apiResponse.Data = GetBannerAdsModel.fromJson(response.data);
        break;
      default:
        _apiResponse.ApiError = ApiError(error: response.data);
        break;
    }
  } catch (e) {
    print("Exception error????????????????????????????????? ${e.toString()}");
  }
  return _apiResponse;
}


Future<ApiResponse> getAllStores ({String token}) async{
  ApiResponse _apiResponse = ApiResponse();

  String url = "${BASE_URL}/api/allstores";

  try{
    final response = await http.get(Uri.parse(url), headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

    switch (response.statusCode) {
      case HttpStatus.ok:
        _apiResponse.Data = GetAllStoreModel.fromJson(json.decode(response.body));
        break;
      default:
        _apiResponse.ApiError = ApiError(error: response.body);
        break;
    }
  }
  catch(e){
    print("API ERROR ::::::::::::::::::::::::::: ${e}");
    print('before api error catch');
    _apiResponse.ApiError = ApiError(error: e.toString());
    print('after api error catch');
  }

  return _apiResponse;
}

Future<ApiResponse> checkAlreadyLike({String token, String id, String customerId}) async {
  ApiResponse _apiResponse = new ApiResponse();
  var dio = Dio();

  try {
    print("CustomerId ::::::::: $id");
    print("Token :::::::::::::$token");
    String url = "$BASE_URL/api/like/$id/$customerId";

    final response = await dio.get(url,
        options: Options(
            headers: {HttpHeaders.authorizationHeader: 'Bearer $token'}));

    switch (response.statusCode) {
      case HttpStatus.ok:
        _apiResponse.Data = CheckAlreadyLike.fromJson(response.data);
        break;
      default:
        _apiResponse.ApiError = ApiError(error: response.data);
        break;
    }
  } catch (e) {
    print("Exception error????????????????????????????????? ${e.toString()}");
    /*final errorMessage = DioException.fromDioError(e);
    _apiResponse.ApiError = ApiError(error: errorMessage.message);*/
  }
  return _apiResponse;
}