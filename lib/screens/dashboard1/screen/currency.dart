import 'package:category/modals/currencyModel.dart';
import 'package:category/screens/dashboard1/widgets/buttonWidget.dart';
import 'package:category/screens/dashboard1/widgets/textWidget.dart';
import 'package:category/screens/dashboard1/widgets/tileWidget.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:flutter/material.dart';
import 'package:category/utils/constant.dart';
import 'package:flutter/scheduler.dart';

class Currency1 extends StatefulWidget {
  @override
  _Currency1State createState() => _Currency1State();
}

class _Currency1State extends State<Currency1> {
  int selectedCurrency = 0;

  void changeIndex(int index) {
    selectedCurrency = index;
  }

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      selectedCurrency = currenciesEnglish.indexWhere((element) => SharedPrefs().isCurrencyAvailable() ? SharedPrefs().currency == element.toUpperCase() : element.toUpperCase() == 'USD');
      setState(() {});
    });
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
              text: AppLocalizations.of(context).changeCurrency,
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
                padding:  EdgeInsetsDirectional.only(top:size.height*0.06),
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
                                itemCount: currenciesEnglish.length,
                                itemBuilder: (context, i) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() => selectedCurrency = i);
                                    },
                                    child: TileWidget(
                                      isRoundedButton: false,
                                      trailingWidget: selectedCurrency == i
                                          ? Icon(
                                        Icons.check,
                                        color: primary,
                                      )
                                          : Container(),
                                      leadingWidget: Row(
                                        children: [
                                          TextWidget(
                                            text: SharedPrefs().isLocaleAvailable() ? SharedPrefs().locale == "ar" ? currenciesArabic[i]: currenciesEnglish[i] : currenciesEnglish[i],
                                            textSize: 14,
                                            textColor: primary,
                                            isBold: true,
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                            ButtonWidget(
                              buttonHeight: 50,
                              buttonWidth: MediaQuery.of(context).size.width,
                              function: () {
                                SharedPrefs().currency = currenciesEnglish[selectedCurrency].toUpperCase();
                                Navigator.pushNamed(context, '/dashboardPartner');
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
        ));
  }
}