// To parse this JSON data, do
//
//     final discountModel = discountModelFromJson(jsonString);

import 'dart:convert';

DiscountModel discountModelFromJson(String str) => DiscountModel.fromJson(json.decode(str));

String discountModelToJson(DiscountModel data) => json.encode(data.toJson());

class DiscountModel {
  DiscountModel({
    this.status,
    this.message,
    this.data,
  });

  bool status;
  String message;
  List<BestDealsItem> data;

  factory DiscountModel.fromJson(Map<String, dynamic> json) => DiscountModel(
    status: json["status"],
    message: json["message"],
    data: List<BestDealsItem>.from(json["data"].map((x) => BestDealsItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class BestDealsItem {
  BestDealsItem({
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
  String endingDate;
  String storeId;
  String productId;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  factory BestDealsItem.fromJson(Map<String, dynamic> json) => BestDealsItem(
    id: json["_id"],
    discountImg: json["discount_img"],
    discount: json["discount"],
    endingDate: json["ending_date"],
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
    "ending_date": endingDate,
    "store_id": storeId,
    "product_id": productId,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}
