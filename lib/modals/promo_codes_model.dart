// To parse this JSON data, do
//
//     final getPromoCodes = getPromoCodesFromJson(jsonString);

import 'dart:convert';

GetPromoCodes getPromoCodesFromJson(String str) => GetPromoCodes.fromJson(json.decode(str));

String getPromoCodesToJson(GetPromoCodes data) => json.encode(data.toJson());

class GetPromoCodes {
  GetPromoCodes({
    this.status,
    this.message,
    this.data,
  });

  bool status;
  String message;
  List<PromoCodeItemsModel> data;

  factory GetPromoCodes.fromJson(Map<String, dynamic> json) => GetPromoCodes(
    status: json["status"],
    message: json["message"],
    data: List<PromoCodeItemsModel>.from(json["data"].map((x) => PromoCodeItemsModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class PromoCodeItemsModel {
  PromoCodeItemsModel({
    this.id,
    this.promocode,
    this.discount,
    this.endingDate,
    this.startingDate,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  String id;
  String promocode;
  String discount;
  String endingDate;
  String startingDate;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  factory PromoCodeItemsModel.fromJson(Map<String, dynamic> json) => PromoCodeItemsModel(
    id: json["_id"],
    promocode: json["promocode"],
    discount: json["discount"],
    endingDate: json["ending_date"],
    startingDate: json["starting_date"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "promocode": promocode,
    "discount": discount,
    "ending_date": endingDate,
    "starting_date": startingDate,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}
