// To parse this JSON data, do
//
//     final getNotificationsModel = getNotificationsModelFromJson(jsonString);

import 'dart:convert';

GetNotificationsModel getNotificationsModelFromJson(String str) => GetNotificationsModel.fromJson(json.decode(str));

String getNotificationsModelToJson(GetNotificationsModel data) => json.encode(data.toJson());

class GetNotificationsModel {
  GetNotificationsModel({
    this.status,
    this.message,
    this.data,
  });

  bool status;
  String message;
  List<Datum> data;

  factory GetNotificationsModel.fromJson(Map<String, dynamic> json) => GetNotificationsModel(
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
    this.title,
    this.subTitle,
    this.message,
    this.image,
    this.type,
    this.createdAt,
    this.updatedAt,
  });

  String id;
  String title;
  String subTitle;
  String message;
  String image;
  Type type;
  DateTime createdAt;
  DateTime updatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["_id"],
    title: json["title"],
    subTitle: json["subTitle"],
    message: json["message"],
    image: json["image"],
    type: typeValues.map[json["type"]],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "subTitle": subTitle,
    "message": message,
    "image": image,
    "type": typeValues.reverse[type],
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}

enum Type { AFAF, CUSTOMER, PARTNER }

final typeValues = EnumValues({
  "afaf": Type.AFAF,
  "customer": Type.CUSTOMER,
  "partner": Type.PARTNER
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
