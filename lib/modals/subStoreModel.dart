import 'dart:convert';

SubStoreModel subStoreModelFromJson(String str) => SubStoreModel.fromJson(json.decode(str));

String subStoreModelToJson(SubStoreModel data) => json.encode(data.toJson());

class SubStoreModel {
  SubStoreModel({
    this.stores,
  });

  List<SubStoreH> stores;

  factory SubStoreModel.fromJson(Map<String, dynamic> json) => SubStoreModel(
    stores: List<SubStoreH>.from(json["stores"].map((x) => SubStoreH.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "stores": List<dynamic>.from(stores.map((x) => x.toJson())),
  };
}

class SubStoreH {
  SubStoreH({
    this.approvalStatus,
    this.products,
    this.id,
    this.storeLogo,
    this.storeName,
    this.storeCategory,
    this.location,
    this.storeDescription,
    this.storeId,
    this.userId,
    this.createdAt,
  });

  String approvalStatus;
  List<dynamic> products;
  String id;
  String storeLogo;
  String storeName;
  String storeCategory;
  String location;
  String storeDescription;
  String storeId;
  String userId;
  DateTime createdAt;

  factory SubStoreH.fromJson(Map<String, dynamic> json) => SubStoreH(
    approvalStatus: json["approval_status"],
    products: json.containsKey('products') ? List<dynamic>.from(json["products"].map((x) => x)) : [],
    id: json["_id"],
    storeLogo: json["store_logo"],
    storeName: json["store_name"],
    storeCategory: json["store_category"],
    location: json["location"],
    storeDescription: json["store_description"],
    storeId: json["store_id"],
    userId: json["user_id"],
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "approval_status": approvalStatus,
    "products": List<dynamic>.from(products.map((x) => x)),
    "_id": id,
    "store_logo": storeLogo,
    "store_name": storeName,
    "store_category": storeCategory,
    "location": location,
    "store_description": storeDescription,
    "store_id": storeId,
    "user_id": userId,
    "createdAt": createdAt.toIso8601String(),
  };
}
