import 'package:category/l10n/l10n.dart';
import 'package:category/main.dart';
import 'package:category/provider/locale_provider.dart';
import 'package:category/utils/constant.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:category/widgets/buttonWidget.dart';
import 'package:category/widgets/textWidget.dart';
import 'package:category/widgets/tileWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Language extends StatefulWidget {
  @override
  _LanguageState createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
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
    if (SharedPrefs().isLocaleAvailable()) {
      if (SharedPrefs().locale == "en") {
        selectedLanguage = 1;
      } else {
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
        backgroundColor: Colors.white,
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
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: size.height * 0.02),
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40,
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
                          height: 30,
                        ),
                        isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: brown,
                                ),
                              )
                            : ButtonWidget(
                                buttonHeight: 50,
                                buttonWidth: MediaQuery.of(context).size.width,
                                function: () {
                                  setState(() {
                                    isLoading = true;
                                  });

                                  if (selectedLanguage == 1) {
                                   locale.value = L10n.all[1].languageCode;
                                   locale.notifyListeners();
                                   SharedPrefs().locale = locale.value;
                                  } else {
                                    locale.value = L10n.all[0].languageCode;
                                    locale.notifyListeners();
                                    SharedPrefs().locale = locale.value;
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
