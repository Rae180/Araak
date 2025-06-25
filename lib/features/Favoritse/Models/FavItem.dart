class FavItem {
  List<Rooms>? rooms;
  List<Items>? items;

  FavItem({this.rooms, this.items});

  FavItem.fromJson(Map<String, dynamic> json) {
    rooms = json["rooms"] == null
        ? null
        : (json["rooms"] as List).map((e) => Rooms.fromJson(e)).toList();
    items = json["items"] == null
        ? null
        : (json["items"] as List).map((e) => Items.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if (rooms != null) {
      _data["rooms"] = rooms?.map((e) => e.toJson()).toList();
    }
    if (items != null) {
      _data["items"] = items?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class Items {
  int? id;
  int? roomId;
  String? name;
  String? time;
  num? price;
  String? imageUrl;
  int? count;
  int? countReserved;
  int? itemTypeId;
  String? createdAt;
  String? updatedAt;
  bool? isFavorite;
  int? likesCount;
  num? totalRating;
  dynamic itemDetail;

  Items(
      {this.id,
      this.roomId,
      this.name,
      this.time,
      this.price,
      this.imageUrl,
      this.count,
      this.countReserved,
      this.itemTypeId,
      this.createdAt,
      this.updatedAt,
      this.isFavorite,
      this.likesCount,
      this.totalRating,
      this.itemDetail});

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
    isFavorite = json["is_favorite"];
    likesCount = json["likes_count"];
    totalRating = json["total_rating"];
    itemDetail = json["item_detail"];
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
    _data["is_favorite"] = isFavorite;
    _data["likes_count"] = likesCount;
    _data["total_rating"] = totalRating;
    _data["item_detail"] = itemDetail;
    return _data;
  }
}

class Rooms {
  int? id;
  String? name;
  String? description;
  int? categoryId;
  String? imageUrl;
  int? countReserved;
  String? time;
  num? price;
  int? count;
  String? createdAt;
  String? updatedAt;
  int? likesCount;
  num? totalRating;
  List<dynamic>? items;

  Rooms(
      {this.id,
      this.name,
      this.description,
      this.categoryId,
      this.imageUrl,
      this.countReserved,
      this.time,
      this.price,
      this.count,
      this.createdAt,
      this.updatedAt,
      this.likesCount,
      this.totalRating,
      this.items});

  Rooms.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    description = json["description"];
    categoryId = json["category_id"];
    imageUrl = json["image_url"];
    countReserved = json["count_reserved"];
    time = json["time"];
    price = json["price"];
    count = json["count"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    likesCount = json["likes_count"];
    totalRating = json["total_rating"];
    items = json["items"] ?? [];
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
    _data["created_at"] = createdAt;
    _data["updated_at"] = updatedAt;
    _data["likes_count"] = likesCount;
    _data["total_rating"] = totalRating;
    if (items != null) {
      _data["items"] = items;
    }
    return _data;
  }
}
