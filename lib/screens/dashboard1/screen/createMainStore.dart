import 'dart:convert';
import 'dart:io';
import 'package:category/api/auth_apis.dart';
import 'package:category/modals/apiError.dart';
import 'package:category/modals/apiResponse.dart';
import 'package:category/modals/categoryModel.dart';
import 'package:category/modals/create_category_model.dart';
import 'package:category/modals/mainStoreModal.dart';
import 'package:category/modals/user.dart';
import 'package:category/screens/dashboard1/screen/showStatusMessage.dart';
import 'package:category/screens/dashboard1/widgets/buttonWidget.dart';
import 'package:category/screens/dashboard1/widgets/textWidget.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:flutter/material.dart';
import 'package:category/utils/constant.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:category/api/createStoreApi.dart';

import '../../../main.dart';

class GenderModel {
  GenderSpecific genderSpecific;
  bool isSelected;

  GenderModel({this.genderSpecific, this.isSelected});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is GenderModel &&
              runtimeType == other.runtimeType &&
              genderSpecific.index == other.genderSpecific.index &&
              isSelected == other.isSelected;

  @override
  int get hashCode => genderSpecific.index.hashCode ^ isSelected.hashCode;
}

class MakeMainStore extends StatefulWidget {
  final GetCategory getCategory;
  MainStore mainStore;

  MakeMainStore({this.mainStore, this.getCategory});
  @override
  _MakeMainStoreState createState() => _MakeMainStoreState();
}

class _MakeMainStoreState extends State<MakeMainStore> {
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
  bool isCategoryGenderSpecific = false;
  bool IsComingFromCategoryScreen = false;
  final TextEditingController textEditingController = TextEditingController();
  List<String> subCategoriesTags = [];
  List<int> genTypeList = [];
  String category_name;

  List<GenderModel> _newGenderTypeList = [];
  List<Widget> _newGenderTypeWidgetList = [];


  List<GenderModel> _genderSpecificList = [
    GenderModel(genderSpecific: GenderSpecific.Men, isSelected: false),
    GenderModel(genderSpecific: GenderSpecific.Women, isSelected: false),
    GenderModel(genderSpecific: GenderSpecific.Kids, isSelected: false),
  ];

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _descController = TextEditingController();

  String location;
  String gender;

  final ImagePicker _picker = ImagePicker();
  ApiResponse _apiResponse = ApiResponse();
  Welcome userInfo;

  showInSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _handleCreateMainStore() async {
    if(_newGenderTypeList.isEmpty){
      return;
    }
    userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
    print("User's Token ::::::::::::::::::::::::::::: ${userInfo.token}");
    List<int> genderIndexes = [];
    _newGenderTypeList.where((element) => element.isSelected).forEach((element) {
      genderIndexes.add(element.genderSpecific.index);
    });
    gender = genderIndexes.join(",");
    _apiResponse = await uploadData(
        image: File(_imageFile.path),
        name: name,
        location: location,
        category: category,
        desc: desc,
        gender: gender ?? "Other",
        token: userInfo.token);
    if ((_apiResponse.ApiError as ApiError) == null) {
      SharedPrefs().createdMainStore = true;
      SharedPrefs().mainStoreStatus = false;

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/ShowStatusMessagePartner',
        ModalRoute.withName('/ShowStatusMessagePartner'),
      );

      /*Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context){
        return StatusMessage();
      }), (route) => false);*/
      /*Navigator.pushNamedAndRemoveUntil(
        context,
        '/dashboardPartner',
        ModalRoute.withName('/dashboardPartner'),
      );*/
    } else {
      showInSnackBar((_apiResponse.ApiError as ApiError).error);
      setState(() {
        isUploading = false;
      });
    }
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

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async{
      if(widget.mainStore!=null){
        category = widget.mainStore.store.storeCategory;
        name = widget.mainStore.store.storeName;
        desc = widget.mainStore.store.storeDescription;
        _nameController.text = name;
        _descController.text = desc;
        location = widget.mainStore.store.location;
        isLogoPicked = false;
        isLocationPicked = false;
        isCategorySelected = false;
        //_imageFile = await fileFromImageUrl(widget.mainStore.store.storeLogo) as PickedFile;
        setState(() {
        });
      }

    });

    super.initState();
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('You want to go back on Customer Screen?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          TextButton(
            onPressed: () async{
              var role =   SharedPrefs().userRole;
              Welcome userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));

              if(role == "partner"){
                valueNotifier.value = false;
                SharedPrefs().userRole = "customer";
                await updateRole("customer", userInfo.token);
                valueNotifier.notifyListeners();
                Navigator.of(context).pushNamed('/dashboard');

              }else{
                valueNotifier.value = true;
                SharedPrefs().userRole = "partner";
                await updateRole("partner", userInfo.token);
                valueNotifier.notifyListeners();
              }
              },
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: TextWidget(
              text: AppLocalizations.of(context).createMainStore,
              textSize: 18,
              textColor: primary,
              isBold: true,
            ),
            centerTitle: true,
            elevation: 0,
          ),
          backgroundColor: Colors.white,
          body: Padding(
            padding: EdgeInsetsDirectional.only(top: size.height * 0.02),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                        start: 20,end : 20, top: 10, bottom: 10),
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
                                borderRadius: BorderRadius.all(
                                    Radius.circular(15)),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        Colors.white.withOpacity(0.8),
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(10),
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
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
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
                        start: size.width * 0.08,
                        top: size.height * 0.02),
                    child: Visibility(
                      visible: isErrorPickingImage,
                      child: Text(
                        "${_pickImageError}",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 10,
                          fontWeight: FontWeight.w300,
                        ),
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
                          controller: _nameController,
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
                            contentPadding: EdgeInsets.all(5),
                            hintText: name ?? AppLocalizations.of(context).enterStoreName,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(
                                  color: Color(0xff151515)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(
                                  color: Color(0xff151515)),
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
                    padding: const EdgeInsetsDirectional.only(start: 18, top: 18),
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
                                  color: isCategorySelected ? Colors.red:Color(0xff151515)),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              icon: Icon(Icons.check,
                                  color: Colors.black),
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                hintText:
                                    category ?? AppLocalizations.of(context).selectCategory,
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14),
                                contentPadding: EdgeInsetsDirectional.all(8.0),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(6),
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                                focusedErrorBorder:
                                    OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(6),
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              value: category,
                              items: categoriesList
                                  .map<DropdownMenuItem<String>>(
                                      (String value) =>
                                          DropdownMenuItem(
                                            child: Text(value),
                                            value: value,
                                          ))
                                  .toList(),
                              onChanged: (newValue) {

                                  category = newValue;
                                  int ind = categoriesObj.category.indexWhere((element) => element.category.category == category);
                                  if(ind!= null){
                                    categoriesObj.category[ind].category.genderSpecific? isCategoryGenderSpecific = true : isCategoryGenderSpecific = false;
                                     if(isCategoryGenderSpecific){
                                       List<int> genList = [];
                                       genList.addAll(List.from(categoriesGender[category]));
                                       if (genList.length == 4) {
                                         _newGenderTypeList.clear();
                                         _newGenderTypeList.addAll(_genderSpecificList);

                                       } else {
                                         List<GenderModel> list = [];
                                         genList.forEach((element) {
                                           list.add(
                                               GenderModel(genderSpecific: GenderSpecific.values[element], isSelected: false));
                                         });
                                         _newGenderTypeList.clear();
                                         _newGenderTypeList.addAll(list);
                                       }
                                     }
                                  }

                                  setState(() {});
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
                                  color: isLocationPicked ? Colors.red:Color(0xff151515)),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: DropdownButtonFormField(
                              isExpanded: false,
                              icon: Icon(Icons.check,
                                  color: Colors.black),
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                hintText:
                                    location ?? AppLocalizations.of(context).selectLocation,
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14),
                                contentPadding: EdgeInsetsDirectional.all(8.0),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(30),
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
                                      (String value) =>
                                          DropdownMenuItem(
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
                  Visibility(
                    visible: isCategoryGenderSpecific,
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: _newGenderTypeList
                            .map(
                              (e) => Container(
                              height: 80,
                              width: 96,
                              child: Row(
                                children: [
                                  Theme(
                                    data: ThemeData(unselectedWidgetColor: Colors.brown),
                                    child: Visibility(
                                      child: Checkbox(
                                        activeColor: Colors.brown,
                                        checkColor: Colors.white,
                                        value: e.isSelected,
                                        onChanged: (bool value) {
                                          setState(() {
                                                /*  var gender = _newGenderTypeList
                                                      .firstWhere((element) => element.genderSpecific == e.genderSpecific);*/
                                                  e.isSelected = !e.isSelected;



                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Text(
                                    e.genderSpecific.name,
                                    style: TextStyle(color: Colors.black),
                                  )
                                ],
                              )),
                        )
                            .toList(),
                      ),
                    ),
                  ),



                  /*Visibility(
                    visible: isCategoryClothes,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(start: 18, top: 28),
                      child: Row(
                        children: [
                          Icon(
                            Icons.person,
                            size: 25,
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.only(start: 10),
                            child: Text(
                              AppLocalizations.of(context).gender,
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.only(start: 45),
                            child: Container(
                              height: 40,
                              width:
                              MediaQuery.of(context).size.width *
                                  0.52,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: isLocationPicked ? Colors.red:Color(0xff151515)),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: DropdownButtonFormField(
                                isExpanded: false,
                                icon: Icon(Icons.check,
                                    color: Colors.black),
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText:
                                  gender ?? AppLocalizations.of(context).selectGender,
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14),
                                  contentPadding: EdgeInsetsDirectional.all(8.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(30),
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(30),
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
                                value: gender,
                                items: genderList
                                    .map<DropdownMenuItem<String>>(
                                        (String value) =>
                                        DropdownMenuItem(
                                          child: Text(value),
                                          value: value,
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    gender = value;
                                  });
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),*/

                  Padding(
                    padding: EdgeInsetsDirectional.only(
                        start: 18,
                        top: size.height * 0.03),
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
                        controller: _descController,
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
                          hintText: desc ?? AppLocalizations.of(context).enterStoreDescription,
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
                    padding: EdgeInsets.only(
                        left: 18,
                        top: 5),
                    child: Text(
                      "Note :",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 30, top: 5),
                      child: Text(
                        AppLocalizations.of(context).subStoreRequestNote,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.only(
                        start: size.width * 0.07,
                        end: size.width * 0.07),
                    child: isUploading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: brown,
                            ),
                          )
                        : ButtonWidget(
                            buttonHeight: 45,
                            buttonWidth:
                                MediaQuery.of(context).size.width,
                            function: () async {

                              if (_formKey.currentState.validate() &&
                                  _imageFile != null) {
                                _formKey.currentState.save();
                                setState(() {
                                  isUploading = true;
                                });
                                await _handleCreateMainStore();
                              } else {
                                setState(() {
                                  logoPickedColor = Colors.red;
                                  isLogoPicked = true;
                                  if(location == null){
                                    setState(() {
                                       isLocationPicked = true;
                                    });
                                  }
                                  if(category == null){
                                    setState(() {
                                      isCategorySelected = true;
                                    });
                                  }
                                });
                              }
                            },
                            roundedBorder: 10,
                            buttonColor: brown,
                            widget: TextWidget(
                              text: AppLocalizations.of(context).createStore,
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
    );
  }
}

