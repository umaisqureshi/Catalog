/*
import 'dart:convert';

class GetAllStoreModel {
  bool status;
  String message;
  List<AllStoreItem> data;

  GetAllStoreModel({this.status, this.message, this.data});

  GetAllStoreModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(new AllStoreItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllStoreItem {
  Status status;
  List<String> products;
  int sales;
  int revenue;
  String sId;
  String storeLogo;
  String storeName;
  String storeCategory;
  String location;
  String storeDescription;
  String userId;
  String storeGender;
  String createdAt;
  String updatedAt;
  int iV;
  String reason;
  String endDate;

  AllStoreItem(
      {this.status,
        this.products,
        this.sales,
        this.revenue,
        this.sId,
        this.storeLogo,
        this.storeName,
        this.storeCategory,
        this.location,
        this.storeDescription,
        this.userId,
        this.storeGender,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.reason,
        this.endDate});

  AllStoreItem.fromJson(Map<String, dynamic> json) {
    status =
    json['status'] != null ? new Status.fromJson(json['status']) : null;
    products = json['products'].cast<String>();
    sales = json['sales'];
    revenue = json['revenue'];
    sId = json['_id'];
    storeLogo = json['store_logo'];
    storeName = json['store_name'];
    storeCategory = json['store_category'];
    location = json['location'];
    storeDescription = json['store_description'];
    userId = json['user_id'];
    storeGender = json['store_gender'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    reason = json['reason'];
    endDate = json['end_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.status != null) {
      data['status'] = this.status.toJson();
    }
    data['products'] = this.products;
    data['sales'] = this.sales;
    data['revenue'] = this.revenue;
    data['_id'] = this.sId;
    data['store_logo'] = this.storeLogo;
    data['store_name'] = this.storeName;
    data['store_category'] = this.storeCategory;
    data['location'] = this.location;
    data['store_description'] = this.storeDescription;
    data['user_id'] = this.userId;
    data['store_gender'] = this.storeGender;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['reason'] = this.reason;
    data['end_date'] = this.endDate;
    return data;
  }
}

class Status {
  String approvalStatus;
  int subscription;

  Status({this.approvalStatus, this.subscription});

  Status.fromJson(Map<String, dynamic> json) {
    approvalStatus = json['approval_status'];
    subscription = json['subscription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['approval_status'] = this.approvalStatus;
    data['subscription'] = this.subscription;
    return data;
  }
}*/


// To parse this JSON data, do
//
//     final getAllStoreModel = getAllStoreModelFromJson(jsonString);

import 'dart:convert';

GetAllStoreModel getAllStoreModelFromJson(String str) => GetAllStoreModel.fromJson(json.decode(str));

String getAllStoreModelToJson(GetAllStoreModel data) => json.encode(data.toJson());

class GetAllStoreModel {
  GetAllStoreModel({
    this.status,
    this.message,
    this.data,
  });

  bool status;
  String message;
  List<AllStoreItem> data;

  factory GetAllStoreModel.fromJson(Map<String, dynamic> json) => GetAllStoreModel(
    status: json["status"],
    message: json["message"],
    data: List<AllStoreItem>.from(json["data"].map((x) => AllStoreItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class AllStoreItem {
  AllStoreItem({
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
    this.endDate,
    this.reason,
  });

  Status status;
  List<String> products;
  int sales;
  double revenue;
  String id;
  String storeLogo;
  String storeName;
  String storeCategory;
  String location;
  String storeDescription;
  String userId;
  StoreGender storeGender;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  int endDate;
  String reason;

  factory AllStoreItem.fromJson(Map<String, dynamic> json) => AllStoreItem(
    status: Status.fromJson(json["status"]),
    products: List<String>.from(json["products"].map((x) => x)),
    sales: json["sales"],
    revenue: json["revenue"].toDouble(),
    id: json["_id"],
    storeLogo: json["store_logo"],
    storeName: json["store_name"],
    storeCategory: json["store_category"],
    location: json["location"],
    storeDescription: json["store_description"],
    userId: json["user_id"],
    storeGender: storeGenderValues.map[json["store_gender"]],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    endDate: json["end_date"] == null ? null : json["end_date"],
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
    "store_gender": storeGenderValues.reverse[storeGender],
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
    "end_date": endDate == null ? null : endDate,
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

enum ApprovalStatus { APPROVE, DECLINE }

final approvalStatusValues = EnumValues({
  "approve": ApprovalStatus.APPROVE,
  "decline": ApprovalStatus.DECLINE
});

enum StoreGender { MALE, FEMALE, OTHER }

final storeGenderValues = EnumValues({
  "Female": StoreGender.FEMALE,
  "Male": StoreGender.MALE,
  "Other": StoreGender.OTHER
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
