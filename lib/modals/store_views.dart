// To parse this JSON data, do
//
//     final storeViews = storeViewsFromJson(jsonString);

import 'dart:convert';

StoreViews storeViewsFromJson(String str) => StoreViews.fromJson(json.decode(str));

String storeViewsToJson(StoreViews data) => json.encode(data.toJson());

class StoreViews {
  StoreViews({
    this.status,
    this.message,
    this.views,
  });

  bool status;
  String message;
  Views views;

  factory StoreViews.fromJson(Map<String, dynamic> json) => StoreViews(
    status: json["status"],
    message: json["message"],
    views: Views.fromJson(json["views"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "views": views.toJson(),
  };
}

class Views {
  Views({
    this.userId,
    this.counter,
    this.id,
    this.storeId,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  List<String> userId;
  int counter;
  String id;
  String storeId;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  factory Views.fromJson(Map<String, dynamic> json) => Views(
    userId: List<String>.from(json["userId"].map((x) => x)),
    counter: json["counter"],
    id: json["_id"],
    storeId: json["storeId"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "userId": List<dynamic>.from(userId.map((x) => x)),
    "counter": counter,
    "_id": id,
    "storeId": storeId,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}
