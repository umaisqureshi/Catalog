import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:category/api/storeApis.dart';
import 'package:category/modals/apiError.dart';
import 'package:category/modals/apiResponse.dart';
import 'package:category/modals/route_arguments.dart';
import 'package:category/modals/user.dart';
import 'package:category/utils/constant.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:category/widgets/noConnection.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:category/screens/dashboard1/widgets/textWidget.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class AddProduct extends StatefulWidget {
  RouteArguments routeArguments;
  //String storeId;

  AddProduct({this.routeArguments});

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {

  // create some values
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

// ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  bool lightTheme = true;
  /*Color currentColor = Colors.limeAccent;*/
  List<Color> currentColors = [Colors.limeAccent, Colors.green];

/*  void changeColor(Color color) => setState(() => currentColor = color);*/
  void changeColors(List<Color> colors) =>
      setState(() => currentColors = colors);


  Future<void> copyToClipboard(String input) async {
    String textToCopy;
    final hex = input.toUpperCase();
    if (hex.startsWith('FF') && hex.length == 8) {
      textToCopy = hex.replaceFirst('FF', '');
    } else {
      textToCopy = hex;
    }
    await Clipboard.setData(ClipboardData(text: '#$textToCopy'));
  }



  final ImagePicker _picker = ImagePicker();
  dynamic _pickImageError;
  bool isErrorPickingImage = false;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String productName = '';
  String productDesc = '';
  String price = '';
  String stock = '';
  String size = '';
  int color;
  String weight = '';
  Color uploadOutlineColor = Colors.black;
  Color productNameOutLineColor = Colors.black;
  Color productDescOutlineColor = Colors.black;
  Color productPriceOutlineColor = Colors.black;
  Color productStockOutlineColor = Colors.black;
  Color productCategoryOutlineColor = Colors.black;
  Color productFilterOutlineColor = Colors.black;
  final productNameController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();
  final sizeController = TextEditingController();
  final colorController = TextEditingController();
  final weightController = TextEditingController();

  ApiResponse _apiResponse = ApiResponse();
  Welcome userInfo;

  String filters;
  String category;

  bool isInternetAvailable = true;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  List<File> _productImages = [];

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
    // Platform messages may fail, so we use a try/catch PlatformException.
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

  showInSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _handleProductCreation() async {
    print("User token :::::::::::::::::::::::::: ${userInfo.token}");
    _apiResponse = await addProducts(
        token: userInfo.token,
        desc: descController.text,
        category: category,
        name: productNameController.text,
        filter: filters,
        images: _productImages,
        price: priceController.text,
        stock: stockController.text,
        storeId: widget.routeArguments.param1,
        size: sizeController.text,
        color: color,
        weight: weightController.text,



    );


    if ((_apiResponse.ApiError as ApiError) == null) {
      showInSnackBar(AppLocalizations.of(context).productSuccessfullyCreated);
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
 /* getCategoriesData() async {
    ApiResponse _apiRes = ApiResponse();
    _apiRes = await getCategories(token: userInfo.token);
    if ((_apiRes.ApiError as ApiError) == null) {
      categoriesObj = _apiRes.Data;
      category = categoriesObj.category[0].category.category;
      filters = categoriesObj.category[0].category.categoryFilters[0];
      
      for (int i = 0; i < categoriesObj.category.length; i++) {
        categoriesList.add(categoriesObj.category[i].category.category);

        categoriesFilter.addAll({
          categoriesObj.category[i].category.category:
              categoriesObj.category[i].category.categoryFilters
        });
      }
      setState(() {});
    } else {
      showInSnackBar((_apiResponse.ApiError as ApiError).error);
    }
  }*/

  @override
  void initState() {
    userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
    print(widget.routeArguments.param2);
    filters = categoriesObj.category.firstWhere((element) => element.category.category == widget.routeArguments.param2).category.categoryFilters[0];
    category = categoriesObj.category.firstWhere((element) => element.category.category == widget.routeArguments.param2).category.category;
    print("categorytest ${category}");
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    super.initState();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).addProduct,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isInternetAvailable ? Stack(
          children: [
            ListView(
              children: [
                SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.07,
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.only(
                              start: MediaQuery.of(context).size.width * 0.06),
                          child: Text(
                            AppLocalizations.of(context).productName,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff151515)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                              start: 26, end: 17, top: 10),
                          child: Container(
                            height: 50,
                            child: Center(
                              child: TextFormField(
                                controller: productNameController,
                                onSaved: (value) {
                                  productName = value;
                                },
                                decoration: InputDecoration(
                                  hintText: AppLocalizations.of(context)
                                      .enterProductName,
                                  contentPadding: EdgeInsetsDirectional.all(8),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(
                                        color: productNameOutLineColor),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(
                                        color: productNameOutLineColor),
                                  ),
                                ),
                                cursorHeight: 15,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                              start: 26, top: 28),
                          child: Row(
                            children: [
                              Icon(
                                Icons.list,
                                size: 22,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsetsDirectional.only(start: 10),
                                child: Text(
                                  AppLocalizations.of(context).categories,
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding:
                                    const EdgeInsetsDirectional.only(end: 15),
                                child: Container(
                                  height: 40,
                                  width:
                                      MediaQuery.of(context).size.width * 0.54,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: productCategoryOutlineColor),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  /*child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(widget.routeArguments.param2),
                                  ),*/



                                  child: DropdownButtonFormField<String>(

                                    isExpanded: true,
                                    icon:
                                        Icon(Icons.check, color: Colors.black),
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      hintText: category,
                                      hintStyle: TextStyle(
                                        color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14
                                      ),
                                      contentPadding: EdgeInsets.all(8.0),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          borderSide: BorderSide(
                                            color: Colors.transparent,
                                          )),
                                    ),
                                    value: category,
                                    items: categoriesList
                                        .map<DropdownMenuItem<String>>(
                                            (String value) => DropdownMenuItem(
                                                  child: Text(value,style: TextStyle(color: Colors.black),),
                                                  value: value,
                                                ))
                                        .toList(),
                                    onChanged: null
                                    /* (newValue) {
                                      setState(() {
                                        category = newValue;
                                        filters = categoriesFilter[newValue][0];
                                        print("${categoriesFilter[newValue]}");
                                      });
                                    },*/
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                              start: 26, top: 28),
                          child: Row(
                            children: [
                              Icon(
                                Icons.filter_alt,
                                size: 22,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsetsDirectional.only(start: 10),
                                child: Text(
                                  AppLocalizations.of(context).filters,
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 15),
                                child: Container(
                                  height: 40,
                                  width:
                                      MediaQuery.of(context).size.width * 0.55,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: productFilterOutlineColor),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: DropdownButtonFormField(
                                    isExpanded: false,
                                    icon:
                                        Icon(Icons.check, color: Colors.black),
                                    decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      hintText: filters,
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                      contentPadding: EdgeInsets.all(8.0),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          borderSide: BorderSide(
                                            color: Colors.transparent,
                                          )),
                                    ),
                                    value: filters,
                                    items: categoriesFilter[category]
                                        .map<DropdownMenuItem<String>>(
                                            (String value) => DropdownMenuItem(
                                                  child: Text(value),
                                                  value: value,
                                                ))
                                        .toList(),
                                    onChanged: (newValue) {
                                      setState(() {
                                        filters = newValue;
                                      });
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.only(
                              start: MediaQuery.of(context).size.width * 0.06),
                          child: Text(
                            AppLocalizations.of(context).productDescription,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff151515)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                              start: 20, end: 13, top: 10),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.20,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: productDescOutlineColor),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.only(
                                start: 16,
                                end: 16,
                                top: 5,
                              ),
                              //child: Text("Zombie ipsum reversus ab viral inferno, nam rick grimes malum cerebro. De carne lumbering animata corpora quaeritis. Summus brains sit​​, morbo vel maleficia? De apocalypsi gorger omero undead survivor dictum mauris. Hi mindless mortuis soulless creaturas, imo evil stalking monstra adventus resi dentevil vultus comedat cerebella viventium. Qui animated corpse, cricket bat max brucks terribilem incessu zomby.", style: TextStyle(fontSize: 13, height: 1.5,), textAlign: TextAlign.left,),
                              child: TextFormField(
                                controller: descController,
                                onSaved: (value) {
                                  productDesc = value;
                                },
                                decoration: InputDecoration(
                                  hintText: AppLocalizations.of(context)
                                      .enterProductDescription,
                                  border: InputBorder.none,
                                ),
                                maxLines: 8,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20,top: 17,),
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context).productPrice,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff151515)),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    height: 40,
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: productPriceOutlineColor),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                          start: 10, end: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.25,
                                            height: MediaQuery.of(context)
                                                .size
                                                .height,
                                            child: Padding(
                                              padding:
                                                  EdgeInsetsDirectional.only(
                                                      bottom:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.01),
                                              child: Center(
                                                child: TextFormField(
                                                  onSaved: (value) {
                                                    price = value.toString();
                                                  },
                                                  controller: priceController,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                      contentPadding:
                                                          EdgeInsetsDirectional
                                                              .only(bottom: 12),
                                                      border: InputBorder.none,
                                                      focusedBorder: InputBorder
                                                          .none,
                                                      enabledBorder: InputBorder
                                                          .none,
                                                      hintText:
                                                          AppLocalizations.of(
                                                                  context)
                                                              .productPrice,
                                                      hintStyle: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: Colors.black)),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "USD",
                                            style: TextStyle(
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 40,),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                        end: 10),
                                    child: Text(
                                      AppLocalizations.of(context).productStock,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff151515)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    height: 40,
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: productStockOutlineColor),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                          bottom: 5.0, start: 4),
                                      child: Center(
                                        child: TextFormField(
                                          onSaved: (value) {
                                            stock = value.toString();
                                          },
                                          controller: stockController,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsetsDirectional.only(
                                                      bottom: 12),
                                              border: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              hintText: AppLocalizations.of(
                                                      context)
                                                  .stockTextFieldPlaceholder,
                                              hintStyle: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20,top: 17,),
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context).productSize,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff151515)),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    height: 40,
                                    width:
                                    MediaQuery.of(context).size.width * 0.4,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: productPriceOutlineColor),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                          start: 10, end: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width *
                                                0.25,
                                            height: MediaQuery.of(context)
                                                .size
                                                .height,
                                            child: Padding(
                                              padding:
                                              EdgeInsetsDirectional.only(
                                                  bottom:
                                                  MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                      0.01),
                                              child: Center(
                                                child: TextFormField(
                                                  onSaved: (value) {
                                                    size = value.toString();
                                                  },
                                                  controller: sizeController,
                                                  keyboardType:
                                                  TextInputType.number,
                                                  decoration: InputDecoration(
                                                      contentPadding:
                                                      EdgeInsetsDirectional
                                                          .only(bottom: 12),
                                                      border: InputBorder.none,
                                                      focusedBorder: InputBorder
                                                          .none,
                                                      enabledBorder: InputBorder
                                                          .none,
                                                      hintText:
                                                      AppLocalizations.of(
                                                          context)
                                                          .productSize,
                                                      hintStyle: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                          FontWeight.normal,
                                                          color: Colors.black)),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "Inches",
                                            style: TextStyle(
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 40,),
                              Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                        end: 10),
                                    child: Text(
                                      AppLocalizations.of(context).productColor,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff151515)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    height: 40,
                                    width:
                                    MediaQuery.of(context).size.width * 0.4,
                                    /*decoration: BoxDecoration(
                                      border: Border.all(
                                          color: productStockOutlineColor),
                                      borderRadius: BorderRadius.circular(6),
                                    ),*/
                                    child:
                                    RaisedButton(
                                      color: pickerColor,
                                        onPressed: (){
                                      showDialog(context: context,
                                          builder: (context){
                                            return AlertDialog(
                                              title: Text('Select Color',style: TextStyle(color: Colors.white),),
                                              content: BlockPicker(
                                               pickerColor: currentColor,
                                               onColorChanged: changeColor,
                                             ),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: const Text('Got it'),
                                                  onPressed: () {
                                                    setState(() => currentColor = pickerColor);
                                                    Navigator.of(context).pop();
                                                    String colorLaoshe = pickerColor.toString();
                                                    List<String> splittedColorResponse = colorLaoshe.split(' Color(');

                                                    colorLaoshe = splittedColorResponse[1];
                                                    String colorSt = colorLaoshe.substring(0, 10);
                                                    color = int.parse(colorSt);
                                                    print("Splitted Color : : : : : : : : : $color");
                                                    print("Current Color: ${currentColor}");
                                                    print("Picker Color: $pickerColor");
                                                  },
                                                ),
                                              ],
                                            );
                                          });
                                    }),
                                    /*Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                          bottom: 5.0, start: 4),
                                      child: Center(
                                        child: TextFormField(
                                          onSaved: (value) {
                                            color = value.toString();
                                          },
                                          controller: colorController,
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(
                                              contentPadding:
                                              EdgeInsetsDirectional.only(
                                                  bottom: 12),
                                              border: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              hintText: AppLocalizations.of(
                                                  context)
                                                  .productColor,
                                              hintStyle: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black)),
                                        ),
                                      ),
                                    ),*/
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20,top: 17,),
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context).productWeight,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff151515)),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    height: 40,
                                    width:
                                    MediaQuery.of(context).size.width * 0.4,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: productPriceOutlineColor),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                          start: 10, end: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width *
                                                0.25,
                                            height: MediaQuery.of(context)
                                                .size
                                                .height,
                                            child: Padding(
                                              padding:
                                              EdgeInsetsDirectional.only(
                                                  bottom:
                                                  MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                      0.01),
                                              child: Center(
                                                child: TextFormField(
                                                  onSaved: (value) {
                                                    weight = value.toString();
                                                  },
                                                  controller: weightController,
                                                  keyboardType:
                                                  TextInputType.number,
                                                  decoration: InputDecoration(
                                                      contentPadding:
                                                      EdgeInsetsDirectional
                                                          .only(bottom: 12),
                                                      border: InputBorder.none,
                                                      focusedBorder: InputBorder
                                                          .none,
                                                      enabledBorder: InputBorder
                                                          .none,
                                                      hintText:
                                                      AppLocalizations.of(
                                                          context)
                                                          .productWeight,
                                                      hintStyle: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                          FontWeight.normal,
                                                          color: Colors.black)),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "Grams",
                                            style: TextStyle(
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.only(
                              start: MediaQuery.of(context).size.width * 0.06,
                              top: 17),
                          child: Text(
                            AppLocalizations.of(context).uploadImages,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff151515)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                              start: 22, end: 13, top: 10),
                          child: Container(
                            height: 110,
                            decoration: BoxDecoration(
                              border: Border.all(color: uploadOutlineColor),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                          start: 19, top: 18),
                                      child: InkWell(
                                          onTap: () {
                                            dialog1(context);
                                          },
                                          child: Icon(
                                            Icons.image,
                                            size: 55,
                                          )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                          top: 10, start: 18),
                                      child: Text(
                                        AppLocalizations.of(context).clickHere,
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                      start: 20),
                                  child: Container(
                                    height: 80,
                                    width: 1,
                                    color: Colors.black45,
                                  ),
                                ),
                                Container(
                                  height: 90,
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _productImages.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        height: 90,
                                        width: 90,
                                        margin: EdgeInsetsDirectional.only(
                                            end: 0, start: 10),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.black, width: 1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.file(
                                                  _productImages[index],
                                                  fit: BoxFit.cover),
                                            ),
                                            Positioned(
                                              right: 3,
                                              top: 3,
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    _productImages
                                                        .removeAt(index);
                                                  });
                                                },
                                                child: Icon(
                                                  Icons.cancel,
                                                  color: brown,
                                                  size: 22,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: brown,
                                ),
                              )
                            : Center(
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                      top: 20.0),
                                  child: InkWell(
                                    onTap: () {
                                      if (productNameController.text.isEmpty) {
                                        setState(() {
                                          productNameOutLineColor = Colors.red;
                                        });
                                      }
                                      if (descController.text.isEmpty) {
                                        setState(() {
                                          productDescOutlineColor = Colors.red;
                                        });
                                      }
                                      if (priceController.text.isEmpty) {
                                        setState(() {
                                          productPriceOutlineColor = Colors.red;
                                        });
                                      }
                                      if (stockController.text.isEmpty) {
                                        setState(() {
                                          productStockOutlineColor = Colors.red;
                                        });
                                      }
                                      if (productNameController
                                              .text.isNotEmpty &&
                                          descController.text.isNotEmpty &&
                                          priceController.text.isNotEmpty &&
                                          stockController.text.isNotEmpty) {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        _handleProductCreation();
                                      } else {
                                        showInSnackBar(
                                            AppLocalizations.of(context)
                                                .fillTheRequiredFields);
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Color(0xFFb58563)),
                                      height: 40,
                                      width: 220,
                                      child: Center(
                                          child: Text(
                                        AppLocalizations.of(context).save,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      )),
                                    ),
                                  ),
                                ),
                              ),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ) : NoInternet(),
      ),
    );
  }

  _pickImageFromGallery({ImageSource imageSource}) async {
    try {
      final _pickedFile = await _picker.getImage(
        source: imageSource,
        imageQuality: 60,
      );
      setState(() {
        _productImages.add(File(_pickedFile.path));
        Navigator.of(context).pop();
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
        isErrorPickingImage = true;
      });
    }
  }

  dialog1(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                width: size.width * 0.8,
                height: size.height * 0.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Color(0xFF707070)),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.only(top: size.height * 0.01),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.only(
                                start: size.width * 0.05, top: 10),
                            child: TextWidget(
                              text: AppLocalizations.of(context)
                                  .selectImageSource,
                              textColor: Color(0xFF0f1013),
                              textSize: 15,
                              isBold: true,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.only(end: 10),
                            child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.close,
                                  color: Color(0xFFFA0606),
                                )),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.only(top: size.height * 0.05),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              _pickImageFromGallery(
                                  imageSource: ImageSource.gallery);
                            },
                            child: Container(
                              width: size.width * 0.3,
                              height: size.height * 0.06,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color:
                                          Color(0xFF0f1013).withOpacity(0.2)),
                                  color: Colors.white),
                              child: Center(
                                child: TextWidget(
                                  text: AppLocalizations.of(context).gallery,
                                  textSize: 14,
                                  textColor: Colors.black,
                                  isBold: true,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _pickImageFromGallery(
                                  imageSource: ImageSource.camera);
                            },
                            child: Container(
                              width: size.width * 0.3,
                              height: size.height * 0.06,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color:
                                          Color(0xFF0f1013).withOpacity(0.2)),
                                  color: Colors.white),
                              child: Center(
                                child: TextWidget(
                                  text: AppLocalizations.of(context).camera,
                                  textSize: 14,
                                  textColor: Colors.black,
                                  isBold: true,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
