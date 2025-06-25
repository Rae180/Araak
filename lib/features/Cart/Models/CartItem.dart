
class CartItem {
    List<Rooms>? rooms;
    List<Items>? items;
    num? totalPrice;
    num? totalTime;

    CartItem({this.rooms, this.items, this.totalPrice, this.totalTime});

    CartItem.fromJson(Map<String, dynamic> json) {
        rooms = json["rooms"] == null ? null : (json["rooms"] as List).map((e) => Rooms.fromJson(e)).toList();
        items = json["items"] == null ? null : (json["items"] as List).map((e) => Items.fromJson(e)).toList();
        totalPrice = json["total_price"];
        totalTime = json["total_time"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        if(rooms != null) {
            _data["rooms"] = rooms?.map((e) => e.toJson()).toList();
        }
        if(items != null) {
            _data["items"] = items?.map((e) => e.toJson()).toList();
        }
        _data["total_price"] = totalPrice;
        _data["total_time"] = totalTime;
        return _data;
    }
}

class Items {
    int? id;
    String? name;
    String? imageUrl;
    num? price;
    int? count;
    num? time;

    Items({this.id, this.name, this.imageUrl, this.price, this.count, this.time});

    Items.fromJson(Map<String, dynamic> json) {
        id = json["id"];
        name = json["name"];
        imageUrl = json["image_url"];
        price = json["price"];
        count = json["count"];
        time = json["time"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["id"] = id;
        _data["name"] = name;
        _data["image_url"] = imageUrl;
        _data["price"] = price;
        _data["count"] = count;
        _data["time"] = time;
        return _data;
    }
}

class Rooms {
    int? id;
    String? name;
    String? imageUrl;
    num? price;
    num? time;
    int? count;

    Rooms({this.id, this.name, this.imageUrl, this.price, this.time, this.count});

    Rooms.fromJson(Map<String, dynamic> json) {
        id = json["id"];
        name = json["name"];
        imageUrl = json["image_url"];
        price = json["price"];
        time = json["time"];
        count = json["count"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["id"] = id;
        _data["name"] = name;
        _data["image_url"] = imageUrl;
        _data["price"] = price;
        _data["time"] = time;
        _data["count"] = count;
        return _data;
    }
}