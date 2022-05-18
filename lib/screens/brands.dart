import 'package:alphabet_scroll_view/alphabet_scroll_view.dart';
import 'package:category/utils/constant.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:category/widgets/textWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Brands extends StatefulWidget {

  @override
  _BrandsState createState() => _BrandsState();
}

class _BrandsState extends State<Brands> {
  List<String> list = [
    'Amazon',
    'Babes',
    'Digital Emporium',
    'Deep Colors',
    'The Sweet Spot',
    'Superette',
    'Mainland ',
    'Jamstart',
    'Webuystock',
    'Amazon',
    'Babes',
    'Digital Emporium',
    'Deep Colors',
    'The Sweet Spot',
    'Superette',
    'Mainland ',
    'Jamstart',
    'Webuystock',
    'Amazon',
    'Babes',
    'Digital Emporium',
    'Deep Colors',
    'The Sweet Spot',
    'Superette',
    'Mainland ',
    'Jamstart',
    'Webuystock',
    'Webuystock',
    'Webuystock',
    'Webuystock',
    'Webuystock'
  ];
  int selectedIndex;


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            bottom: PreferredSize(
              preferredSize: Size(double.infinity, 110),
              child: Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start:10.0 , end: 10),
                      child: TextField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          suffixIcon: Visibility(
                              visible: false,
                              maintainSize: true,
                              maintainState: true,
                              maintainAnimation: true,
                              child: Icon(Icons.search)),
                          prefixIcon: Transform.translate(
                              offset: Offset(0.0 , 10.0),
                              child: Icon(Icons.search , color: Colors.black,)),
                          hintText: AppLocalizations.of(context).findFavBrands,
                          fillColor: Color(0xFFF0EFEF),
                          contentPadding: EdgeInsetsDirectional.only(top: 28),
                          border: UnderlineInputBorder(),
                          enabledBorder:UnderlineInputBorder(),
                          focusedBorder: UnderlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Padding(
                      padding: EdgeInsetsDirectional.only(start: 10),
                      child: TextWidget(
                        text: AppLocalizations.of(context).topStores,
                        textColor: primary.withOpacity(0.3),
                        textSize: 15,
                      ),
                    ),
                    SizedBox(height: 10,),
                  ],
                ),
              ),
            ),
            title: TextWidget(
              text: AppLocalizations.of(context).manageMyBrands,
              textSize: 15,
              textColor: primary,
              isBold: true,
            ),
            centerTitle: true,
            elevation: 0,
          ),
          body:  AlphabetScrollView(
            list: list.map((e) => AlphaModel(e)).toList(),
            isAlphabetsFiltered: true,
            alignment: SharedPrefs().locale=='ar' ? LetterAlignment.left : LetterAlignment.right,
            itemExtent: 55,
            itemBuilder: (_, A, id) {
              return Padding(
                padding: EdgeInsetsDirectional.only( end: 30 , start: 10 , bottom: 10),
                child: Container(
                  // width: size.width,
                  // height: size.height * 0.2,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Color(0xFF0f1013)
                              .withOpacity(0.25)),
                      borderRadius: BorderRadius.circular(10)),
                  child: Align(
                      alignment: SharedPrefs().locale=='ar' ? Alignment.centerRight:Alignment.centerLeft,
                      child: Text('   $id')),
                ),
              );
            },
          ),
        ));
  }
}
