/*
import 'dart:convert';

StoreByCategory storeByCategoryFromJson(String str) => StoreByCategory.fromJson(json.decode(str));

String storeByCategoryToJson(StoreByCategory data) => json.encode(data.toJson());

class StoreByCategory {
  StoreByCategory({
    this.status,
    this.stores,
  });

  bool status;
  List<Store> stores;

  factory StoreByCategory.fromJson(Map<String, dynamic> json) => StoreByCategory(
    status: json["status"],
    stores: List<Store>.from(json["stores"].map((x) => Store.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "stores": List<dynamic>.from(stores.map((x) => x.toJson())),
  };
}

class Store {
  Store({
    this.products,
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
  });

  List<String> products;
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

  factory Store.fromJson(Map<String, dynamic> json) => Store(
    products: json.containsKey('products') ? List<String>.from(json["products"].map((x) => x)) : [],
    id: json["_id"],
    storeLogo: json["store_logo"],
    storeName: json["store_name"],
    storeCategory: json["store_category"],
    location: json["location"],
    storeDescription: json["store_description"],
    userId: json["user_id"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: json.containsKey('updatedAt') ? DateTime.parse(json["updatedAt"]) : DateTime.parse(json["createdAt"]),
    v: json.containsKey('__v') ? json["__v"] : 0,
  );

  Map<String, dynamic> toJson() => {
    "products": List<dynamic>.from(products.map((x) => x)),
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
  };
}
*/


// To parse this JSON data, do
//
//     final storeByCategory = storeByCategoryFromJson(jsonString);

import 'dart:convert';

StoreByCategory storeByCategoryFromJson(String str) => StoreByCategory.fromJson(json.decode(str));

String storeByCategoryToJson(StoreByCategory data) => json.encode(data.toJson());

class StoreByCategory {
  StoreByCategory({
    this.status,
    this.stores,
  });

  bool status;
  List<Store> stores;

  factory StoreByCategory.fromJson(Map<String, dynamic> json) => StoreByCategory(
    status: json["status"],
    stores: List<Store>.from(json["stores"].map((x) => Store.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "stores": List<dynamic>.from(stores.map((x) => x.toJson())),
  };
}

class Store {
  Store({
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
    this.storeGender,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.reason,
    this.endDate,
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
  String storeGender;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  String reason;
  int endDate;

  factory Store.fromJson(Map<String, dynamic> json) => Store(
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
    storeGender: json["store_gender"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    reason: json["reason"] == null ? null : json["reason"],
    endDate: json["end_date"] == null ? null : json["end_date"],
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
    "store_gender": storeGender,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
    "reason": reason == null ? null : reason,
    "end_date": endDate == null ? null : endDate,
  };
}

class Status {
  Status({
    this.approvalStatus,
    this.subscription,
  });

  String approvalStatus;
  int subscription;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
    approvalStatus: json["approval_status"],
    subscription: json["subscription"],
  );

  Map<String, dynamic> toJson() => {
    "approval_status": approvalStatus,
    "subscription": subscription,
  };
}
