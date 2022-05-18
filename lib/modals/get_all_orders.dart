// To parse this JSON data, do
//
//     final getAllOrdersModel = getAllOrdersModelFromJson(jsonString);

import 'dart:convert';

GetAllOrdersModel getAllOrdersModelFromJson(String str) => GetAllOrdersModel.fromJson(json.decode(str));

String getAllOrdersModelToJson(GetAllOrdersModel data) => json.encode(data.toJson());

class GetAllOrdersModel {
  GetAllOrdersModel({
    this.status,
    this.message,
    this.orders,
  });

  bool status;
  String message;
  List<Order> orders;

  factory GetAllOrdersModel.fromJson(Map<String, dynamic> json) => GetAllOrdersModel(
    status: json["status"],
    message: json["message"],
    orders: List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
  };
}

class Order {
  Order({
    this.paymentType,
    this.paymentStatus,
    this.status,
    this.id,
    this.customerId,
    this.userName,
    this.items,
    this.phone,
    this.address,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  PaymentType paymentType;
  bool paymentStatus;
  Status status;
  String id;
  String customerId;
  String userName;
  List<Item> items;
  String phone;
  String address;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    paymentType: paymentTypeValues.map[json["paymentType"]],
    paymentStatus: json["paymentStatus"],
    status: statusValues.map[json["status"]],
    id: json["_id"],
    customerId: json["customerId"],
    userName: json["userName"],
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    phone: json["phone"],
    address: json["address"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "paymentType": paymentTypeValues.reverse[paymentType],
    "paymentStatus": paymentStatus,
    "status": statusValues.reverse[status],
    "_id": id,
    "customerId": customerId,
    "userName": userName,
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "phone": phone,
    "address": address,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}

class Item {
  Item({
    this.id,
    this.price,
    this.imageUrl,
    this.productName,
    this.storeId,
    this.sold,
    this.time,
  });

  String id;
  String price;
  String imageUrl;
  String productName;
  String storeId;
  int sold;
  int time;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    price: json["price"],
    imageUrl: json["imageUrl"],
    productName: json["productName"],
    storeId: json["store_id"],
    sold: json["sold"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "price": price,
    "imageUrl": imageUrl,
    "productName": productName,
    "store_id": storeId,
    "sold": sold,
    "time": time,
  };
}

enum PaymentType { CARD_TYPE_AMERICAN_EXPRESS }

final paymentTypeValues = EnumValues({
  "CardType.americanExpress": PaymentType.CARD_TYPE_AMERICAN_EXPRESS
});

enum Status { PENDING, COMPLETED }

final statusValues = EnumValues({
  "Completed": Status.COMPLETED,
  "Pending": Status.PENDING
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
