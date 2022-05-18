// To parse this JSON data, do
//
//     final changePassword = changePasswordFromJson(jsonString);

import 'dart:convert';

ChangePasswordModel changePasswordFromJson(String str) => ChangePasswordModel.fromJson(json.decode(str));

String changePasswordToJson(ChangePasswordModel data) => json.encode(data.toJson());

class ChangePasswordModel {
  ChangePasswordModel({
    this.status,
    this.message,
    this.user,
  });

  bool status;
  String message;
  User user;

  factory ChangePasswordModel.fromJson(Map<String, dynamic> json) => ChangePasswordModel(
    status: json["status"],
    message: json["message"],
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "user": user.toJson(),
  };
}

class User {
  User({
    this.type,
    this.id,
    this.username,
    this.email,
    this.password,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.role,
  });

  String type;
  String id;
  String username;
  String email;
  String password;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  String role;

  factory User.fromJson(Map<String, dynamic> json) => User(
    type: json["type"],
    id: json["_id"],
    username: json["username"],
    email: json["email"],
    password: json["password"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "_id": id,
    "username": username,
    "email": email,
    "password": password,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
    "role": role,
  };
}
