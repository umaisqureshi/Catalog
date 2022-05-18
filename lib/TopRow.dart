import 'package:category/utils/sharedPrefs.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';

import 'modals/cartItemCount.dart';

class TopRow extends StatelessWidget {
  ValueChanged visibility;
  bool isVisible;

  TopRow({this.visibility, this.isVisible});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsetsDirectional.only(end: size.width * 0.05),
      child: Row(
        children: [
          GestureDetector(
              onTap: () {
                visibility(!isVisible);
              },
              child: Image.asset(
                "assets/images/search(5).png",
                color: Color(0xFFb58563),
                height: 18,
                width: 20,
              )),
          Padding(
            padding: EdgeInsetsDirectional.only(start: size.width * 0.05),
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/Notification'),
              child: Icon(
                Icons.notifications_sharp,
                color: Color(0xFFb58563),
              ),
            ),
          ),
          Padding(
              padding: EdgeInsetsDirectional.only(start: size.width * 0.05),
              child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/cart', arguments: SharedPrefs().isPromoCodeAvailable() ? SharedPrefs().savePromoCode : null);
                  },
                  child: /*Image.asset(
                    "assets/images/shoppingBag.png",
                    color: Color(0xFFb58563),
                    height: 18,
                    width: 20,
                  ))*/
              ValueListenableBuilder(
                  valueListenable: cartNotifier,
                  builder: (context, int snapshot, child) {
                    /*return Text(snapshot.toString());*/
                     return Badge(
                       toAnimate: true,
                       badgeColor: Color(0xFFb58563),
                       badgeContent: Text(snapshot.toString(), style: TextStyle(color: Colors.white),),
                       child: Image.asset(
                        "assets/images/shoppingBag.png",
                        color: Color(0xFFb58563),
                        height: 18,
                        width: 20,
                    ),
                     );
                  }
                )
            ),
              ),
        ],
      ),
    );
  }
}
