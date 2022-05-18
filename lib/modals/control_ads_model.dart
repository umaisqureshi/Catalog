// To parse this JSON data, do
//
//     final getAdsModel = getAdsModelFromJson(jsonString);

import 'dart:convert';

GetAdsModel getAdsModelFromJson(String str) => GetAdsModel.fromJson(json.decode(str));

String getAdsModelToJson(GetAdsModel data) => json.encode(data.toJson());

class GetAdsModel {
  GetAdsModel({
    this.status,
    this.message,
    this.data,
  });

  bool status;
  String message;
  List<Datum> data;

  factory GetAdsModel.fromJson(Map<String, dynamic> json) => GetAdsModel(
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
    this.storeId,
    this.storeLogo,
    this.storeName,
    this.storeCategory,
    this.duration,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  String id;
  String storeId;
  String storeLogo;
  String storeName;
  String storeCategory;
  int duration;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["_id"],
    storeId: json["storeId"],
    storeLogo: json["store_logo"],
    storeName: json["store_name"],
    storeCategory: json["store_category"],
    duration: json["duration"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "storeId": storeId,
    "store_logo": storeLogo,
    "store_name": storeName,
    "store_category": storeCategory,
    "duration": duration,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}
