import 'package:flutter/material.dart';
import 'package:category/modals/storeByCategory.dart';

class PopularStores extends StatefulWidget {

  Store store;
  PopularStores({this.store});

  @override
  _PopularStoresState createState() => _PopularStoresState();
}

class _PopularStoresState extends State<PopularStores> {

  bool favouriteBool = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsetsDirectional.only(
          start: 12, end: 6, bottom: 10),
      child: InkWell(
        onTap: (){
          Navigator.pushNamed(
              context, '/customerHomeExtended');
        },
        child: Card(
          elevation: 2,
          child: Column(

            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                child: SizedBox(
                  child: Image.network(
                    widget.store.storeLogo,
                    fit: BoxFit.contain,
                  ),
                ),
                color: Color(0xffF1F1F1),
                height: size.height * 0.14,
                width: size.width * 0.44,
              ),
              Container(
                width: size.width * 0.44,
                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding:
                          const EdgeInsetsDirectional.only(
                              start: 5.0),
                          child: Text(
                            widget.store.storeName,
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
                                fontWeight:
                                FontWeight
                                    .w500),
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsetsDirectional.only(
                              end: 5.0),
                          child: InkWell(
                            onTap: (){
                              setState(() {
                                favouriteBool = !favouriteBool;
                              });
                            },
                            child: Container(
                              padding: EdgeInsetsDirectional.all(0),
                              child: (favouriteBool)
                                  ? Icon(
                                Icons.favorite,
                                color: Colors.black,
                                size: 20,
                              )
                                  : Icon(
                                Icons
                                    .favorite_border,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],

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
