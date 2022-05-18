// To parse this JSON data, do
//
//     final revenueModel = revenueModelFromJson(jsonString);

import 'dart:convert';

RevenueModel revenueModelFromJson(String str) => RevenueModel.fromJson(json.decode(str));

String revenueModelToJson(RevenueModel data) => json.encode(data.toJson());

class RevenueModel {
  RevenueModel({
    this.status,
    this.message,
    this.data,
  });

  bool status;
  String message;
  Data data;

  factory RevenueModel.fromJson(Map<String, dynamic> json) => RevenueModel(
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
    this.revenue,
    this.id,
  });

  int revenue;
  String id;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    revenue: json["revenue"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "revenue": revenue,
    "_id": id,
  };
}
