
// To parse this JSON data, do
//
//     final mainStore = mainStoreFromJson(jsonString);

import 'dart:convert';

MainStore mainStoreFromJson(String str) => MainStore.fromJson(json.decode(str));

String mainStoreToJson(MainStore data) => json.encode(data.toJson());

class MainStore {
  MainStore({
    this.store,
  });

  Store store;

  factory MainStore.fromJson(Map<String, dynamic> json) => MainStore(
    store: Store.fromJson(json["store"]),
  );

  Map<String, dynamic> toJson() => {
    "store": store.toJson(),
  };
}

class Store {
  Store({
    this.status,
    this.products,
    this.id,
    this.storeLogo,
    this.storeName,
    this.storeCategory,
    this.location,
    this.storeDescription,
    this.userId,
    this.createdAt,
    this.reason,
    this.sales,
    this.revenue,
    this.weight,
    this.color,
    this.size
  });

  Status status;
  List<dynamic> products;
  String id;
  String storeLogo;
  String storeName;
  String storeCategory;
  String location;
  String storeDescription;
  String userId;
  DateTime createdAt;
  String reason;
  int sales;
  int revenue;
  String size;
  String weight;
  String color;



  factory Store.fromJson(Map<String, dynamic> json) => Store(
    status: Status.fromJson(json["status"]),
    products: List<dynamic>.from(json["products"].map((x) => x)),
    id: json["_id"],
    storeLogo: json["store_logo"],
    storeName: json["store_name"],
    storeCategory: json["store_category"],
    location: json["location"],
    storeDescription: json["store_description"],
    userId: json["user_id"],
    createdAt: DateTime.parse(json["createdAt"]),
    reason: json.containsKey('reason') ? json['reason'] : "",
    sales: json["sales"],
      revenue: json["revenue"]
  );

  Map<String, dynamic> toJson() => {
    "status": status.toJson(),
    "products": List<dynamic>.from(products.map((x) => x)),
    "_id": id,
    "store_logo": storeLogo,
    "store_name": storeName,
    "store_category": storeCategory,
    "location": location,
    "store_description": storeDescription,
    "user_id": userId,
    "createdAt": createdAt.toIso8601String(),
    "reason" : reason.isNotEmpty ? reason : "",
    "sales": sales,
    "revenue": revenue
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
