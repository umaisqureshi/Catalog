import 'dart:io';
import 'package:category/modals/apiError.dart';
import 'package:category/modals/apiResponse.dart';
import 'package:category/modals/mainStoreModal.dart';
import 'package:category/modals/subStoreModel.dart';
import 'package:category/utils/constant.dart';
import 'package:category/utils/exceptions.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:http_parser/http_parser.dart';

Future<ApiResponse> uploadData(
    {@required File image,
    @required String name,
    @required String category,
    @required String location,
    @required String desc,
    @required String gender,
    @required String token}) async {
  String createStoreUrl = "$BASE_URL/api/store";
  var dio = Dio();
  ApiResponse _apiResponse = ApiResponse();
  String fileName = image.path.split('/').last;
  String imageType = fileName.split('.').last;
  print("Image Path :::::::::::::::::::::: $fileName");
  print("Image Type :::::::::::::::::::::: $imageType");
  print("Store Name :::::::::::::::::::::: $name");
  print("Store category :::::::::::::::::::::: $category");
  print("Store location :::::::::::::::::::::: $location");
  print("Store desc :::::::::::::::::::::: $desc");

  FormData formData = FormData.fromMap({
    "store_logo": await MultipartFile.fromFile(image.path,
        filename: fileName, contentType: MediaType("image", imageType)),
    "store_name": name,
    "store_category": category,
    "store_gender": gender,
    "location": location,
    "store_description": desc,
  });

  try {
    final response = await dio.post(createStoreUrl,
        data: formData,
        options: Options(headers: {
          'Content-type': 'multipart/form-data',
          'Accept': '*/*',
          'Authorization' : 'Bearer ${token}'
        }));

    print("Response Status ::::::::::: ${response.statusCode}");

    switch (response.statusCode) {
      case HttpStatus.created:
        _apiResponse.Data = response.data;//MainStore.fromJson();
        break;
      default:
        _apiResponse.ApiError = ApiError(error: response.data);
        break;
    }
    print(response.data.toString());
  } catch(e) {
    //final errorMessage = DioException.fromDioError(e);
    print('WTF IS THIS ERROR :::::::::::::::: ${e.toString()}');
    _apiResponse.ApiError = ApiError(error: e.toString());
  }
  return _apiResponse;
}

Future<ApiResponse> createSubStore(
    {@required File image,
      @required String name,
      @required String category,
      @required String location,
      @required String desc,
      @required String token,
    @required String storeId}) async {
  String createStoreUrl = "$BASE_URL/api/substore";
  var dio = Dio();
  ApiResponse _apiResponse = ApiResponse();

  String fileName = image.path.split('/').last;
  String imageType = fileName.split('.').last;

  print("Image Path :::::::::::::::::::::: $fileName");
  print("Image Type :::::::::::::::::::::: $imageType");
  print("Store Name :::::::::::::::::::::: $name");
  print("Store category :::::::::::::::::::::: $category");
  print("Store location :::::::::::::::::::::: $location");
  print("Store desc :::::::::::::::::::::: $desc");
  print("Store Id ::::::::::::::::::::::: $storeId");

  FormData formData = FormData.fromMap({
    "store_logo": await MultipartFile.fromFile(image.path,
        filename: fileName, contentType: MediaType("image", imageType)),
    "store_name": name,
    "store_category": category,
    "location": location,
    "store_description": desc,
    "store_id" : storeId
  });

  try {
    final response = await dio.post(createStoreUrl,
        data: formData,
        options: Options(headers: {
          'Content-type': 'multipart/form-data',
          'Accept': '*/*',
          'Authorization' : 'Bearer ${token}'
        }));

    print("Response Status ::::::::::: ${response.statusCode}");

    switch (response.statusCode) {
      case HttpStatus.created:
        _apiResponse.Data = response.data;//MainStore.fromJson();
        break;
      default:
        _apiResponse.ApiError = ApiError(error: response.data);
        break;
    }
  } catch(e) {
    //final errorMessage = DioException.fromDioError(e);
    print('WTF IS THIS ERROR :::::::::::::::: ${e.toString()}');
    _apiResponse.ApiError = ApiError(error: e.toString());
  }
  return _apiResponse;
}

Future<ApiResponse> editMainStore(
    {@required File image,
      @required String name,
      @required String category,
      @required String location,
      @required String desc,
      @required String token,
      @required String id,
      @required String status,
      @required int sub

    }) async {
  String createStoreUrl = "$BASE_URL/api/editStore";
  var dio = Dio();
  ApiResponse _apiResponse = ApiResponse();
  String fileName = image.path.split('/').last;
  String imageType = fileName.split('.').last;

  FormData formData = FormData.fromMap({
    "store_logo": await MultipartFile.fromFile(image.path,
        filename: fileName, contentType: MediaType("image", imageType)),
    "store_name": name,
    "store_category": category,
    "location": location,
    "store_description": desc,
    "id": id,
    "approval_status": status,
    "subscription":sub
  });

  try {
    final response = await dio.post(createStoreUrl,
        data: formData,
        options: Options(headers: {
          'Content-type': 'multipart/form-data',
          'Accept': '*/*',
          'Authorization' : 'Bearer ${token}'
        }));

    switch (response.statusCode) {
      case HttpStatus.created:
      case HttpStatus.ok:
        _apiResponse.Data = response.data;//MainStore.fromJson();
        break;
      default:
        _apiResponse.ApiError = ApiError(error: response.data);
        break;
    }
  } catch(e) {
    print('WTF IS THIS ERROR :::::::::::::::: ${e.toString()}');
    _apiResponse.ApiError = ApiError(error: e.toString());
  }
  return _apiResponse;
}


