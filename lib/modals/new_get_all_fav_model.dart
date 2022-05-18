// To parse this JSON data, do
//
//     final newGetFavThings = newGetFavThingsFromJson(jsonString);

import 'dart:convert';

NewGetFavThings newGetFavThingsFromJson(String str) =>
    NewGetFavThings.fromJson(json.decode(str));

String newGetFavThingsToJson(NewGetFavThings data) =>
    json.encode(data.toJson());

class NewGetFavThings {
  NewGetFavThings({
    this.status,
    this.message,
    this.data,
  });

  bool status;
  String message;
  Data data;

  factory NewGetFavThings.fromJson(Map<String, dynamic> json) =>
      NewGetFavThings(
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

  List<NewStore> stores;
  List<NewProduct> products;
  List<NewSubStore> substores;
  String id;
  String customerId;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        stores: List<NewStore>.from(json["stores"].map((x) => NewStore.fromJson(x))),
        products: List<NewProduct>.from(
            json["products"].map((x) => NewProduct.fromJson(x))),
        substores: List<NewSubStore>.from(json["substores"].map((x) => NewSubStore.fromJson(x))),
        id: json["_id"],
        customerId: json["customerId"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "stores": List<dynamic>.from(stores.map((x) => x.toJson())),
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
        "substores": List<dynamic>.from(substores.map((x) => x.toJson())),
        "_id": id,
        "customerId": customerId,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}

class NewProduct {
  NewProduct({
    this.images,
    this.sold,
    this.id,
    this.productName,
    this.productCategory,
    this.productFilters,
    this.productDescription,
    this.size,
    this.price,
    this.weight,
    this.color,
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
  String size;
  int price;
  String weight;
  int color;
  int stock;
  String storeId;
  DateTime createdAt;

  factory NewProduct.fromJson(Map<String, dynamic> json) => NewProduct(
        images: List<String>.from(json["images"].map((x) => x)),
        sold: json["sold"],
        id: json["_id"],
        productName: json["product_name"],
        productCategory: json["product_category"],
        productFilters: json["product_filters"],
        productDescription: json["product_description"],
        size: json["size"],
        price: json["price"],
        weight: json["weight"],
        color: json["color"],
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
        "size": size,
        "price": price,
        "weight": weight,
        "color": color,
        "stock": stock,
        "store_id": storeId,
        "createdAt": createdAt.toIso8601String(),
      };
}

class NewStore {
  NewStore({
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
  String storeGender;
  DateTime createdAt;

  factory NewStore.fromJson(Map<String, dynamic> json) => NewStore(
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
        "store_gender": storeGender,
        "createdAt": createdAt.toIso8601String(),
      };
}

class NewSubStore {
  NewSubStore({
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
  String storeGender;
  DateTime createdAt;

  factory NewSubStore.fromJson(Map<String, dynamic> json) => NewSubStore(
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
    "store_gender": storeGender,
    "createdAt": createdAt.toIso8601String(),
  };
}