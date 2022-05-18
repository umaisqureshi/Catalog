import 'package:flutter/material.dart';

class TabWidget extends StatelessWidget {
  String name;
  Function onPressed;
  TabWidget({@required this.name, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Tab(
        child: Container(
          width: double.infinity,
          child: OutlinedButton(
              onPressed: onPressed,
              child: Text(
                name,
                style: TextStyle(fontSize: 15, color: Colors.black),
              )),
        ),
      ),
    );
  }


}
