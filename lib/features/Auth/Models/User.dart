import 'dart:io';

class User {
  String? name;
  String? password;
  String? C_password;
  String? email;
  File? profileImage;
  String? phoneNumber;

  User(
      {this.name,
      this.email,
      this.profileImage,
      this.phoneNumber,
      this.password,
      this.C_password});

  User.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    email = json["email"];
    password = json["password"];
    C_password = json["C_password"];
    profileImage = json["profile_image"];
    phoneNumber = json["phone_number"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["name"] = name;
    _data["email"] = email;
    _data["password"] = password;
    _data["C_password"] = C_password;
    _data["profile_image"] = profileImage;
    _data["phone_number"] = phoneNumber;
    return _data;
  }
}
