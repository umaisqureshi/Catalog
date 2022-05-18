// To parse this JSON data, do
//
//     final removeFavModel = removeFavModelFromJson(jsonString);

import 'dart:convert';

RemoveFavModel removeFavModelFromJson(String str) => RemoveFavModel.fromJson(json.decode(str));

String removeFavModelToJson(RemoveFavModel data) => json.encode(data.toJson());

class RemoveFavModel {
  RemoveFavModel({
    this.status,
    this.message,
    this.data,
  });

  bool status;
  String message;
  Data data;

  factory RemoveFavModel.fromJson(Map<String, dynamic> json) => RemoveFavModel(
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
    this.stores,
    this.products,
    this.substores,
    this.id,
    this.customerId,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  List<String> stores;
  List<dynamic> products;
  List<dynamic> substores;
  String id;
  String customerId;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    stores: List<String>.from(json["stores"].map((x) => x)),
    products: List<dynamic>.from(json["products"].map((x) => x)),
    substores: List<dynamic>.from(json["substores"].map((x) => x)),
    id: json["_id"],
    customerId: json["customerId"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "stores": List<dynamic>.from(stores.map((x) => x)),
    "products": List<dynamic>.from(products.map((x) => x)),
    "substores": List<dynamic>.from(substores.map((x) => x)),
    "_id": id,
    "customerId": customerId,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}
