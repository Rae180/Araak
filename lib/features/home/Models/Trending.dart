
class Trending {
    List<TrendingItems>? trendingItems;
    List<TrendingRooms>? trendingRooms;
    List<Discounts>? discounts;

    Trending({this.trendingItems, this.trendingRooms, this.discounts});

    Trending.fromJson(Map<String, dynamic> json) {
        trendingItems = json["trending_items"] == null ? null : (json["trending_items"] as List).map((e) => TrendingItems.fromJson(e)).toList();
        trendingRooms = json["trending_rooms"] == null ? null : (json["trending_rooms"] as List).map((e) => TrendingRooms.fromJson(e)).toList();
        discounts = json["discounts"] == null ? null : (json["discounts"] as List).map((e) => Discounts.fromJson(e)).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        if(trendingItems != null) {
            _data["trending_items"] = trendingItems?.map((e) => e.toJson()).toList();
        }
        if(trendingRooms != null) {
            _data["trending_rooms"] = trendingRooms?.map((e) => e.toJson()).toList();
        }
        if(discounts != null) {
            _data["discounts"] = discounts?.map((e) => e.toJson()).toList();
        }
        return _data;
    }
}

class Discounts {
    int? id;
    int? roomId;
    int? itemId;
    String? discountPercentage;
    String? startDate;
    String? endDate;
    int? originalPrice;
    double? discountedPrice;
    String? imageUrl;

    Discounts({this.id, this.roomId, this.itemId, this.discountPercentage, this.startDate, this.endDate, this.originalPrice, this.discountedPrice, this.imageUrl});

    Discounts.fromJson(Map<String, dynamic> json) {
        id = json["id"];
        roomId = json["room_id"];
        itemId = json["item_id"];
        discountPercentage = json["discount_percentage"];
        startDate = json["start_date"];
        endDate = json["end_date"];
        originalPrice = json["original_price"];
        discountedPrice = json["discounted_price"];
        imageUrl = json["image_url"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["id"] = id;
        _data["room_id"] = roomId;
        _data["item_id"] = itemId;
        _data["discount_percentage"] = discountPercentage;
        _data["start_date"] = startDate;
        _data["end_date"] = endDate;
        _data["original_price"] = originalPrice;
        _data["discounted_price"] = discountedPrice;
        _data["image_url"] = imageUrl;
        return _data;
    }
}

class TrendingRooms {
    int? id;
    String? name;
    String? description;
    int? categoryId;
    String? imageUrl;
    int? countReserved;
    int? time;
    int? price;
    int? count;
    String? woodType;
    String? woodColor;
    String? fabricType;
    String? fabricColor;
    String? createdAt;
    String? updatedAt;
    int? likesCount;

    TrendingRooms({this.id, this.name, this.description, this.categoryId, this.imageUrl, this.countReserved, this.time, this.price, this.count, this.woodType, this.woodColor, this.fabricType, this.fabricColor, this.createdAt, this.updatedAt, this.likesCount});

    TrendingRooms.fromJson(Map<String, dynamic> json) {
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
        likesCount = json["likes_count"];
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
        _data["likes_count"] = likesCount;
        return _data;
    }
}

class TrendingItems {
    int? id;
    int? roomId;
    String? name;
    int? time;
    double? price;
    String? imageUrl;
    String? description;
    int? count;
    int? countReserved;
    int? itemTypeId;
    String? createdAt;
    String? updatedAt;
    int? likesCount;

    TrendingItems({this.id, this.roomId, this.name, this.time, this.price, this.imageUrl, this.description, this.count, this.countReserved, this.itemTypeId, this.createdAt, this.updatedAt, this.likesCount});

    TrendingItems.fromJson(Map<String, dynamic> json) {
        id = json["id"];
        roomId = json["room_id"];
        name = json["name"];
        time = json["time"];
        price = json["price"];
        imageUrl = json["image_url"];
        description = json["description"];
        count = json["count"];
        countReserved = json["count_reserved"];
        itemTypeId = json["item_type_id"];
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
        _data["description"] = description;
        _data["count"] = count;
        _data["count_reserved"] = countReserved;
        _data["item_type_id"] = itemTypeId;
        _data["created_at"] = createdAt;
        _data["updated_at"] = updatedAt;
        _data["likes_count"] = likesCount;
        return _data;
    }
}