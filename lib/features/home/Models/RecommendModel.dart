class RecommendModel {
  List<RecommendedItems>? recommendedItems;
  List<RecommendedRooms>? recommendedRooms;

  RecommendModel({
    this.recommendedItems,
    this.recommendedRooms,
  });

  RecommendModel.fromJson(Map<String, dynamic> json) {
    recommendedItems = json["recommended_items"] == null
        ? null
        : (json["recommended_items"] as List)
            .map((e) => RecommendedItems.fromJson(e))
            .toList();
    recommendedRooms = json["recommended_rooms"] == null
        ? null
        : (json["recommended_rooms"] as List)
            .map((e) => RecommendedRooms.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if (recommendedItems != null) {
      _data["recommended_items"] =
          recommendedItems?.map((e) => e.toJson()).toList();
    }
    if (recommendedRooms != null) {
      _data["recommended_rooms"] =
          recommendedRooms?.map((e) => e.toJson()).toList();
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
  int? countReserved;
  String? time;
  num? price;
  int? count;
  String? woodType;
  String? woodColor;
  String? fabricType;
  String? fabricColor;
  String? createdAt;
  String? updatedAt;
  String? ratingsAvgRate;
  List<dynamic>? items;
  num? averageRating;

  RecommendedRooms(
      {this.id,
      this.name,
      this.description,
      this.categoryId,
      this.imageUrl,
      this.countReserved,
      this.time,
      this.price,
      this.count,
      this.woodType,
      this.woodColor,
      this.fabricType,
      this.fabricColor,
      this.createdAt,
      this.updatedAt,
      this.ratingsAvgRate,
      this.items,
      this.averageRating});

  RecommendedRooms.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    description = json["description"];
    categoryId = json["category_id"];
    imageUrl = json["image_url"];
    countReserved = json["count_reserved"];
    time = json["time"];
    price = json["price"];
    count = json["count"];
    woodType = json["wood_type"];
    woodColor = json["wood_color"];
    fabricType = json["fabric_type"];
    fabricColor = json["fabric_color"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    ratingsAvgRate = json["ratings_avg_rate"];
    items = json["items"] ?? [];
    averageRating = json["average_rating"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["description"] = description;
    _data["category_id"] = categoryId;
    _data["image_url"] = imageUrl;
    _data["count_reserved"] = countReserved;
    _data["time"] = time;
    _data["price"] = price;
    _data["count"] = count;
    _data["wood_type"] = woodType;
    _data["wood_color"] = woodColor;
    _data["fabric_type"] = fabricType;
    _data["fabric_color"] = fabricColor;
    _data["created_at"] = createdAt;
    _data["updated_at"] = updatedAt;
    _data["ratings_avg_rate"] = ratingsAvgRate;
    if (items != null) {
      _data["items"] = items;
    }
    _data["average_rating"] = averageRating;
    return _data;
  }
}

class RecommendedItems {
  int? id;
  int? roomId;
  String? name;
  num? time;
  num? price;
  String? imageUrl;
  String? description;
  String? woodColor;
  String? woodType;
  String? fabricType;
  String? fabricColor;
  int? count;
  int? countReserved;
  int? itemTypeId;
  String? createdAt;
  String? updatedAt;
  String? ratingsAvgRate;
  Room? room;
  int? categoryId;
  num? averageRating;

  RecommendedItems(
      {this.id,
      this.roomId,
      this.name,
      this.time,
      this.price,
      this.imageUrl,
      this.description,
      this.woodColor,
      this.woodType,
      this.fabricType,
      this.fabricColor,
      this.count,
      this.countReserved,
      this.itemTypeId,
      this.createdAt,
      this.updatedAt,
      this.ratingsAvgRate,
      this.room,
      this.categoryId,
      this.averageRating});

  RecommendedItems.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    roomId = json["room_id"];
    name = json["name"];
    time = json["time"];
    price = json["price"];
    imageUrl = json["image_url"];
    description = json["description"];
    woodColor = json["wood_color"];
    woodType = json["wood_type"];
    fabricType = json["fabric_type"];
    fabricColor = json["fabric_color"];
    count = json["count"];
    countReserved = json["count_reserved"];
    itemTypeId = json["item_type_id"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    ratingsAvgRate = json["ratings_avg_rate"];
    room = json["room"] == null ? null : Room.fromJson(json["room"]);
    categoryId = json["category_id"];
    averageRating = json["average_rating"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["room_id"] = roomId;
    _data["name"] = name;
    _data["time"] = time;
    _data["price"] = price;
    _data["image_url"] = imageUrl;
    _data["description"] = description;
    _data["wood_color"] = woodColor;
    _data["wood_type"] = woodType;
    _data["fabric_type"] = fabricType;
    _data["fabric_color"] = fabricColor;
    _data["count"] = count;
    _data["count_reserved"] = countReserved;
    _data["item_type_id"] = itemTypeId;
    _data["created_at"] = createdAt;
    _data["updated_at"] = updatedAt;
    _data["ratings_avg_rate"] = ratingsAvgRate;
    if (room != null) {
      _data["room"] = room?.toJson();
    }
    _data["category_id"] = categoryId;
    _data["average_rating"] = averageRating;
    return _data;
  }
}

class Room {
  int? id;
  String? name;
  String? description;
  int? categoryId;
  String? imageUrl;
  int? countReserved;
  String? time;
  num? price;
  int? count;
  String? woodType;
  String? woodColor;
  String? fabricType;
  String? fabricColor;
  String? createdAt;
  String? updatedAt;

  Room(
      {this.id,
      this.name,
      this.description,
      this.categoryId,
      this.imageUrl,
      this.countReserved,
      this.time,
      this.price,
      this.count,
      this.woodType,
      this.woodColor,
      this.fabricType,
      this.fabricColor,
      this.createdAt,
      this.updatedAt});

  Room.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    description = json["description"];
    categoryId = json["category_id"];
    imageUrl = json["image_url"];
    countReserved = json["count_reserved"];
    time = json["time"];
    price = json["price"];
    count = json["count"];
    woodType = json["wood_type"];
    woodColor = json["wood_color"];
    fabricType = json["fabric_type"];
    fabricColor = json["fabric_color"];
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
    _data["count_reserved"] = countReserved;
    _data["time"] = time;
    _data["price"] = price;
    _data["count"] = count;
    _data["wood_type"] = woodType;
    _data["wood_color"] = woodColor;
    _data["fabric_type"] = fabricType;
    _data["fabric_color"] = fabricColor;
    _data["created_at"] = createdAt;
    _data["updated_at"] = updatedAt;
    return _data;
  }
}
