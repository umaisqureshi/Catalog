import 'package:category/utils/constant.dart';
import 'package:flutter/material.dart';

class NoInternet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Color(0xFFE6E5E6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height*0.18,),
            Image.asset(
              "assets/gifs/noInternet.gif",
              height: 250,
              width: 250,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              AppLocalizations.of(context).noConnection,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            SizedBox(height: 10,),
            Text(
              AppLocalizations.of(context).noConnectionMessage,
              style: TextStyle(color: Colors.black45, fontSize: 14),
            ),
            Spacer(),
            /*InkWell(
              onTap: (){

              },
              child: Container(
                height: MediaQuery.of(context).size.height*0.08,
                width: MediaQuery.of(context).size.width*0.4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: brown, width: 2)
                ),
                child: Center(child: Text("Try Again", style: TextStyle(color: brown, fontSize: 15),),),
              ),
            ),*/
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
