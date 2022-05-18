// To parse this JSON data, do
//
//     final checkAlreadyLike = checkAlreadyLikeFromJson(jsonString);

import 'dart:convert';

CheckAlreadyLike checkAlreadyLikeFromJson(String str) => CheckAlreadyLike.fromJson(json.decode(str));

String checkAlreadyLikeToJson(CheckAlreadyLike data) => json.encode(data.toJson());

class CheckAlreadyLike {
  CheckAlreadyLike({
    this.status,
    this.message,
    this.data,
  });

  bool status;
  String message;
  bool data;

  factory CheckAlreadyLike.fromJson(Map<String, dynamic> json) => CheckAlreadyLike(
    status: json["status"],
    message: json["message"],
    data: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data,
  };
}
