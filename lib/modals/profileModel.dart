import 'dart:convert';

ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  ProfileModel({
    this.id,
    this.username,
    this.email,
    this.createdAt,
    this.role,
    this.store,
    this.firstname,
    this.lastname,
    this.profileImg,
  });

  String id;
  String username;
  String email;
  DateTime createdAt;
  String role;
  String store;
  String firstname;
  String lastname;
  String profileImg;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    id: json["_id"],
    username: json["username"],
    email: json["email"],
    createdAt: DateTime.parse(json["createdAt"]),
    role: json["role"],
    store: json["store"],
    firstname: json["firstname"],
    lastname: json["lastname"],
    profileImg: json["profile_img"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "username": username,
    "email": email,
    "createdAt": createdAt.toIso8601String(),
    "role": role,
    "store": store,
    "firstname": firstname,
    "lastname": lastname,
    "profile_img": profileImg,
  };
}
