import 'package:category/modals/apiError.dart';
import 'package:category/modals/apiResponse.dart';
import 'package:category/modals/control_ads_model.dart';
import 'package:category/modals/get_all_notifications.dart';
import 'package:category/modals/get_all_orders.dart';
import 'package:category/modals/get_all_stores.dart';
import 'package:category/modals/profileModel.dart';
import 'package:category/modals/profileUpdateModel.dart';
import 'package:category/modals/promo_codes_model.dart';
import 'package:category/modals/user.dart';
import 'package:category/utils/constant.dart';
import 'package:category/utils/exceptions.dart';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http_parser/http_parser.dart';

Future<ApiResponse> authenticateUser(String email, String password) async {
  ApiResponse _apiResponse = new ApiResponse();
  var dio = Dio();

  try {
    // var loginUri = Uri.parse("$BASE_URL/api/login");
    String loginUrl = "$BASE_URL/api/login";
    print("Login Uri :::::::::::: $loginUrl");

    dynamic data = {"email": email, "password": password};

    final response = await dio.post(loginUrl,
        data: data,
        options: Options(
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        ));

    switch (response.statusCode) {
      case HttpStatus.ok:
        _apiResponse.Data = Welcome.fromJson(response.data);
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

Future<ApiResponse> registerUser(String username, String email, String password,
    String cpassword) async {
  ApiResponse _apiResponse = new ApiResponse();
  var dio = Dio();

  try {
    //var registerUri = Uri.parse("$BASE_URL/api/register");
    String registerUrl = "$BASE_URL/api/register";
    print("Login Uri :::::::::::: $registerUrl");

    dynamic data = {
      "username": username,
      "email": email,
      "password": password,
      "cpassword": cpassword
    };

    final response = await dio.post(registerUrl,
        data: data,
        options: Options(
            headers: {HttpHeaders.contentTypeHeader: 'application/json'}));

    switch (response.statusCode) {
      case 200:
        _apiResponse.Data = Welcome.fromJson(response.data);
        break;
/*      case 409:
        _apiResponse.ApiError = ApiError(error : response.data);
        break;*/
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

Future<ApiResponse> updateRole(String role, String token) async {
  ApiResponse _apiResponse = new ApiResponse();
  Dio dio = Dio();

  //dio.options.headers["Authorization"] = "Bearer ${token}";

  try {
    String roleUrl = "$BASE_URL/api/role";

    dynamic data = {"role": role};

    final response = await dio.put(roleUrl,
        data: data,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${token}'
        }));

    switch (response.statusCode) {
      case HttpStatus.ok:
        _apiResponse.Data = response.data;
        break;
      default:
        _apiResponse.ApiError = ApiError(error: response.data);
    }
  } catch (e) {
    //final errorMessage = DioException.fromDioError(e);
    _apiResponse.ApiError = ApiError(error: e.toString());
  }
  return _apiResponse;
}

/*void loginWithFacebook() async {
  final facebookLoginResult = await facebookLogin.logIn(['email']);
  final token = facebookLoginResult.accessToken.token;
  print(token);
  final graphResponse = await http.get(Uri.parse(
      "https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,picture,email&access_token=$token"));
  var fbData = signInWithfbResponseModelFromJson(graphResponse.body);
  setState(() {
    loader = true;
  });
  loginClient.signInWithFb(fbData).then((auth) async {
    print(auth.status);
    if (auth.status) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString("user_data", json.encode(auth));
      Navigator.pushReplacementNamed(context, auth.data.step);
    }
    setState(() {
      loader = false;
    });
  }).catchError((e) {
    setState(() {
      loader = false;
    });
    print(e.toString());
  });
}*/

Future<ApiResponse> getProfile({String token})async {
  ApiResponse _apiResponse = new ApiResponse();
  Dio dio = Dio();

  try {
    String url = "$BASE_URL/api/me";

    final response = await dio.get(url,
        options: Options(headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token'
        }));

    switch (response.statusCode) {
      case HttpStatus.ok:
        _apiResponse.Data = ProfileModel.fromJson(response.data);
        break;
      default:
        _apiResponse.ApiError = ApiError(error: response.data);
    }
  } catch (e) {
    final errorMessage = DioException.fromDioError(e);
    _apiResponse.ApiError = ApiError(error: errorMessage.message);
  }
  return _apiResponse;
}

Future<ApiResponse> updateProfile({String token, Map<String, dynamic> data})async{
  ApiResponse _apiResponse = new ApiResponse();
  Dio dio = Dio();

  dio.options.headers["Authorization"] = "Bearer ${token}";
  String fileName = data["profileImage"].path.split('/').last;
  String imageType = fileName.split('.').last;

  FormData formData = FormData.fromMap({
    "firstname": data['firstname'],
    "lastname": data['lastname'],
    "username": data['username'],
    "email": data['email'],
    "profile_img": await MultipartFile.fromFile(data['profileImage'].path,
  filename: fileName, contentType: MediaType("image", imageType)),
  });

  try {
    String url = "$BASE_URL/api/profile";

    final response = await dio.put(url,
        data: formData,
        options: Options(headers: {
          'Content-type': 'multipart/form-data',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        }));

    switch (response.statusCode) {
      case HttpStatus.ok:
        _apiResponse.Data = ProfileUpdateModel.fromJson(response.data);
        break;
      default:
        _apiResponse.ApiError = ApiError(error: response.data);
    }
  } catch (e) {
    final errorMessage = DioException.fromDioError(e);
    _apiResponse.ApiError = ApiError(error: errorMessage.message);
  }
  return _apiResponse;
}

Future<ApiResponse> registerUserWithPhone(String phone) async {
  ApiResponse _apiResponse = new ApiResponse();
  var dio = Dio();
  try {
    String registerUrl = "$BASE_URL/api/phonenumber";
    print("Register Uri :::::::::::: $registerUrl");

    dynamic data = {
      "phonenumber": phone,
      "channel": "sms"
    };
    final response = await dio.post(registerUrl,
        data: data,
        options: Options(
            headers: {HttpHeaders.contentTypeHeader: 'application/json'}));
    switch (response.statusCode) {
      case 200:
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


Future<ApiResponse> verifyCode(String username, String phone, String code) async {
  ApiResponse _apiResponse = new ApiResponse();
  var dio = Dio();
  try {
    String verifyUrl = "$BASE_URL/api/verify";
    print("verify Url :::::::::::: $verifyUrl");
    print("username :::::: $username");
    print("phone :::::: $phone");
    print("code :::::: $code");

    dynamic data = {
      "username": username,
      "phonenumber": phone,
      "code": code
    };
    final response = await dio.post(verifyUrl,
        data: data,
        options: Options(
            headers: {HttpHeaders.contentTypeHeader: 'application/json'}));
    switch (response.statusCode) {
      case 200:
        _apiResponse.Data = Welcome.fromJson(response.data);
        break;
      default:
        _apiResponse.ApiError = ApiError(error: response.data);
        break;
    }
  } catch (e) {
    //print("Exception ::::::::::: ${}");
    //final errorMessage = DioException.fromDioError(e);
    _apiResponse.ApiError = ApiError(error: e.toString());
  }
  return _apiResponse;
}


Future<ApiResponse> getPromoCode({String token})async {
  ApiResponse _apiResponse = new ApiResponse();
  Dio dio = Dio();

  try {
    String url = "$BASE_URL/api/promo";

    final response = await dio.get(url,
        options: Options(headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token'
        }));

    switch (response.statusCode) {
      case HttpStatus.ok:
        _apiResponse.Data = GetPromoCodes.fromJson(response.data);
        break;
      default:
        _apiResponse.ApiError = ApiError(error: response.data);
    }
  } catch (e) {
    final errorMessage = DioException.fromDioError(e);
    _apiResponse.ApiError = ApiError(error: errorMessage.message);
  }
  return _apiResponse;
}

Future<ApiResponse> changePassword({String token, String oldPassword, String newPassword}) async {
  ApiResponse _apiResponse = new ApiResponse();
  var dio = Dio();
  try {
    String url = "$BASE_URL/api/password";

    dynamic body = {
      "oldPassword": oldPassword,
      "password": newPassword
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

Future<ApiResponse> getNotifications({String token})async {
  ApiResponse _apiResponse = new ApiResponse();
  Dio dio = Dio();

  try {
    String url = "$BASE_URL/api/notification";

    final response = await dio.get(url,
        options: Options(headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token'
        }));

    switch (response.statusCode) {
      case HttpStatus.ok:
        _apiResponse.Data = GetNotificationsModel.fromJson(response.data);
        break;
      default:
        _apiResponse.ApiError = ApiError(error: response.data);
    }
  } catch (e) {
    final errorMessage = DioException.fromDioError(e);
    _apiResponse.ApiError = ApiError(error: errorMessage.message);
  }
  return _apiResponse;
}

Future<ApiResponse> getAds({String token})async {
  ApiResponse _apiResponse = new ApiResponse();
  Dio dio = Dio();

  try {
    String url = "$BASE_URL/api/ads";

    final response = await dio.get(url,
        options: Options(headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token'
        }));

    switch (response.statusCode) {
      case HttpStatus.ok:
        _apiResponse.Data = GetAdsModel.fromJson(response.data);
        break;
      default:
        _apiResponse.ApiError = ApiError(error: response.data);
    }
  } catch (e) {
    final errorMessage = DioException.fromDioError(e);
    _apiResponse.ApiError = ApiError(error: errorMessage.message);
  }
  return _apiResponse;
}


Future<ApiResponse> getAllOrders({String token})async {
  ApiResponse _apiResponse = new ApiResponse();
  Dio dio = Dio();

  try {
    String url = "$BASE_URL/api/orders";

    final response = await dio.get(url,
        options: Options(headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token'
        }));

    switch (response.statusCode) {
      case HttpStatus.ok:
        _apiResponse.Data = GetAllOrdersModel.fromJson(response.data);
        break;
      default:
        _apiResponse.ApiError = ApiError(error: response.data);
    }
  } catch (e) {
    final errorMessage = DioException.fromDioError(e);
    _apiResponse.ApiError = ApiError(error: errorMessage.message);
  }
  return _apiResponse;
}

