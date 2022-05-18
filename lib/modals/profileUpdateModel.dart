import 'dart:convert';

ProfileUpdateModel profileUpdateModelFromJson(String str) => ProfileUpdateModel.fromJson(json.decode(str));

String profileUpdateModelToJson(ProfileUpdateModel data) => json.encode(data.toJson());

class ProfileUpdateModel {
  ProfileUpdateModel({
    this.user,
  });

  User user;

  factory ProfileUpdateModel.fromJson(Map<String, dynamic> json) => ProfileUpdateModel(
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
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
    this.store,
    this.subStore,
    this.firstname,
    this.lastname,
    this.profileImg,
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
  String store;
  String subStore;
  String firstname;
  String lastname;
  String profileImg;

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
    store: json["store"],
    subStore: json["sub_store"],
    firstname: json["firstname"],
    lastname: json["lastname"],
    profileImg: json["profile_img"],
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
    "store": store,
    "sub_store": subStore,
    "firstname": firstname,
    "lastname": lastname,
    "profile_img": profileImg,
  };
}
