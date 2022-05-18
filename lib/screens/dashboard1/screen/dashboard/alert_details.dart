import 'package:category/screens/dashboard1/widgets/textWidget.dart';
import 'package:category/utils/constant.dart';
import 'package:flutter/material.dart';

class AlertDetails extends StatefulWidget {

  String title;
  String message;
  String image;
  AlertDetails({this.image,this.title,this.message});

  @override
  _AlertDetailsState createState() => _AlertDetailsState();
}

class _AlertDetailsState extends State<AlertDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: TextWidget(
          text: AppLocalizations.of(context).alertdetails,
          textSize: 18,
          textColor: primary,
          isBold: true,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(widget.image,height: 200,width: 200,fit: BoxFit.cover,),
                SizedBox(height: 30,),
                Text(widget.title,style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                SizedBox(height: 30,),
                Text(widget.message,textAlign: TextAlign.justify,style: TextStyle(fontSize: 16),),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
