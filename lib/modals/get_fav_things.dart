// To parse this JSON data, do
//
//     final getFavThings = getFavThingsFromJson(jsonString);

import 'dart:convert';

GetFavThings getFavThingsFromJson(String str) => GetFavThings.fromJson(json.decode(str));

String getFavThingsToJson(GetFavThings data) => json.encode(data.toJson());

class GetFavThings {
  GetFavThings({
    this.status,
    this.message,
    this.data,
  });

  bool status;
  String message;
  Data data;

  factory GetFavThings.fromJson(Map<String, dynamic> json) => GetFavThings(
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

  List<FavStore> stores;
  List<FavProduct> products;
  List<FavouriteSubStore> substores;
  String id;
  String customerId;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    stores: json['stores'].first == null ? [] : List<FavStore>.from(json["stores"].map((x) => FavStore.fromJson(x))),
    products: json['products'].first == null ? [] : List<FavProduct>.from(json["products"].map((x) => FavProduct.fromJson(x))),
    substores: json['substores'].first == null ? [] : List<FavStore>.from(json["substores"].map((x) => FavouriteSubStore.fromJson(x))),
    id: json["_id"],
    customerId: json["customerId"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "stores": List<dynamic>.from(stores.map((x) => x.toJson())),
    "products":  List<dynamic>.from(products.map((x) => x.toJson())),
    "substores": List<dynamic>.from(substores.map((x) => x.toJson())),
    "_id": id,
    "customerId": customerId,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}

class FavProduct {
  FavProduct({
    this.images,
    this.sold,
    this.id,
    this.productName,
    this.productCategory,
    this.productFilters,
    this.productDescription,
    this.price,
    this.stock,
    this.storeId,
    this.createdAt,
  });

  List<String> images;
  int sold;
  String id;
  String productName;
  String productCategory;
  String productFilters;
  String productDescription;
  int price;
  int stock;
  String storeId;
  DateTime createdAt;

  factory FavProduct.fromJson(Map<String, dynamic> json) => FavProduct(
    images: List<String>.from(json["images"].map((x) => x)),
    sold: json["sold"],
    id: json["_id"],
    productName: json["product_name"],
    productCategory: json["product_category"],
    productFilters: json["product_filters"],
    productDescription: json["product_description"],
    price: json["price"],
    stock: json["stock"],
    storeId: json["store_id"],
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "images": List<dynamic>.from(images.map((x) => x)),
    "sold": sold,
    "_id": id,
    "product_name": productName,
    "product_category": productCategory,
    "product_filters": productFilters,
    "product_description": productDescription,
    "price": price,
    "stock": stock,
    "store_id": storeId,
    "createdAt": createdAt.toIso8601String(),
  };
}

class FavStore {
  FavStore({
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
    this.reason,
    this.storeId,
  });

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
  String reason;
  String storeId;

  factory FavStore.fromJson(Map<String, dynamic> json) => FavStore(
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
    reason: json["reason"] == null ? null : json["reason"],
    storeId: json["store_id"] == null ? null : json["store_id"],
  );

  Map<String, dynamic> toJson() => {
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
    "reason": reason == null ? null : reason,
    "store_id": storeId == null ? null : storeId,
  };
}


class FavouriteSubStore {
  FavouriteSubStore({
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
    this.reason,
    this.storeId,
  });

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
  String reason;
  String storeId;

  factory FavouriteSubStore.fromJson(Map<String, dynamic> json) => FavouriteSubStore(
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
    reason: json["reason"] == null ? null : json["reason"],
    storeId: json["store_id"] == null ? null : json["store_id"],
  );

  Map<String, dynamic> toJson() => {
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
    "reason": reason == null ? null : reason,
    "store_id": storeId == null ? null : storeId,
  };
}
