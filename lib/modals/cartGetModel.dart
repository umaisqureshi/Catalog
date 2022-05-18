// To parse this JSON data, do
//
//     final cartGetModel = cartGetModelFromJson(jsonString);

import 'dart:convert';

CartGetModel cartGetModelFromJson(String str) => CartGetModel.fromJson(json.decode(str));

String cartGetModelToJson(CartGetModel data) => json.encode(data.toJson());

class CartGetModel {
  CartGetModel({
    this.status,
    this.message,
    this.cart,
  });

  bool status;
  String message;
  Cart cart;

  factory CartGetModel.fromJson(Map<String, dynamic> json) => CartGetModel(
    status: json["status"],
    message: json["message"],
    cart: Cart.fromJson(json["cart"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "cart": cart.toJson(),
  };
}

class Cart {
  Cart({
    this.products,
    this.id,
    this.customerId,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  List<CartProduct> products;
  String id;
  String customerId;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
    products: List<CartProduct>.from(json["products"].map((x) => CartProduct.fromJson(x))),
    id: json["_id"],
    customerId: json["customerId"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "products": List<dynamic>.from(products.map((x) => x.toJson())),
    "_id": id,
    "customerId": customerId,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}

class CartProduct {
  CartProduct({
    this.id,
    this.price,
    this.imageUrl,
    this.productName,
    this.sold,
    this.storeId,
    this.storeName,
    this.time

  });

  String id;
  String price;
  String imageUrl;
  String productName;
  int sold;
  String storeId;
  String storeName;
  int time;

  factory CartProduct.fromJson(Map<String, dynamic> json) => CartProduct(
      id: json["id"],
      price: json["price"],
      imageUrl: json["imageUrl"],
      productName: json["productName"],
      sold: json["sold"],
      storeId: json["store_id"],
      storeName: json["store_name"],
      time: json["time"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "price": price,
    "imageUrl": imageUrl,
    "productName": productName,
    "sold": sold,
    "store_id": storeId,
    "store_name": storeName,
    "time": time
  };
}
