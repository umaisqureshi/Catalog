import 'package:category/screens/dashboard/photo_view.dart';
import 'package:category/screens/dashboard1/widgets/backIconWidget.dart';
import 'package:category/screens/dashboard1/widgets/bottomBarWidget.dart';
import 'package:category/screens/dashboard1/widgets/topBarWidget.dart';
import 'package:category/utils/constant.dart';
import 'package:category/widgets/products.dart';
import 'package:category/widgets/textWidget.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:category/modals/productsByStoresModal.dart';

class ProductDetails extends StatefulWidget {

  Product product;

  ProductDetails({this.product});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {

  int color = 0xff123456;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.product.color);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).productDetail,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.only(top: 5),
                        child: InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => FullSizePhoto(url: widget.product.images.first.toString(),)));
                          },
                          child: Container(
                            width: size.width,
                            height: size.height * 0.5,
                            child: Swiper(
                              itemBuilder: (BuildContext context, int index) {
                                return new Image.network(
                                  widget.product.images[index],
                                  fit: BoxFit.fitHeight,
                                );
                              },
                              autoplay: false,
                              itemCount: widget.product.images.length,
                              scrollDirection: Axis.horizontal,
                              pagination: new SwiperPagination(),
                              control: new SwiperControl(
                                  disableColor: Color(0xFF000000),
                                  color: Color(0xFF000000)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.only(top: size.height * 0.05),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.only(start: 20),
                              child: Text(
                                widget.product.productName,
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.only(
                                end: 25,
                              ),
                              child: Text(
                                "\$ ${widget.product.price.toString()}",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.only(start: 20, top: 5),
                            child: RatingBar.builder(
                              initialRating: 4.5,
                              ignoreGestures: true,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemSize: 18,
                              itemCount: 5,
                              itemPadding:
                              EdgeInsetsDirectional.only(start: 1.0,end: 1.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.black,
                              ),
                              onRatingUpdate: (rating) {
                                print(rating);
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.only(end: 30, top: 5),
                            child: Text(" (4.5)",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(start: 20, top: 5),
                        child: Text(
                          AppLocalizations.of(context).sales(widget.product.sold.toString()),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: Color(0xff707070),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsetsDirectional.only(start: 20, top: 5),
                        child: Row(
                          children: [
                            Text('Color :',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
                            SizedBox(width: 5,),
                            Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Color(widget.product.color)

                              ),
                            )
                            /*Text(widget.product.color),*/
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsetsDirectional.only(start: 20, top: 5),
                        child: Row(
                          children: [
                            Text('Weight :',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
                            SizedBox(width: 5,),
                            Text(widget.product.weight),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsetsDirectional.only(start: 20, top: 5),
                        child: Row(
                          children: [
                            Text('Size :',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
                            SizedBox(width: 5,),
                            Text(widget.product.size),
                          ],
                        ),
                      ),


                      Padding(
                        padding: const EdgeInsetsDirectional.only(start: 20, top: 25),
                        child: Text(
                          AppLocalizations.of(context).description,
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ),



                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                            start: 20, end: 30, top: 5, bottom: 40),
                        child: Text(
                          widget.product.productDescription,
                          style: TextStyle(fontSize: 13, height: 1.5),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
