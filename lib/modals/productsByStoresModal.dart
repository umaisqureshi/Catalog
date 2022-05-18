// To parse this JSON data, do
//
//     final productsByStore = productsByStoreFromJson(jsonString);

import 'dart:convert';

ProductsByStore productsByStoreFromJson(String str) => ProductsByStore.fromJson(json.decode(str));

String productsByStoreToJson(ProductsByStore data) => json.encode(data.toJson());

class ProductsByStore {
  ProductsByStore({
    this.status,
    this.message,
    this.products,
  });

  bool status;
  String message;
  List<Product> products;

  factory ProductsByStore.fromJson(Map<String, dynamic> json) => ProductsByStore(
    status: json["status"],
    message: json["message"],
    products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "products": List<dynamic>.from(products.map((x) => x.toJson())),
  };
}

class Product {
  Product({
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
    this.updatedAt,
    this.v,
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
  DateTime updatedAt;
  int v;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
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
    stock: json["stock"] ?? "",
    storeId: json["store_id"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
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
    "stock": stock ?? "",
    "store_id": storeId,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}
