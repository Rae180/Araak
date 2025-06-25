
class UserData {
    String? name;
    String? phone;
    String? password;
    String? image;
    String? email;

    UserData({this.name, this.phone, this.password, this.image, this.email});

    UserData.fromJson(Map<String, dynamic> json) {
        name = json["name"];
        phone = json["phone"];
        password = json["password"];
        image = json["image"];
        email = json["email"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["name"] = name;
        _data["phone"] = phone;
        _data["password"] = password;
        _data["image"] = image;
        _data["email"] = email;
        return _data;
    }
}