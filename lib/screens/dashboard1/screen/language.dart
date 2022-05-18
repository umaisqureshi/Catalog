import 'package:category/main.dart';
import 'package:category/provider/locale_provider.dart';
import 'package:category/screens/dashboard1/widgets/buttonWidget.dart';
import 'package:category/screens/dashboard1/widgets/textWidget.dart';
import 'package:category/screens/dashboard1/widgets/tileWidget.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:flutter/material.dart';
import 'package:category/utils/constant.dart';
import 'package:provider/provider.dart';

class Language1 extends StatefulWidget {
  @override
  _Language1State createState() => _Language1State();
}

class _Language1State extends State<Language1> {
  List<String> Language = [
    'English',
    'عربى',
  ];

  bool isLoading = false;

  int selectedLanguage = 0;

  void changeIndex(int index) {
    selectedLanguage = index;
  }



  @override
  void initState() {
    if(SharedPrefs().isLocaleAvailable()){
      if(SharedPrefs().locale == "ar"){
        selectedLanguage = 1;
      }else{
        selectedLanguage = 0;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: TextWidget(
            text: AppLocalizations.of(context).changeLanguage,
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
              padding: EdgeInsetsDirectional.only(top: size.height * 0.06),
              child: ListView(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: Language.length,
                              itemBuilder: (context, i) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() => selectedLanguage = i);
                                  },
                                  child: TileWidget(
                                    isRoundedButton: false,
                                    trailingWidget: selectedLanguage == i
                                        ? Icon(
                                            Icons.check,
                                            color: primary,
                                          )
                                        : Container(),
                                    leadingWidget: Row(
                                      children: [
                                        TextWidget(
                                          text: Language[i],
                                          textSize: 14,
                                          textColor: primary,
                                          isBold: true,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }),
                          SizedBox(
                            height: 10,
                          ),
                          isLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: brown,
                                  ),
                                )
                              : ButtonWidget(
                                  buttonHeight: 50,
                                  buttonWidth:
                                      MediaQuery.of(context).size.width,
                                  function: () {

                                    if (selectedLanguage == 1) {
                                      locale.value = "ar";
                                      locale.notifyListeners();
                                    } else {
                                      locale.value = "en";
                                      locale.notifyListeners();
                                    }
                                    setState(() {
                                      isLoading = false;
                                    });
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
