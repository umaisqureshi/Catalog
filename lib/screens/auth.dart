import 'package:category/screens/category.dart';
import 'package:category/utils/constant.dart';
import 'package:category/widgets/LogoWidget.dart';
import 'package:category/widgets/buttonWidget.dart';
import 'package:category/widgets/textWidget.dart';
import 'package:flutter/material.dart';

class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  bool isLoading = false;
  String category;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.white,
          child: Column(
            children: [
              LogoWidget(
                scale: 4,
              ),
              Padding(
                padding: EdgeInsetsDirectional.only(top: size.height * 0.1),
                child: ButtonWidget(
                  buttonHeight: 50,
                  buttonWidth: MediaQuery.of(context).size.width,
                  function: () => Navigator.pushNamed(context, '/signUp'),
                  buttonColor: Color(0xFFb58563),
                  roundedBorder: 10,
                  widget: TextWidget(
                    text: AppLocalizations.of(context).signUp,
                    textSize: 18,
                    textColor: grey,
                    isBold: true,
                  ),
                ),
              ),
              ButtonWidget(
                buttonHeight: 50,
                buttonWidth: MediaQuery.of(context).size.width,
                function: () => Navigator.pushNamed(context, '/signIn'),
                roundedBorder: 10,
                buttonColor: Color(0xFFb58563),
                widget: TextWidget(
                  text: AppLocalizations.of(context).signIn,
                  textSize: 18,
                  textColor: grey,
                  isBold: true,
                ),
              ),
              // Spacer(),
              Padding(
                padding: EdgeInsetsDirectional.only(top: size.height * 0.09),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: size.width * 0.05, right: size.width * 0.01),
                        child: Divider(
                          thickness: 2,
                          height: 1,
                          color: Color(
                            0xFF707070,
                          ),
                        ),
                      ),
                    ),
                    Text(AppLocalizations.of(context).orConnectWith),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(
                            end: size.width * 0.05, start: size.width * 0.01),
                        child: Divider(
                          thickness: 2,
                          height: 1,
                          color: Color(
                            0xFF707070,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.05),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.only(start: size.width * 0.25),
                      child: GestureDetector(
                        onTap: () async {
                          this.setState(() {
                            isLoading = true;
                          });
                          await Category();
                        },
                        child: Image.asset(
                          'assets/images/fb.png',
                          width: 70,
                          height: 70,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(start: size.width * 0.03),
                      child: Image.asset(
                        'assets/images/twitt.png',
                        width: 40,
                        height: 40,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(start: size.width * 0.05),
                      child: Image.asset(
                        'assets/images/insta.png',
                        width: 45,
                        height: 45,
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
  }
}
