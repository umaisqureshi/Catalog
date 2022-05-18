import 'package:dio/dio.dart';

class DioException implements Exception{
  String message;
  DioException.fromDioError(DioError dioError){
    switch(dioError.type){
      case DioErrorType.cancel:
        message = "Request to API was cancelled";
        break;
      case DioErrorType.connectTimeout:
        message = "Connection Timeout";
        break;
      case DioErrorType.other:
        message = "Request failed due to internet connection";
        break;
      case DioErrorType.receiveTimeout:
        message = "Receive Timeout";
        break;
      case DioErrorType.sendTimeout:
        message = "Send timeout";
        break;
      case DioErrorType.response:
        message = _handleResponseError(dioError.response.statusCode, dioError.response.data);
        break;
      default:
        message = "Something went wrong";
        break;
    }
  }

  _handleResponseError(int statusCode, dynamic error){
    switch(statusCode){
      case 400:
        return "Bad Request";
      case 404:
        return "${error['message']}";
      case 409:
        return "Main Store is already created";
      case 503:
        return "Service Not Available";
      case 500:
        return (error["originalError"] == "Wrong email" || error['originalError'] == "Wrong password") ? error['originalError'] :error['message'];
      default:
        return "Oops something went wrong";
    }
  }
}