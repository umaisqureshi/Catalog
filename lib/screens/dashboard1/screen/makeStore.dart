import 'dart:convert';
import 'dart:io';

import 'package:category/api/createStoreApi.dart';
import 'package:category/modals/apiError.dart';
import 'package:category/modals/apiResponse.dart';
import 'package:category/modals/create_category_model.dart';
import 'package:category/modals/get_category_model.dart';
import 'package:category/modals/user.dart';
import 'package:category/screens/dashboard1/widgets/buttonWidget.dart';
import 'package:category/screens/dashboard1/widgets/textWidget.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:flutter/material.dart';
import 'package:category/utils/constant.dart';
import 'package:image_picker/image_picker.dart';

class MakeStore extends StatefulWidget {
  String storeId;
  final GetCategory getCategory;

  MakeStore({this.storeId, this.getCategory});

  @override
  _MakeStoreState createState() => _MakeStoreState();
}

class _MakeStoreState extends State<MakeStore> {
  String category;
  String name;
  String desc;
  PickedFile _imageFile;
  Color logoPickedColor = brown;
  dynamic _pickImageError;
  bool isErrorPickingImage = false;
  bool isUploading = false;
  bool isLogoPicked = false;
  bool isLocationPicked = false;
  bool isCategorySelected = false;
  String location;
  String storeId;
List<String> categoryList = [];
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();
  ApiResponse _apiResponse = ApiResponse();
  Welcome userInfo;

  showInSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _pickImageFromGallery() async {
    try {
      final _pickedFile = await _picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 60,
      );
      setState(() {
        _imageFile = _pickedFile;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
        isErrorPickingImage = true;
      });
    }
  }

  _handleCreateSubStore() async {
    userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));

    print("User's Token ::::::::::::::::::::::::::::: ${userInfo.token}");

    _apiResponse = await createSubStore(
        image: File(_imageFile.path),
        name: name,
        location: location,
        category: category,
        desc: desc,
        token: userInfo.token,
        storeId: widget.storeId);

    if ((_apiResponse.ApiError as ApiError) == null) {
      setState((){
        isUploading = false;
      });
      showInSnackBar(AppLocalizations.of(context).requestSubmitted);
    } else {
      showInSnackBar((_apiResponse.ApiError as ApiError).error);
      setState(() {
        isUploading = false;
      });
    }
  }

  @override
  void initState() {

    category = categoriesObj.category[0].category.category;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: TextWidget(
            text: AppLocalizations.of(context).createStore,
            textSize: 18,
            textColor: primary,
            isBold: true,
          ),
          centerTitle: true,
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsetsDirectional.only(top: size.height * 0.02),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                              start: 20, end: 20, top: 3, bottom:3),
                          child: Row(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: logoPickedColor, width: 5),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white.withOpacity(0.8),
                                          spreadRadius: 1,
                                          blurRadius: 1,
                                          offset: Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: _imageFile != null
                                          ? Image.file(
                                              File(_imageFile.path),
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(
                                              'assets/images/storeLogo.jpg', fit: BoxFit.cover,),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 3,
                                    right: 3,
                                    child: Container(
                                      padding: EdgeInsetsDirectional.all(4),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle),
                                      child: InkWell(
                                          child: Icon(
                                            Icons.edit,
                                            size: 18,
                                            color: Colors.black,
                                          ),
                                          onTap: () async {
                                            _pickImageFromGallery();
                                          }),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 40,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context).pickYourStoreLogo,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Visibility(
                                    visible: isLogoPicked,
                                    child: Text(
                                      AppLocalizations.of(context).storeLogoRequired,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.only(
                              start: 18, top: 5),
                          child: Row(
                            children: [
                              Text(
                                AppLocalizations.of(context).storeName,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff151515)),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                              start: 18, end: 18, top: 5),
                          child: Container(
                            height: 70,
                            child: Center(
                              child: TextFormField(
                                validator: (input) {
                                  if (input.isEmpty)
                                    return AppLocalizations.of(context).requiredField;
                                  else
                                    return null;
                                },
                                onSaved: (value) {
                                  name = value;
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsetsDirectional.all(5),
                                  hintText: AppLocalizations.of(context).enterStoreName,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide:
                                        BorderSide(color: Color(0xff151515)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide:
                                        BorderSide(color: Color(0xff151515)),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                cursorHeight: 15,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xff151515)),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(start: 18, top: 7),
                          child: Row(
                            children: [
                              Icon(
                                Icons.list,
                                size: 22,
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.only(start: 10),
                                child: Text(
                                  AppLocalizations.of(context).categories,
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.only(start: 20),
                                child: Container(
                                  height: 40,
                                  width:
                                  MediaQuery.of(context).size.width *
                                      0.52,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: isCategorySelected
                                            ? Colors.red
                                            : Color(0xff151515)),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    icon:
                                        Icon(Icons.check, color: Colors.black),
                                    decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      hintText: category ?? "Select Category",
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14),
                                      contentPadding: EdgeInsetsDirectional.all(8.0),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                    value: category,
                                    items: categoriesList
                                        .map<DropdownMenuItem<String>>(
                                            (String value) => DropdownMenuItem(
                                                  child: Text(value),
                                                  value: value,
                                                ))
                                        .toList(),
                                    onChanged: (newValue) {
                                      setState(() {
                                        category = newValue;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(start: 18, top: 28),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 25,
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.only(start: 10),
                                child: Text(
                                  AppLocalizations.of(context).location,
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.only(start: 35),
                                child: Container(
                                  height: 40,
                                  width:
                                  MediaQuery.of(context).size.width *
                                      0.52,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: isLocationPicked
                                            ? Colors.red
                                            : Color(0xff151515)),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: DropdownButtonFormField(
                                    isExpanded: false,
                                    icon:
                                        Icon(Icons.check, color: Colors.black),
                                    decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      hintText: location ?? "Select location",
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14),
                                      contentPadding: EdgeInsetsDirectional.all(8.0),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                    value: location,
                                    items: locationList
                                        .map<DropdownMenuItem<String>>(
                                            (String value) => DropdownMenuItem(
                                                  child: Text(value),
                                                  value: value,
                                                ))
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        location = value;
                                      });
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.only(
                              start: 18, top: size.height * 0.03),
                          child: Row(
                            children: [
                              Text(
                                AppLocalizations.of(context).storeDescription,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff151515)),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                              start: 18, end: 18, top: 10),
                          child: Container(
                            height: size.height * 0.20,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: TextFormField(
                              validator: (input) {
                                if (input.isEmpty)
                                  return AppLocalizations.of(context).requiredField;
                                else
                                  return null;
                              },
                              onSaved: (value) {
                                desc = value;
                              },
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context).enterStoreDescription,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              maxLines: 8,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.only(
                              start: 18,
                              top: size.height * 0.02),
                          child: Row(
                            children: [
                              Text(
                                "Note :",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.only(
                              start: size.width * 0.09, top: 5),
                          child: Text(
                            AppLocalizations.of(context).subStoreRequestNote,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                        isUploading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: brown,
                                ),
                              )
                            : Padding(
                                padding: EdgeInsetsDirectional.only(
                                    start: size.width * 0.07,
                                    end: size.width * 0.07, top: 10),
                                child: ButtonWidget(
                                  buttonHeight: 50,
                                  buttonWidth:
                                      MediaQuery.of(context).size.width,
                                  function: () {
                                    if (_formKey.currentState.validate() &&
                                        _imageFile != null) {
                                      _formKey.currentState.save();
                                      setState(() {
                                        isUploading = true;
                                      });
                                      _handleCreateSubStore();
                                      //////////////////////////////
                                    } else {
                                      setState(() {
                                        logoPickedColor = Colors.red;
                                        isLogoPicked = true;
                                        if (location == null) {
                                          setState(() {
                                            isLocationPicked = true;
                                          });
                                        }
                                        if (category == null) {
                                          setState(() {
                                            isCategorySelected = true;
                                          });
                                        }
                                      });
                                    }
                                  },
                                  roundedBorder: 10,
                                  buttonColor: Color(0xFFb58563),
                                  widget: TextWidget(
                                    text: AppLocalizations.of(context)
                                        .submitSubStoreRequest,
                                    textSize: 15,
                                    textColor: grey,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
