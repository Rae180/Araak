
class RecommendModel {
    List<RecommendedItems>? recommendedItems;
    List<RecommendedRooms>? recommendedRooms;

    RecommendModel({this.recommendedItems, this.recommendedRooms});

    RecommendModel.fromJson(Map<String, dynamic> json) {
        recommendedItems = json["recommended_items"] == null ? null : (json["recommended_items"] as List).map((e) => RecommendedItems.fromJson(e)).toList();
        recommendedRooms = json["recommended_rooms"] == null ? null : (json["recommended_rooms"] as List).map((e) => RecommendedRooms.fromJson(e)).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        if(recommendedItems != null) {
            _data["recommended_items"] = recommendedItems?.map((e) => e.toJson()).toList();
        }
        if(recommendedRooms != null) {
            _data["recommended_rooms"] = recommendedRooms?.map((e) => e.toJson()).toList();
        }
        return _data;
    }
}

class RecommendedRooms {
    int? id;
    String? name;
    String? description;
    int? categoryId;
    String? imageUrl;
    String? createdAt;
    String? updatedAt;
    List<Items>? items;

    RecommendedRooms({this.id, this.name, this.description, this.categoryId, this.imageUrl, this.createdAt, this.updatedAt, this.items});

    RecommendedRooms.fromJson(Map<String, dynamic> json) {
        id = json["id"];
        name = json["name"];
        description = json["description"];
        categoryId = json["category_id"];
        imageUrl = json["image_url"];
        createdAt = json["created_at"];
        updatedAt = json["updated_at"];
        items = json["items"] == null ? null : (json["items"] as List).map((e) => Items.fromJson(e)).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["id"] = id;
        _data["name"] = name;
        _data["description"] = description;
        _data["category_id"] = categoryId;
        _data["image_url"] = imageUrl;
        _data["created_at"] = createdAt;
        _data["updated_at"] = updatedAt;
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
    int? price;
    String? imageUrl;
    int? count;
    String? createdAt;
    String? updatedAt;

    Items({this.id, this.roomId, this.name, this.time, this.price, this.imageUrl, this.count, this.createdAt, this.updatedAt});

    Items.fromJson(Map<String, dynamic> json) {
        id = json["id"];
        roomId = json["room_id"];
        name = json["name"];
        time = json["time"];
        price = json["price"];
        imageUrl = json["image_url"];
        count = json["count"];
        createdAt = json["created_at"];
        updatedAt = json["updated_at"];
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
        _data["created_at"] = createdAt;
        _data["updated_at"] = updatedAt;
        return _data;
    }
}

class RecommendedItems {
    int? id;
    int? roomId;
    String? name;
    int? time;
    int? price;
    String? imageUrl;
    int? count;
    String? createdAt;
    String? updatedAt;
    Room? room;
    int? categoryId;

    RecommendedItems({this.id, this.roomId, this.name, this.time, this.price, this.imageUrl, this.count, this.createdAt, this.updatedAt, this.room, this.categoryId});

    RecommendedItems.fromJson(Map<String, dynamic> json) {
        id = json["id"];
        roomId = json["room_id"];
        name = json["name"];
        time = json["time"];
        price = json["price"];
        imageUrl = json["image_url"];
        count = json["count"];
        createdAt = json["created_at"];
        updatedAt = json["updated_at"];
        room = json["room"] == null ? null : Room.fromJson(json["room"]);
        categoryId = json["category_id"];
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
        _data["created_at"] = createdAt;
        _data["updated_at"] = updatedAt;
        if(room != null) {
            _data["room"] = room?.toJson();
        }
        _data["category_id"] = categoryId;
        return _data;
    }
}

class Room {
    int? id;
    String? name;
    String? description;
    int? categoryId;
    String? imageUrl;
    String? createdAt;
    String? updatedAt;

    Room({this.id, this.name, this.description, this.categoryId, this.imageUrl, this.createdAt, this.updatedAt});

    Room.fromJson(Map<String, dynamic> json) {
        id = json["id"];
        name = json["name"];
        description = json["description"];
        categoryId = json["category_id"];
        imageUrl = json["image_url"];
        createdAt = json["created_at"];
        updatedAt = json["updated_at"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["id"] = id;
        _data["name"] = name;
        _data["description"] = description;
        _data["category_id"] = categoryId;
        _data["image_url"] = imageUrl;
        _data["created_at"] = createdAt;
        _data["updated_at"] = updatedAt;
        return _data;
    }
}