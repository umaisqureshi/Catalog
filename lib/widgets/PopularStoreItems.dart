import 'package:category/widgets/storesData.dart';
import 'package:flutter/material.dart';

class PopularStoreItems extends StatefulWidget {
  final StoreContent storesdataList;
  PopularStoreItems({this.storesdataList});

  @override
  _PopularStoreItemsState createState() => _PopularStoreItemsState();
}

class _PopularStoreItemsState extends State<PopularStoreItems> {

  bool favouriteBool = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.only(right: 10),
      child: Container(
        width: 160,
        child: Card(
          elevation: 3,
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(
                context, '/substore'),
            child: Column(

          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              children: [
                Container(
                    height: 100,
                    child: Center(
                      child: Image.asset(
                        widget.storesdataList
                            .image,
                        fit: BoxFit.contain,
                      ),
                    )),
                Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:10.0),
                        child: Text(
                          widget.storesdataList
                              .title,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight:
                              FontWeight.bold,
                              color:
                              Colors.black),
                        ),
                      ),
                      IconButton(
                        icon: (favouriteBool)
                            ? Icon(
                          Icons.favorite,
                          color: Colors
                              .black,
                        )
                            : Icon(
                          Icons
                              .favorite_border,
                        ),
                        onPressed: () {
                          setState(() {
                            favouriteBool = !favouriteBool;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
