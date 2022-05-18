import 'package:flutter/material.dart';

class Products{
  String image;
  String title;
  String sales;
  String price;
  BuildContext context;
  Products({this.image,this.title,this.sales,this.price,this.context});
}
List<Products> productslist=
[
  Products(image:"assets/images/tshirt1.png",title: "Mickie Hoddie",price: "\$350",sales: "29 Sales" ),
  Products(image:"assets/images/tshirt2.png",title: "Mickie Hoddie",price: "\$250",sales: "40 Sales", ),
  Products(image:"assets/images/tshirt3.png",title: "Mickie Hoddie",price: "\$340",sales: "20 Sales" ),
  Products(image:"assets/images/tshirt1.png",title: "Mickie Hoddie",price: "\$450",sales: "29 Sales" ),

];

class MyProduct{
  String image;
  String title;
  String sales;
  String price;
  BuildContext context;
  MyProduct({this.image,this.title,this.sales,this.price,this.context});
}
List<MyProduct> productlist=
[
  MyProduct(image:"assets/images/supremebag.png",title: "Supreme Bag",price: "\$350",sales: "29 Sales" ),
  MyProduct(image:"assets/images/bluebag.png",title: "Blue Bag",price: "\$250",sales: "40 Sales", ),
  MyProduct(image:"assets/images/catbag.png",title: "Cat Handbag",price: "\$340",sales: "20 Sales" ),
  MyProduct(image:"assets/images/supremebag.png",title: "Supreme Bag",price: "\$450",sales: "29 Sales" ),

];


class SubStore{
  String image;
  String title;
  BuildContext context;
  SubStore({this.image,this.title,this.context});
}
List<SubStore>Substorelist=[
  SubStore(image: "assets/images/Versace.png",title: "Gucci"),
  SubStore(image: "assets/images/shopLogo.png",title: "Gucci"),
  SubStore(image: "assets/images/Versace.png",title: "Gucci"),
];