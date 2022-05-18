// To parse this JSON data, do
//
//     final popluarStoreModel = popluarStoreModelFromJson(jsonString);

import 'dart:convert';

PopluarStoreModel popluarStoreModelFromJson(String str) => PopluarStoreModel.fromJson(json.decode(str));

String popluarStoreModelToJson(PopluarStoreModel data) => json.encode(data.toJson());

class PopluarStoreModel {
  PopluarStoreModel({
    this.status,
    this.message,
    this.data,
  });

  bool status;
  String message;
  List<StoresData> data;

  factory PopluarStoreModel.fromJson(Map<String, dynamic> json) => PopluarStoreModel(
    status: json["status"],
    message: json["message"],
    data: List<StoresData>.from(json["data"].map((x) => StoresData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class StoresData {
  StoresData({
    this.status,
    this.products,
    this.sales,
    this.revenue,
    this.id,
    this.storeLogo,
    this.storeName,
    this.storeCategory,
    this.location,
    this.storeDescription,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.storeId,
    this.reason,
  });

  Status status;
  List<String> products;
  int sales;
  int revenue;
  String id;
  String storeLogo;
  String storeName;
  String storeCategory;
  String location;
  String storeDescription;
  String userId;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  String storeId;
  String reason;

  factory StoresData.fromJson(Map<String, dynamic> json) => StoresData(
    status: Status.fromJson(json["status"]),
    products: List<String>.from(json["products"].map((x) => x)),
    sales: json["sales"],
    revenue: json["revenue"],
    id: json["_id"],
    storeLogo: json["store_logo"],
    storeName: json["store_name"],
    storeCategory: json["store_category"],
    location: json["location"],
    storeDescription: json["store_description"],
    userId: json["user_id"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    storeId: json["store_id"] == null ? null : json["store_id"],
    reason: json["reason"] == null ? null : json["reason"],
  );

  Map<String, dynamic> toJson() => {
    "status": status.toJson(),
    "products": List<dynamic>.from(products.map((x) => x)),
    "sales": sales,
    "revenue": revenue,
    "_id": id,
    "store_logo": storeLogo,
    "store_name": storeName,
    "store_category": storeCategory,
    "location": location,
    "store_description": storeDescription,
    "user_id": userId,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
    "store_id": storeId == null ? null : storeId,
    "reason": reason == null ? null : reason,
  };
}

class Status {
  Status({
    this.approvalStatus,
    this.subscription,
  });

  ApprovalStatus approvalStatus;
  int subscription;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
    approvalStatus: approvalStatusValues.map[json["approval_status"]],
    subscription: json["subscription"],
  );

  Map<String, dynamic> toJson() => {
    "approval_status": approvalStatusValues.reverse[approvalStatus],
    "subscription": subscription,
  };
}

enum ApprovalStatus { APPROVE, DECLINE, PENDING }

final approvalStatusValues = EnumValues({
  "approve": ApprovalStatus.APPROVE,
  "decline": ApprovalStatus.DECLINE,
  "pending": ApprovalStatus.PENDING
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
