import 'package:category/screens/dashboard1/widgets/buttonWidget.dart';
import 'package:category/screens/dashboard1/widgets/textWidget.dart';
import 'package:flutter/material.dart';
import 'package:category/screens/dashboard1/widgets/tileWidget.dart';
import 'package:category/utils/constant.dart';

class StorePreference extends StatefulWidget {
  @override
  _StorePreferenceState createState() => _StorePreferenceState();
}

class _StorePreferenceState extends State<StorePreference> {
  List<String> categories = [
    'Men',
    'Women',
    'Kids',
  ];
  int selectedCategories = 0;

  void changeIndex(int index) {
    selectedCategories = index;
  }

  List<String> filters = [
    'Hand Bag',
    'Shoulder Bag',
    'Hobo Bag',
  ];
  int selectedfilters = 0;

  void changeIndex1(int index) {
    selectedfilters = index;
  }

  List<String> filters1 = [
    'Mobile',
    'Laptop',
    'Computer',
    'Speaker',
  ];
  int selectedfilters1 = 0;

  void changeIndex2(int index) {
    selectedfilters1 = index;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: TextWidget(
            text: AppLocalizations.of(context).storePreference,
            textSize: 18,
            textColor: primary,
            isBold: true,
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Padding(
          padding: EdgeInsets.only(top: size.height * 0.03),
          child: ListView(
            children: [
              SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.only(
                          start: size.width * 0.07,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.list,
                              color: Colors.black,
                              size: 40,
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.only(start: size.width * 0.01),
                              child: Text(
                                AppLocalizations.of(context).categories,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.only(
                            start: size.width * 0.07,
                            end: size.width * 0.07,
                            top: size.height * 0.02),
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: categories.length,
                            itemBuilder: (context, i) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() => selectedCategories = i);
                                },
                                child: TileWidget(
                                  isRoundedButton: false,
                                  trailingWidget: selectedCategories == i
                                      ? Icon(
                                          Icons.check,
                                          color: primary,
                                        )
                                      : Container(),
                                  leadingWidget: Row(
                                    children: [
                                      TextWidget(
                                        text: categories[i],
                                        textSize: 14,
                                        textColor: primary,
                                        isBold: true,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.only(
                            top: size.height * 0.04,
                            start: size.width * 0.08,
                            end: size.width * 0.08),
                        child: Divider(
                          height: 1,
                          thickness: 2,
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.04,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.only(
                              start: size.width * 0.06,
                            ),
                            child: Icon(
                              Icons.filter_alt,
                              color: Colors.black,
                              size: 40,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.only(start: size.width * 0.007),
                            child: Text(
                              AppLocalizations.of(context).filters,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.only(
                            start: size.width * 0.07,
                            end: size.width * 0.07,
                            top: size.height * 0.006),
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: filters.length,
                            itemBuilder: (context, i) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() => selectedfilters = i);
                                },
                                child: TileWidget(
                                  isRoundedButton: false,
                                  trailingWidget: selectedfilters == i
                                      ? Icon(
                                          Icons.check,
                                          color: primary,
                                        )
                                      : Container(),
                                  leadingWidget: Row(
                                    children: [
                                      TextWidget(
                                        text: filters[i],
                                        textSize: 14,
                                        textColor: primary,
                                        isBold: true,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.only(
                            start: size.width * 0.07, end: size.width * 0.07),
                        child: ButtonWidget(
                          buttonHeight: 50,
                          buttonWidth: MediaQuery.of(context).size.width,
                          function: () =>
                              Navigator.pushNamed(context, '/dashboardPartner'),
                          roundedBorder: 10,
                          buttonColor: Color(0xFFb58563),
                          widget: TextWidget(
                            text: AppLocalizations.of(context).save,
                            textSize: 18,
                            textColor: grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
