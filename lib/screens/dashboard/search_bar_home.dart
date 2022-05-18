import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:category/api/storeApis.dart';
import 'package:category/modals/apiError.dart';
import 'package:category/modals/apiResponse.dart';
import 'package:category/modals/categoryModel.dart';
import 'package:category/modals/discountModel.dart';
import 'package:category/modals/get_all_stores.dart';
import 'package:category/modals/route_arguments.dart';
import 'package:category/modals/subStoreModel.dart';
import 'package:category/modals/user.dart';
import 'package:category/utils/constant.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class SearchBarHomeScreen extends StatefulWidget {
  AllStoreItem store;
  SearchBarHomeScreen({this.store});

  @override
  _SearchBarHomeScreenState createState() => _SearchBarHomeScreenState();
}

class _SearchBarHomeScreenState extends State<SearchBarHomeScreen> {

  Welcome _userInfo;

  List<AllStoreItem> fixItems = [];
  List<AllStoreItem> filterItems = [];

  Future<void> handlegetAllStores() async {
    _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
    fixItems.clear();
    filterItems.clear();
    setState(() {});
    await getAllStores(token: _userInfo.token).then((value) {
      fixItems.addAll((value.Data as GetAllStoreModel).data);
      filterItems = ((value.Data as GetAllStoreModel).data);
    });
    setState(() {});
  }

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) handlegetAllStores();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsetsDirectional.all(8.0),
          child: Container(
            height: 45,
            decoration: BoxDecoration(
              // color: Color(0xFFF0EFEF),
              color: Colors.blueGrey[50],
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey[500]),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 150,
                    child: TextFormField(
                      onChanged: (input) {
                        if (input.isEmpty) {
                          filterItems = fixItems;
                        } else {
                          filterItems = fixItems.where((element) => element.storeName.toLowerCase().contains(input.toLowerCase())).toList();
                        }
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        hintText: "Enter Store Name",
                        hintStyle: TextStyle(fontSize: 13, color: Colors.grey[500]),

                      ),
                      style: TextStyle(),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {
                SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                  if (mounted) handlegetAllStores();
                });
              },
              icon: Icon(Icons.refresh))
        ],
      ),
      body: filterItems.isNotEmpty
          ? Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                //height: Responsive.isMobile(context)?MediaQuery.of(context).size.height / 0.9 : MediaQuery.of(context).size.height * 0.7,
                  width: double.infinity,
                  child: GridView.builder(
                      itemCount: filterItems.length,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Welcome _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));

                            Navigator.of(context).pushNamed(
                                '/SubStoreDetails',
                                arguments: SubStoreH(
                                  userId: _userInfo.userData.id,
                                  id: filterItems[index].id,
                                  storeName: filterItems[index].storeName,
                                  storeCategory: filterItems[index].storeCategory,
                                  storeLogo: filterItems[index].storeLogo,
                                ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(color: Colors.brown[100], borderRadius: BorderRadius.circular(20)),
                              height: 50,
                              width: 100,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
                                    child: CachedNetworkImage(
                                        height: 110,
                                        width: double.infinity,
                                        fit: BoxFit.fitWidth,
                                        imageUrl: filterItems[index].storeLogo,
                                        placeholder: (context, url) => Center(child: CircularProgressIndicator(color: Colors.brown,)),
                                        errorWidget: (context, url, error) => Image.asset("assets/images/495px-No-Image-Placeholder.svg.png",fit: BoxFit.cover,)),
                                  ),

                                  /*Image.network(
                                        filterItems[index].storeLogo!,
                                        width: double.infinity,
                                        fit: BoxFit.fitWidth,
                                        height: Responsive.isMobile(context)?90 : 150,
                                      )*/

                                  SizedBox(
                                    height: 5,
                                  ),
                                  Spacer(),
                                  Text(
                                    filterItems[index].storeName,
                                    style: TextStyle(
                                        fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      })),
            ),
          ),
        ],
      )
          : Center(
          child: CircularProgressIndicator(
            color: Colors.brown,
          )),
    );
  }
}
