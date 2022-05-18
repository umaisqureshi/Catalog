import 'package:flutter/material.dart';

class Product{
  String image;
  String title;
  String sales;
  String price;
  BuildContext context;
  Product({this.image,this.title,this.sales,this.price,this.context});
}
List<Product> productslist=
[
  Product(image:"assets/images/supremebag.png",title: "Supreme Bag",price: "\$350",sales: "29 Sales" ),
  Product(image:"assets/images/bluebag.png",title: "Blue Bag",price: "\$250",sales: "40 Sales", ),
  Product(image:"assets/images/catbag.png",title: "Cat Handbag",price: "\$340",sales: "20 Sales" ),
  Product(image:"assets/images/supremebag.png",title: "Supreme Bag",price: "\$450",sales: "29 Sales" ),

];

class Stores{
  String image;
  String title;
  BuildContext context;
  Stores({this.image,this.title,this.context});
}
List<Stores>storelist=[
  Stores(image: "assets/images/Mask Group 30.png",title: "Louis Vuitton"),
  Stores(image: "assets/images/Versace-logo_white_on_black_small.png",title: "Versace"),
  Stores(image: "assets/images/Mask Group 30.png",title: "Louis Vuitton"),
  Stores(image: "assets/images/Versace-logo_white_on_black_small.png",title: "Versace"),
  Stores(image: "assets/images/Mask Group 30.png",title: "Louis Vuitton"),
];

class AllStores{
  String images;
  String title;
  String subtitle;
  String sales;
  String icon;
  BuildContext context;
  AllStores({this.images,this.title,this.subtitle,this.sales,this.icon,this.context});
}
List<AllStores>allstore=[
  AllStores(images: "assets/images/LV.png",title: "Louis Vuitton",subtitle: "Item Sold",sales: "10000",),
  AllStores(images: "assets/images/LV.png",title: "Louis Vuitton",subtitle: "Item Sold",sales: "10000",),
  AllStores(images: "assets/images/LV.png",title: "Louis Vuitton",subtitle: "Item Sold",sales: "10000",),
  AllStores(images: "assets/images/LV.png",title: "Louis Vuitton",subtitle: "Item Sold",sales: "10000",),

];