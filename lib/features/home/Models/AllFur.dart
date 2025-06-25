
class AllFur {
    List<AllRooms>? allRooms;

    AllFur({this.allRooms});

    AllFur.fromJson(Map<String, dynamic> json) {
        allRooms = json["allRooms"] == null ? null : (json["allRooms"] as List).map((e) => AllRooms.fromJson(e)).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        if(allRooms != null) {
            _data["allRooms"] = allRooms?.map((e) => e.toJson()).toList();
        }
        return _data;
    }
}

class AllRooms {
    int? id;
    String? name;
    int? time;
    num? price;
    String? description;
    String? imageUrl;
    int? likeCount;
    num? averageRating;
    List<dynamic>? items;

    AllRooms({this.id, this.name, this.time, this.price, this.description, this.imageUrl, this.likeCount, this.averageRating, this.items});

    AllRooms.fromJson(Map<String, dynamic> json) {
        id = json["id"];
        name = json["name"];
        time = json["time"];
        price = json["price"];
        description = json["description"];
        imageUrl = json["image_url"];
        likeCount = json["like_count"];
        averageRating = json["average_rating"];
        items = json["items"] ?? [];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["id"] = id;
        _data["name"] = name;
        _data["time"] = time;
        _data["price"] = price;
        _data["description"] = description;
        _data["image_url"] = imageUrl;
        _data["like_count"] = likeCount;
        _data["average_rating"] = averageRating;
        if(items != null) {
            _data["items"] = items;
        }
        return _data;
    }
}