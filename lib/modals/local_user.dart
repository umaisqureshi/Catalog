import 'dart:collection';

class LocalUser{
  String email;
  String phone;
  String username;
  String category;
  String password;

  LocalUser.name(
      {
      this.email,
      this.phone,
      this.username,
      this.category,
      this.password});

  toMap(){
    Map<String, dynamic>  map =  Map<String, dynamic>();
    map['email'] = email??'';
    map['phone'] = phone??'';
    map['username'] = username??'';
    map['category'] = category??'';
    return map;
  }

  @override
  String toString() {
    return 'LocalUser{email: $email, phone: $phone, username: $username, category: $category, password: $password}';
  }
}