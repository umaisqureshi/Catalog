import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:category/api/auth_apis.dart';
import 'package:category/modals/apiError.dart';
import 'package:category/modals/apiResponse.dart';
import 'package:category/modals/profileModel.dart';
import 'package:category/modals/profileUpdateModel.dart';
import 'package:category/modals/user.dart';
import 'package:category/screens/dashboard1/widgets/buttonWidget.dart';
import 'package:category/screens/dashboard1/widgets/textWidget.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:category/widgets/noConnection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:category/utils/constant.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class Account1 extends StatefulWidget {
  @override
  _Account1State createState() => _Account1State();
}

class _Account1State extends State<Account1> {
  final ImagePicker _picker = ImagePicker();
  File _profileImage;
  String networkImagePath;
  dynamic _pickImageError;
  bool isErrorPickingImage = false;
  bool isLoading = false;

  ApiResponse _apiResponse = ApiResponse();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String firstName;
  String lastName;
  String userName;
  String email;

  bool isInternetAvailable = true;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  _pickImageFromGallery() async {
    try {
      final _pickedFile = await _picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 60,
      );
      setState(() {
        _profileImage = File(_pickedFile.path);
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
        isErrorPickingImage = true;
      });
    }
  }

  showInSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _handleUpdateProfile(Map<String, dynamic> map) async {
    Welcome userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));

    print("User's Token ::::::::::::::::::::::::::::: ${userInfo.token}");

    _apiResponse = await updateProfile(token: userInfo.token, data: map);

    if ((_apiResponse.ApiError as ApiError) == null) {
      ProfileUpdateModel _profile = _apiResponse.Data;
      await FirebaseFirestore.instance.collection("Users").doc(userInfo.userData.id).update({
        "username" : _profile.user.username,
        "email" : _profile.user.email,
        "role" : _profile.user.role,
        "profileImageUrl" : _profile.user.profileImg
      });
      showInSnackBar("Profile Updated Successfully");
      setState(() {
        isLoading = false;
      });
    } else {
      showInSnackBar((_apiResponse.ApiError as ApiError).error);
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<ApiResponse> _handleGetProfile() async {
    Welcome _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
    print("TOKEN :::::::::::::::::::::: ${_userInfo.token}");
    return getProfile(token: _userInfo.token);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        setState((){
          isInternetAvailable = true;
        });
        break;
      default:
        setState(() => isInternetAvailable = false);
        break;
    }
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: TextWidget(
            text: AppLocalizations.of(context).editProfile,
            textSize: 18,
            textColor: primary,
            isBold: true,
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: isInternetAvailable ? FutureBuilder<ApiResponse>(
          future: _handleGetProfile(),
          builder: (context, snapshot) {
            if(snapshot.hasData){

              ProfileModel profile = snapshot.data.Data;
              firstName = profile.firstname ?? AppLocalizations.of(context).firstName;
              lastName = profile.lastname ?? AppLocalizations.of(context).lastName;
              userName = profile.username;
              email = profile.email;
              networkImagePath = profile.profileImg;

              return SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height / 1.2,
                  width: MediaQuery.of(context).size.width,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Container(
                                height: 100,
                                width: 100,
                                child: _profileImage == null
                                    ? Image.network(profile.profileImg!=null ? profile.profileImg : "https://img.favpng.com/2/12/12/computer-icons-portable-network-graphics-user-profile-avatar-png-favpng-L1ihcbxsHbnBKBvjjfBMFGbb7.jpg",
                                  fit: BoxFit.cover,
                                )
                                    : Image.file(
                                  _profileImage,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: GestureDetector(
                                onTap: () async {
                                  _pickImageFromGallery();
                                },
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      color: Color(0xFFb58563),
                                      borderRadius: BorderRadius.circular(100)),
                                  child: Center(
                                    child: Icon(
                                      Icons.add,
                                      color: white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
                            height: 45,
                            child: TextFormField(
                              initialValue: firstName,
                              validator: (input) {
                                if (input.isEmpty)
                                  return "Required Field";
                                else
                                  return null;
                              },
                              onSaved: (value){
                                firstName = value;
                              },
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.red[700],
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.red[700],
                                  ),
                                ),
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.black,
                                ),
                                hintText: "First Name",
                                hintStyle: TextStyle(color: Colors.black45, fontSize: 15,),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
                            height: 45,
                            child: TextFormField(
                              initialValue: lastName,
                              validator: (input) {
                                if (input.isEmpty)
                                  return "Required Field";
                                else
                                  return null;
                              },
                              onSaved: (value){
                                lastName = value;
                              },
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.red[700],
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.red[700],
                                  ),
                                ),
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.black,
                                ),
                                hintText: "Last Name",
                                hintStyle: TextStyle(color: Colors.black45, fontSize: 15,),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
                            height: 45,
                            child: TextFormField(
                              initialValue: userName,
                              validator: (input) {
                                if (input.isEmpty)
                                  return "Required Field";
                                else
                                  return null;
                              },
                              onSaved: (value){
                                userName = value;
                              },
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.red[700],
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.red[700],
                                  ),
                                ),
                                prefixIcon: Icon(
                                  Icons.contact_mail,
                                  color: Colors.black,
                                ),
                                hintText: "Username",
                                hintStyle: TextStyle(color: Colors.black45, fontSize: 15,),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
                            height: 45,
                            child: TextFormField(
                              initialValue: email,
                              validator: (input) {
                                if (input.isEmpty)
                                  return "Required Field";
                                else
                                  return null;
                              },
                              onSaved: (value){
                                email = value;
                              },
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.red[700],
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.red[700],
                                  ),
                                ),
                                prefixIcon: Icon(
                                  Icons.mail,
                                  color: Colors.black,
                                ),
                                hintText: "Email",
                                hintStyle: TextStyle(color: Colors.black45, fontSize: 15,),
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        isLoading ? Center(child: CircularProgressIndicator(color: brown,),):ButtonWidget(
                          buttonHeight: 50,
                          buttonWidth: MediaQuery.of(context).size.width,
                          function: ()async{
                            if(_formKey.currentState.validate()){
                              _formKey.currentState.save();
                              setState(() {
                                isLoading=true;
                              });
                              _handleUpdateProfile({"firstname" : firstName, "lastname" : lastName, "username" : userName, "email" : email, "profileImage" : _profileImage});
                            }
                          },
                          roundedBorder: 10,
                          buttonColor: Color(0xFFb58563),
                          widget: TextWidget(
                            text: 'Save',
                            textSize: 18,
                            textColor: grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            else if(snapshot.hasError){
              return Text("Something went wrong.", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black,),);
            }
            else{
              return Center(child: CircularProgressIndicator(color: brown,),);
            }

          }
        ) : NoInternet(),
      ),
    );
  }
}
