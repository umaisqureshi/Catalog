// To parse this JSON data, do
//
//     final cartRemoveItem = cartRemoveItemFromJson(jsonString);

import 'dart:convert';

CartRemoveItem cartRemoveItemFromJson(String str) => CartRemoveItem.fromJson(json.decode(str));

String cartRemoveItemToJson(CartRemoveItem data) => json.encode(data.toJson());

class CartRemoveItem {
  CartRemoveItem({
    this.status,
    this.message,
    this.cart,
  });

  bool status;
  String message;
  CartRemove cart;

  factory CartRemoveItem.fromJson(Map<String, dynamic> json) => CartRemoveItem(
    status: json["status"],
    message: json["message"],
    cart: CartRemove.fromJson(json["cart"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "cart": cart.toJson(),
  };
}

class CartRemove {
  CartRemove({
    this.products,
    this.id,
    this.customerId,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  List<Product> products;
  String id;
  String customerId;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  factory CartRemove.fromJson(Map<String, dynamic> json) => CartRemove(
    products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
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

class Product {
  Product({
    this.id,
    this.price,
    this.imageUrl,
    this.productName,
  });

  String id;
  String price;
  String imageUrl;
  String productName;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    price: json["price"],
    imageUrl: json["imageUrl"],
    productName: json["productName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "price": price,
    "imageUrl": imageUrl,
    "productName": productName,
  };
}
