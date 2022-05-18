import 'dart:convert';
import 'dart:io';
import 'package:category/api/storeApis.dart';
import 'package:category/modals/apiError.dart';
import 'package:category/modals/apiResponse.dart';
import 'package:category/modals/route_arguments.dart';
import 'package:category/modals/user.dart';
import 'package:category/utils/constant.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateDiscountOffer extends StatefulWidget {
  RouteArguments routeArguments;
  CreateDiscountOffer({this.routeArguments});

 /* String storeId;
  String prodId;

  CreateDiscountOffer({this.prodId, this.storeId});*/
  @override
  _CreateDiscountOfferState createState() => _CreateDiscountOfferState();
}

class _CreateDiscountOfferState extends State<CreateDiscountOffer> {
  final ImagePicker _picker = ImagePicker();
  File uploadedImage;
  bool isErrorPickingImage = false;
  bool isLoading = false;
  dynamic _pickImageError;
  String chosenDiscount;
  Color imageContainerBorder = Colors.black;
  Color discountBorderColor = Colors.black;
  Color dateBorderColor = Colors.black;

  Welcome userInfo;
  DateTime _dateTime1;
  ApiResponse _apiResponse = ApiResponse();

  _pickImageFromGallery({ImageSource imageSource}) async {
    try {
      final _pickedFile = await _picker.getImage(
        source: imageSource,
        imageQuality: 60,
      );
      setState(() {
        uploadedImage = File(_pickedFile.path);
        imageContainerBorder = Colors.black;
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

  handleDiscountCreation()async{
    userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
    print("User token :::::::::::::::::::::::::: ${userInfo.token}");
    _apiResponse = await createDiscount(token: userInfo.token, storeId: widget.routeArguments.param1, discount: chosenDiscount, discountImage:uploadedImage, endingDate: _dateTime1.toString(), prodId: widget.routeArguments.param2, prodName: widget.routeArguments.param3);
    if((_apiResponse.ApiError as ApiError) == null){
      setState(() {
        isLoading = false;
      });
      showInSnackBar("Sale created successfully");
    }else{
      print("MASLA PARR GYA HAI");
    }
  }

  @override
  void initState() {
    print(widget.routeArguments.param1 + widget.routeArguments.param2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Discount Offer",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.all(16.0),
              child: InkWell(
                onTap: () {
                  _pickImageFromGallery(imageSource: ImageSource.gallery);
                },
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: imageContainerBorder)),
                  width: double.infinity,
                  child: uploadedImage == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset("assets/images/add.png"),
                            Text(
                              "Upload Offering Banner",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w400),
                            )
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            uploadedImage,
                            fit: BoxFit.cover,
                          )),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.all(16),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Choose Discount Offer",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "Up to",
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 13),
                        contentPadding: EdgeInsetsDirectional.all(8.0),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: discountBorderColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: discountBorderColor,
                            )),
                      ),
                      value: chosenDiscount,
                      items: <String>[
                        '10%',
                        "20%",
                        "30%",
                        "40%",
                        "50%",
                        "60%",
                        "70%",
                        "80%"
                      ]
                          .map<DropdownMenuItem<String>>(
                              (String value) => DropdownMenuItem(
                                    child: Text(value),
                                    value: value,
                                  ))
                          .toList(),
                      onChanged: (newValue) {
                        setState(() {
                          discountBorderColor =  Colors.black;
                          chosenDiscount = newValue;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Ending Date",
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 32,
                        padding: EdgeInsetsDirectional.only(start: 8,),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: dateBorderColor)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _dateTime1 == null
                                  ? "No date picked"
                                  : "${_dateTime1.toLocal()}".split(' ')[0],
                              style: TextStyle(fontSize: 13),
                            ),
                            IconButton(
                                onPressed: () {
                                  showDatePicker(
                                          context: context,
                                          initialDate: _dateTime1 == null
                                              ? DateTime.now()
                                              : _dateTime1,
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2022))
                                      .then((date) {
                                    setState(() {
                                      dateBorderColor =   Colors.black;
                                      _dateTime1 = date;
                                    });
                                  });
                                },
                                icon: Icon(
                                  Icons.calendar_today_outlined,
                                  color: brown,
                                ))
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: brown,
                    ),
                  )
                : InkWell(
                    onTap: () {
                      if (uploadedImage == null) {
                        setState(() {
                          imageContainerBorder = Colors.red;
                        });
                      }
                      if (chosenDiscount == null) {
                        setState(() {
                          discountBorderColor = Colors.red;
                        });
                      }
                      if(_dateTime1 == null){
                        setState(() {
                          dateBorderColor = Colors.red;
                        });
                      }else{
                        setState(() {
                          isLoading = true;
                        });
                        handleDiscountCreation();
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
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
