// To parse this JSON data, do
//
//     final totalSales = totalSalesFromJson(jsonString);

import 'dart:convert';

TotalSales totalSalesFromJson(String str) => TotalSales.fromJson(json.decode(str));

String totalSalesToJson(TotalSales data) => json.encode(data.toJson());

class TotalSales {
  TotalSales({
    this.status,
    this.message,
    this.data,
  });

  bool status;
  String message;
  Data data;

  factory TotalSales.fromJson(Map<String, dynamic> json) => TotalSales(
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
    this.sales,
    this.id,
  });

  int sales;
  String id;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    sales: json["sales"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "sales": sales,
    "_id": id,
  };
}
