// To parse this JSON data, do
//
//     final singlePromoCode = singlePromoCodeFromJson(jsonString);

import 'dart:convert';

SinglePromoCode singlePromoCodeFromJson(str) => SinglePromoCode.fromJson(str);

String singlePromoCodeToJson(SinglePromoCode data) => json.encode(data.toJson());

class SinglePromoCode {
  SinglePromoCode({
    this.status,
    this.message,
    this.data,
  });

  bool status;
  String message;
  Data data;

  factory SinglePromoCode.fromJson(Map<String, dynamic> json) => SinglePromoCode(
    status: json["status"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  Data({
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

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
