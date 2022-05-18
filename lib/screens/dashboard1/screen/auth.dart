import 'package:category/screens/dashboard1/widgets/LogoWidget.dart';
import 'package:category/screens/dashboard1/widgets/bottomBarWidget.dart';
import 'package:category/screens/dashboard1/widgets/buttonWidget.dart';
import 'package:category/screens/dashboard1/widgets/textWidget.dart';
import 'package:category/screens/dashboard1/widgets/topBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:category/utils/constant.dart';

class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: [
              TopBarWidget(),
              LogoWidget(
                scale: 4,
              ),
              // Spacer(),
              Padding(
                padding:  EdgeInsets.only(top: size.height*0.1),
                child: ButtonWidget(
                  buttonHeight: 50  ,
                  buttonWidth: MediaQuery.of(context).size.width,
                  function: () => Navigator.pushNamed(context, '/signUp'),
                  buttonColor: Color(0xFFb58563),
                  roundedBorder: 10,
                  widget: TextWidget(
                    text: 'SIGNUP',
                    textSize: 18,
                    textColor: grey,
                    isBold: true,
                  ),
                ),
              ),
              ButtonWidget(
                buttonHeight: 50,
                buttonWidth: MediaQuery.of(context).size.width,
                function: ()=> Navigator.pushNamed(context, '/signIn'),
                roundedBorder: 10,
                buttonColor: Color(0xFFb58563),
                widget: TextWidget(
                  text: 'LOGIN',
                  textSize: 18,
                  textColor: grey,
                  isBold: true,
                ),
              ),
              // Spacer(),
              Padding(
                padding:  EdgeInsets.only(top: size.height*0.09),
                child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Padding(
                            padding:  EdgeInsets.only(left:size.width*0.05,right: size.width*0.01 ),
                            child: Divider(thickness: 2,height: 1,color: Color(0xFF707070,),),
                          )
                      ),

                      Text("OR CONNECT WITH"),

                      Expanded(
                          child: Padding(
                            padding:  EdgeInsets.only(right:size.width*0.05,left: size.width*0.01 ),
                            child: Divider(thickness: 2,height: 1,color: Color(0xFF707070,),),
                          )
                      ),
                    ]
                ),
              ),

              /* ButtonWidget(
                buttonHeight: 50,
                buttonWidth: MediaQuery.of(context).size.width,
                function: () => Navigator.pushNamed(context, '/signIn'),
                roundedBorder: 10,
                borderColor: primary,
                widget: TextWidget(
                  text: 'LOGIN',
                  textSize: 18,
                  textColor: grey,
                  isBold: true,
                ),
              ),*/

              Padding(
                padding:  EdgeInsets.only(top: size.height*0.05),
                child: Row(
                  children: [
                    Padding(
                      padding:  EdgeInsets.only(left: size.width*0.3),
                      child: Image.asset('assets/images/facebook.png',width: 50,height: 50,),
                    ),
                    Padding(
                      padding:  EdgeInsets.only(left: size.width*0.05),
                      child: Image.asset('assets/images/twitter.png',width: 50,height: 50,),
                    ),
                    Padding(
                      padding:  EdgeInsets.only(left: size.width*0.05),
                      child: Image.asset('assets/images/instagram.png',width: 50,height: 50,),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:  EdgeInsets.only(top: size.height*0.12),
                child: BottomBarWidget(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
