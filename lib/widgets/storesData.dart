import 'package:flutter/material.dart';

class StoreContent{
  String image;
  String title;
  String icon;
  BuildContext context;
  StoreContent({this.image,this.title,this.icon,this.context});
}
List<StoreContent> storesdataList=
[
  StoreContent(image:"assets/images/LV.png",title: "Louis Vuitton",icon: "Icon(Icons.favorite_outline_rounded,)" ),
  StoreContent(image:"assets/images/Versace.png",title: "Louis Vuitton",icon: "Icon(Icons.favorite_outline_rounded,)" ),
  StoreContent(image:"assets/images/Adidas.png",title: "Louis Vuitton",icon: "Icon(Icons.favorite_outline_rounded,)" ),
  StoreContent(image:"assets/images/Gucci.png",title: "Louis Vuitton",icon: "Icon(Icons.favorite_outline_rounded,)" ),

];
class AllStoreContent{
  String image;
  String title;
  String icon;
  BuildContext context;
  AllStoreContent({this.image,this.title,this.icon,this.context});
}
List<AllStoreContent> allstoresdataList=
[
  AllStoreContent(image:"assets/images/LV.png",title: "Louis Vuitton",icon: "Icon(Icons.favorite_outline_rounded,)" ),
  AllStoreContent(image:"assets/images/LV.png",title: "Louis Vuitton",icon: "Icon(Icons.favorite_outline_rounded,)" ),
  AllStoreContent(image:"assets/images/LV.png",title: "Louis Vuitton",icon: "Icon(Icons.favorite_outline_rounded,)" ),
  AllStoreContent(image:"assets/images/LV.png",title: "Louis Vuitton",icon: "Icon(Icons.favorite_outline_rounded,)" ),

];
