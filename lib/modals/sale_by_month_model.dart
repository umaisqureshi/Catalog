// To parse this JSON data, do
//
//     final salesByMonth = salesByMonthFromJson(jsonString);

import 'dart:convert';

SalesByMonth salesByMonthFromJson(String str) => SalesByMonth.fromJson(json.decode(str));

String salesByMonthToJson(SalesByMonth data) => json.encode(data.toJson());

class SalesByMonth {
  SalesByMonth({
    this.stauts,
    this.message,
    this.data,
  });

  bool stauts;
  String message;
  List<Datum> data;

  factory SalesByMonth.fromJson(Map<String, dynamic> json) => SalesByMonth(
    stauts: json["stauts"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "stauts": stauts,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.items,
  });

  List<Item> items;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
  };
}

class Item {
  Item({
    this.id,
    this.price,
    this.imageUrl,
    this.productName,
    this.storeId,
    this.sold,
    this.time,
  });

  String id;
  String price;
  String imageUrl;
  String productName;
  String storeId;
  int sold;
  int time;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    price: json["price"],
    imageUrl: json["imageUrl"],
    productName: json["productName"],
    storeId: json["store_id"],
    sold: json["sold"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "price": price,
    "imageUrl": imageUrl,
    "productName": productName,
    "store_id": storeId,
    "sold": sold,
    "time": time,
  };
}
