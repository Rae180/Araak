
class RoomsByCategoryModel {
    Category? category;

    RoomsByCategoryModel({this.category});

    RoomsByCategoryModel.fromJson(Map<String, dynamic> json) {
        category = json["category"] == null ? null : Category.fromJson(json["category"]);
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        if(category != null) {
            _data["category"] = category?.toJson();
        }
        return _data;
    }
}

class Category {
    int? id;
    String? name;
    List<Rooms>? rooms;

    Category({this.id, this.name, this.rooms});

    Category.fromJson(Map<String, dynamic> json) {
        id = json["id"];
        name = json["name"];
        rooms = json["rooms"] == null ? null : (json["rooms"] as List).map((e) => Rooms.fromJson(e)).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["id"] = id;
        _data["name"] = name;
        if(rooms != null) {
            _data["rooms"] = rooms?.map((e) => e.toJson()).toList();
        }
        return _data;
    }
}

class Rooms {
    int? id;
    String? name;
    String? description;
    num? price;
    String? imageUrl;
    int? likesCount;
    num? averageRating;
    List<String>? feedbacks;

    Rooms({this.id, this.name, this.description, this.price, this.imageUrl, this.likesCount, this.averageRating, this.feedbacks});

    Rooms.fromJson(Map<String, dynamic> json) {
        id = json["id"];
        name = json["name"];
        description = json["description"];
        price = json["price"];
        imageUrl = json["image_url"];
        likesCount = json["likes_count"];
        averageRating = json["average_rating"];
        feedbacks = json["feedbacks"] == null ? null : List<String>.from(json["feedbacks"]);
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["id"] = id;
        _data["name"] = name;
        _data["description"] = description;
        _data["price"] = price;
        _data["image_url"] = imageUrl;
        _data["likes_count"] = likesCount;
        _data["average_rating"] = averageRating;
        if(feedbacks != null) {
            _data["feedbacks"] = feedbacks;
        }
        return _data;
    }
}