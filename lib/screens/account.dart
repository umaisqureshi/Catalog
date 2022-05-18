import 'dart:convert';
import 'dart:io';
import 'package:category/api/auth_apis.dart';
import 'package:category/modals/apiError.dart';
import 'package:category/modals/apiResponse.dart';
import 'package:category/modals/profileModel.dart';
import 'package:category/modals/user.dart';
import 'package:category/utils/constant.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:category/widgets/buttonWidget.dart';
import 'package:category/widgets/textWidget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final ImagePicker _picker = ImagePicker();
  File _profileImage;
  String networkImagePath;
  dynamic _pickImageError;
  bool isErrorPickingImage = false;
  bool isLoading = false;
  Welcome _userInfo;
  ProfileModel _profileModel;

  ApiResponse _apiResponse = ApiResponse();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String firstName;
  String lastName;
  String userName;
  String email;

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
      showInSnackBar("Profile Updated Successfully");
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

  @override
  void initState() {
    _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
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
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height / 1.2,
            width: MediaQuery.of(context).size.width,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
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
                              ? Image.network(
                            _profileModel.profileImg,
                            fit: BoxFit.cover,
                          )
                              : Image.file(
                            _profileImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 5,
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
                    padding: const EdgeInsetsDirectional.only(start: 16.0, end: 16),
                    child: Container(
                      height: 45,
                      child: TextFormField(
                        initialValue: firstName,
                        validator: (input) {
                          if (input.isEmpty)
                            return AppLocalizations.of(context).requiredField;
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
                          hintText: AppLocalizations.of(context).firstName,
                          hintStyle: TextStyle(color: Colors.black45, fontSize: 15,),
                          contentPadding: EdgeInsetsDirectional.all(5),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 16.0, end: 16),
                    child: Container(
                      height: 45,
                      child: TextFormField(
                        initialValue: lastName,
                        validator: (input) {
                          if (input.isEmpty)
                            return AppLocalizations.of(context).requiredField;
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
                          hintText: AppLocalizations.of(context).lastName,
                          hintStyle: TextStyle(color: Colors.black45, fontSize: 15,),
                          contentPadding: EdgeInsetsDirectional.all(5),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 16.0, end: 16),
                    child: Container(
                      height: 45,
                      child: TextFormField(
                        initialValue: _userInfo.userData.username == null? userName: _userInfo.userData.username,
                        validator: (input) {
                          if (input.isEmpty)
                            return AppLocalizations.of(context).requiredField;
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
                          hintText: AppLocalizations.of(context).username,
                          hintStyle: TextStyle(color: Colors.black45, fontSize: 15,),
                          contentPadding: EdgeInsetsDirectional.all(5),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 16.0, end: 16),
                    child: Container(
                      height: 45,
                      child: TextFormField(
                        initialValue: _userInfo.userData.email == null? email: _userInfo.userData.email,
                        validator: (input) {
                          if (input.isEmpty)
                            return AppLocalizations.of(context).requiredField;
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
                          hintText: AppLocalizations.of(context).email,
                          hintStyle: TextStyle(color: Colors.black45, fontSize: 15,),
                          contentPadding: EdgeInsetsDirectional.all(5),
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
                      text: AppLocalizations.of(context).save,
                      textSize: 18,
                      textColor: grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
