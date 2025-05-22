class SearchResult {
    List<String>? types;
    List<Items>? items;

    SearchResult({this.types, this.items});

    SearchResult.fromJson(Map<String, dynamic> json) {
        types = json["types"] == null ? null : List<String>.from(json["types"]);
        items = json["items"] == null ? null : (json["items"] as List).map((e) => Items.fromJson(e)).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        if(types != null) {
            _data["types"] = types;
        }
        if(items != null) {
            _data["items"] = items?.map((e) => e.toJson()).toList();
        }
        return _data;
    }
}

class Items {
    int? id;
    int? roomId;
    String? name;
    int? time;
    num? price;
    String? imageUrl;
    int? count;
    int? countReserved;
    int? itemTypeId;
    String? createdAt;
    String? updatedAt;
    String? type;
    int? likesCount;
    num? totalRating;

    Items({this.id, this.roomId, this.name, this.time, this.price, this.imageUrl, this.count, this.countReserved, this.itemTypeId, this.createdAt, this.updatedAt, this.type, this.likesCount, this.totalRating});

    Items.fromJson(Map<String, dynamic> json) {
        id = json["id"];
        roomId = json["room_id"];
        name = json["name"];
        time = json["time"];
        price = json["price"];
        imageUrl = json["image_url"];
        count = json["count"];
        countReserved = json["count_reserved"];
        itemTypeId = json["item_type_id"];
        createdAt = json["created_at"];
        updatedAt = json["updated_at"];
        type = json["type"];
        likesCount = json["likes_count"];
        totalRating = json["total_rating"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["id"] = id;
        _data["room_id"] = roomId;
        _data["name"] = name;
        _data["time"] = time;
        _data["price"] = price;
        _data["image_url"] = imageUrl;
        _data["count"] = count;
        _data["count_reserved"] = countReserved;
        _data["item_type_id"] = itemTypeId;
        _data["created_at"] = createdAt;
        _data["updated_at"] = updatedAt;
        _data["type"] = type;
        _data["likes_count"] = likesCount;
        _data["total_rating"] = totalRating;
        return _data;
    }
}