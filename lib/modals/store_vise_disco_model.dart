// To parse this JSON data, do
//
//     final storeViseDiscoModel = storeViseDiscoModelFromJson(jsonString);

import 'dart:convert';

StoreViseDiscoModel storeViseDiscoModelFromJson(String str) => StoreViseDiscoModel.fromJson(json.decode(str));

String storeViseDiscoModelToJson(StoreViseDiscoModel data) => json.encode(data.toJson());

class StoreViseDiscoModel {
  StoreViseDiscoModel({
    this.status,
    this.message,
    this.data,
  });

  bool status;
  String message;
  List<Datum> data;

  factory StoreViseDiscoModel.fromJson(Map<String, dynamic> json) => StoreViseDiscoModel(
    status: json["status"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.id,
    this.discountImg,
    this.discount,
    this.endingDate,
    this.storeId,
    this.productId,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  String id;
  String discountImg;
  String discount;
  DateTime endingDate;
  String storeId;
  String productId;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["_id"],
    discountImg: json["discount_img"],
    discount: json["discount"],
    endingDate: DateTime.parse(json["ending_date"]),
    storeId: json["store_id"],
    productId: json["product_id"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "discount_img": discountImg,
    "discount": discount,
    "ending_date": endingDate.toIso8601String(),
    "store_id": storeId,
    "product_id": productId,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}
