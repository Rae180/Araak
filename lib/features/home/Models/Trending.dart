
class Trending {
    List<TrendingItems>? trendingItems;
    List<TrendingRooms>? trendingRooms;

    Trending({this.trendingItems, this.trendingRooms});

    Trending.fromJson(Map<String, dynamic> json) {
        trendingItems = json["trending_items"] == null ? null : (json["trending_items"] as List).map((e) => TrendingItems.fromJson(e)).toList();
        trendingRooms = json["trending_rooms"] == null ? null : (json["trending_rooms"] as List).map((e) => TrendingRooms.fromJson(e)).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        if(trendingItems != null) {
            _data["trending_items"] = trendingItems?.map((e) => e.toJson()).toList();
        }
        if(trendingRooms != null) {
            _data["trending_rooms"] = trendingRooms?.map((e) => e.toJson()).toList();
        }
        return _data;
    }
}

class TrendingRooms {
    int? id;
    String? name;
    String? description;
    int? categoryId;
    String? imageUrl;
    String? createdAt;
    String? updatedAt;
    int? likesCount;

    TrendingRooms({this.id, this.name, this.description, this.categoryId, this.imageUrl, this.createdAt, this.updatedAt, this.likesCount});

    TrendingRooms.fromJson(Map<String, dynamic> json) {
        id = json["id"];
        name = json["name"];
        description = json["description"];
        categoryId = json["category_id"];
        imageUrl = json["image_url"];
        createdAt = json["created_at"];
        updatedAt = json["updated_at"];
        likesCount = json["likes_count"];
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
        _data["likes_count"] = likesCount;
        return _data;
    }
}

class TrendingItems {
    int? id;
    int? roomId;
    String? name;
    int? time;
    int? price;
    String? imageUrl;
    int? count;
    String? createdAt;
    String? updatedAt;
    int? likesCount;

    TrendingItems({this.id, this.roomId, this.name, this.time, this.price, this.imageUrl, this.count, this.createdAt, this.updatedAt, this.likesCount});

    TrendingItems.fromJson(Map<String, dynamic> json) {
        id = json["id"];
        roomId = json["room_id"];
        name = json["name"];
        time = json["time"];
        price = json["price"];
        imageUrl = json["image_url"];
        count = json["count"];
        createdAt = json["created_at"];
        updatedAt = json["updated_at"];
        likesCount = json["likes_count"];
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
        _data["likes_count"] = likesCount;
        return _data;
    }
}