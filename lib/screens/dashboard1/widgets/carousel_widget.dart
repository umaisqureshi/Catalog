import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Carousel1 extends StatefulWidget {
  @override
  _Carousel1State createState() => _Carousel1State();
}

class _Carousel1State extends State<Carousel1> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  Carousel(
      boxFit: BoxFit.fitHeight,
      images: [
        AssetImage('assets/images/Mask Group 29.png'),
        AssetImage('assets/images/Mask Group 49.png'),
        AssetImage('assets/images/Mask Group 50.png'),
        AssetImage('assets/images/Mask Group 52.png'),
      ],
      autoplay: false,
      animationCurve: Curves.fastOutSlowIn,
      animationDuration: Duration(milliseconds: 1000),
      dotSize: 3.0,
      dotBgColor: Color(0xFFFFFFFF),
      dotIncreasedColor: Color(0xFFB9B9B9),
      dotColor: Color(0xFFE2E2EA),
      indicatorBgPadding: 3.0,
    );
  }
}
