// To parse this JSON data, do
//
//     final cartAllItemsRemove = cartAllItemsRemoveFromJson(jsonString);

import 'dart:convert';

CartAllItemsRemove cartAllItemsRemoveFromJson(String str) => CartAllItemsRemove.fromJson(json.decode(str));

String cartAllItemsRemoveToJson(CartAllItemsRemove data) => json.encode(data.toJson());

class CartAllItemsRemove {
  CartAllItemsRemove({
    this.status,
    this.message,
    this.cart,
  });

  bool status;
  String message;
  CartAllItem cart;

  factory CartAllItemsRemove.fromJson(Map<String, dynamic> json) => CartAllItemsRemove(
    status: json["status"],
    message: json["message"],
    cart: CartAllItem.fromJson(json["cart"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "cart": cart.toJson(),
  };
}

class CartAllItem {
  CartAllItem({
    this.n,
    this.opTime,
    this.electionId,
    this.ok,
    this.clusterTime,
    this.operationTime,
    this.deletedCount,
  });

  int n;
  OpTime opTime;
  String electionId;
  int ok;
  ClusterTime clusterTime;
  String operationTime;
  int deletedCount;

  factory CartAllItem.fromJson(Map<String, dynamic> json) => CartAllItem(
    n: json["n"],
    opTime: OpTime.fromJson(json["opTime"]),
    electionId: json["electionId"],
    ok: json["ok"],
    clusterTime: ClusterTime.fromJson(json["\u0024clusterTime"]),
    operationTime: json["operationTime"],
    deletedCount: json["deletedCount"],
  );

  Map<String, dynamic> toJson() => {
    "n": n,
    "opTime": opTime.toJson(),
    "electionId": electionId,
    "ok": ok,
    "\u0024clusterTime": clusterTime.toJson(),
    "operationTime": operationTime,
    "deletedCount": deletedCount,
  };
}

class ClusterTime {
  ClusterTime({
    this.clusterTime,
    this.signature,
  });

  String clusterTime;
  Signature signature;

  factory ClusterTime.fromJson(Map<String, dynamic> json) => ClusterTime(
    clusterTime: json["clusterTime"],
    signature: Signature.fromJson(json["signature"]),
  );

  Map<String, dynamic> toJson() => {
    "clusterTime": clusterTime,
    "signature": signature.toJson(),
  };
}

class Signature {
  Signature({
    this.hash,
    this.keyId,
  });

  String hash;
  String keyId;

  factory Signature.fromJson(Map<String, dynamic> json) => Signature(
    hash: json["hash"],
    keyId: json["keyId"],
  );

  Map<String, dynamic> toJson() => {
    "hash": hash,
    "keyId": keyId,
  };
}

class OpTime {
  OpTime({
    this.ts,
    this.t,
  });

  String ts;
  int t;

  factory OpTime.fromJson(Map<String, dynamic> json) => OpTime(
    ts: json["ts"],
    t: json["t"],
  );

  Map<String, dynamic> toJson() => {
    "ts": ts,
    "t": t,
  };
}
