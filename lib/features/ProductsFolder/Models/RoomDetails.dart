class RoomDetailes {
  Room? room;
  List<Woods>? woods;
  List<Fabrics>? fabrics;
  List<Ratings>? ratings;

  RoomDetailes({this.room, this.woods, this.fabrics, this.ratings});

  RoomDetailes.fromJson(Map<String, dynamic> json) {
    room = json["room"] == null ? null : Room.fromJson(json["room"]);
    woods = json["woods"] == null
        ? null
        : (json["woods"] as List).map((e) => Woods.fromJson(e)).toList();
    fabrics = json["fabrics"] == null
        ? null
        : (json["fabrics"] as List).map((e) => Fabrics.fromJson(e)).toList();
    ratings = json["ratings"] == null
        ? null
        : (json["ratings"] as List).map((e) => Ratings.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if (room != null) {
      _data["room"] = room?.toJson();
    }
    if (woods != null) {
      _data["woods"] = woods?.map((e) => e.toJson()).toList();
    }
    if (fabrics != null) {
      _data["fabrics"] = fabrics?.map((e) => e.toJson()).toList();
    }
    if (ratings != null) {
      _data["ratings"] = ratings?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class Ratings {
  String? customerName;
  String? customerImage;
  num? rate;
  String? feedback;

  Ratings({this.customerName, this.customerImage, this.rate, this.feedback});

  Ratings.fromJson(Map<String, dynamic> json) {
    customerName = json["customer_name"];
    customerImage = json["customer_image"];
    rate = json["rate"];
    feedback = json["feedback"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["customer_name"] = customerName;
    _data["customer_image"] = customerImage;
    _data["rate"] = rate;
    _data["feedback"] = feedback;
    return _data;
  }
}

class Fabrics {
  int? id;
  String? name;
  num? pricePerMeter;
  List<dynamic>? types;
  List<dynamic>? colors;

  Fabrics({this.id, this.name, this.pricePerMeter, this.types, this.colors});

  Fabrics.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    pricePerMeter = json["price_per_meter"];
    types = json["types"] ?? [];
    colors = json["colors"] ?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["price_per_meter"] = pricePerMeter;
    if (types != null) {
      _data["types"] = types;
    }
    if (colors != null) {
      _data["colors"] = colors;
    }
    return _data;
  }
}

class Woods {
  int? id;
  String? name;
  num? pricePerMeter;
  List<dynamic>? types;
  List<dynamic>? colors;

  Woods({this.id, this.name, this.pricePerMeter, this.types, this.colors});

  Woods.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    pricePerMeter = json["price_per_meter"];
    types = json["types"] ?? [];
    colors = json["colors"] ?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["price_per_meter"] = pricePerMeter;
    if (types != null) {
      _data["types"] = types;
    }
    if (colors != null) {
      _data["colors"] = colors;
    }
    return _data;
  }
}

class Room {
  int? id;
  String? name;
  int? categoryId;
  String? categoryName;
  String? description;
  String? imageUrl;
  int? countReserved;
  String? time;
  num? price;
  int? count;
  bool? isFavorite;
  bool? isLiked;
  int? likesCount;
  num? averageRating;
  int? totalRate;
  List<RoomItem>? items;

  Room(
      {this.id,
      this.name,
      this.categoryId,
      this.categoryName,
      this.description,
      this.imageUrl,
      this.countReserved,
      this.time,
      this.price,
      this.count,
      this.isFavorite,
      this.isLiked,
      this.likesCount,
      this.averageRating,
      this.totalRate,
      this.items});

  Room.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    categoryId = json["category_id"];
    categoryName = json["category_name"];
    description = json["description"];
    imageUrl = json["image_url"];
    countReserved = json["count_reserved"];
    time = json["time"];
    price = json["price"];
    count = json["count"];
    isFavorite = json["is_favorite"];
    isLiked = json["is_liked"];
    likesCount = json["likes_count"];
    averageRating = json["average_rating"];
    totalRate = json["total_rate"];
    if (json["items"] != null) {
      items = (json["items"] as List)
          .map((item) => RoomItem.fromJson(item))
          .toList();
    } else {
      items = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["category_id"] = categoryId;
    _data["category_name"] = categoryName;
    _data["description"] = description;
    _data["image_url"] = imageUrl;
    _data["count_reserved"] = countReserved;
    _data["time"] = time;
    _data["price"] = price;
    _data["count"] = count;
    _data["is_favorite"] = isFavorite;
    _data["is_liked"] = isLiked;
    _data["likes_count"] = likesCount;
    _data["average_rating"] = averageRating;
    _data["total_rate"] = totalRate;
     if (items != null) {
      _data["items"] = items!.map((item) => item.toJson()).toList();
    }
    return _data;
  }
}

class RoomItem {
  int? id;
  String? name;
  num? price;
  String? imageUrl;

  RoomItem({this.id, this.name, this.price, this.imageUrl});

  RoomItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data['image_url'] = imageUrl;
    return data;
  }
}
