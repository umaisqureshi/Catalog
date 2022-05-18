import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome{
  Welcome({
    this.userData,
    this.token,
    this.mainStore,
    this.status
  });

  UserData userData;
  String token;
  bool mainStore;
  bool status;

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
    userData: UserData.fromJson(json["user"]),
    token: json["access_token"],
    mainStore: json["mainStore"],
    status: json['status']
  );

  Map<String, dynamic> toJson() => {
    "user": userData.toJson(),
    "access_token": token,
    "mainStore": mainStore,
    "status": status
  };
}

class UserData {
  UserData({
    this.type,
    this.id,
    this.username,
    this.email,
    this.password,
    this.role,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  String type;
  String id;
  String username;
  String email;
  String password;
  String role;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    type: json["type"],
    id: json["_id"],
    username: json["username"],
    email: json["email"],
    password: json["password"],
    role: json["role"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "_id": id,
    "username": username,
    "email": email,
    "password": password,
    "role": role,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}
