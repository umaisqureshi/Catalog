import 'dart:convert';

import 'package:flutter/cupertino.dart';

GetBannerAdsModel getBannerAdsModelFromJson(String str) => GetBannerAdsModel.fromJson(json.decode(str));

String getBannerAdsModelToJson(GetBannerAdsModel data) => json.encode(data.toJson());

class GetBannerAdsModel {
  GetBannerAdsModel({
    this.status,
    this.message,
    this.data,
  });

  String status;
  String message;
  List<Datum> data;

  factory GetBannerAdsModel.fromJson(Map<String, dynamic> json) => GetBannerAdsModel(
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
    this.images,
    this.id,
    this.duration,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  List<String> images;
  String id;
  int duration;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    images: List<String>.from(json["images"].map((x) => x)),
    id: json["_id"],
    duration: json["duration"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "images": List<dynamic>.from(images.map((x) => x)),
    "_id": id,
    "duration": duration,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}
