
class Trending {
    List<TrendingItems>? trendingItems;
    List<TrendingRooms>? trendingRooms;
    List<RoomDiscounts>? roomDiscounts;
    List<ItemDiscounts>? itemDiscounts;

    Trending({this.trendingItems, this.trendingRooms, this.roomDiscounts, this.itemDiscounts});

    Trending.fromJson(Map<String, dynamic> json) {
        trendingItems = json["trending_items"] == null ? null : (json["trending_items"] as List).map((e) => TrendingItems.fromJson(e)).toList();
        trendingRooms = json["trending_rooms"] == null ? null : (json["trending_rooms"] as List).map((e) => TrendingRooms.fromJson(e)).toList();
        roomDiscounts = json["room_discounts"] == null ? null : (json["room_discounts"] as List).map((e) => RoomDiscounts.fromJson(e)).toList();
        itemDiscounts = json["item_discounts"] == null ? null : (json["item_discounts"] as List).map((e) => ItemDiscounts.fromJson(e)).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        if(trendingItems != null) {
            _data["trending_items"] = trendingItems?.map((e) => e.toJson()).toList();
        }
        if(trendingRooms != null) {
            _data["trending_rooms"] = trendingRooms?.map((e) => e.toJson()).toList();
        }
        if(roomDiscounts != null) {
            _data["room_discounts"] = roomDiscounts?.map((e) => e.toJson()).toList();
        }
        if(itemDiscounts != null) {
            _data["item_discounts"] = itemDiscounts?.map((e) => e.toJson()).toList();
        }
        return _data;
    }
}

class ItemDiscounts {
    int? id;
    dynamic roomId;
    int? itemId;
    String? discountPercentage;
    String? startDate;
    String? endDate;
    double? originalPrice;
    double? discountedPrice;
    String? imageUrl;
    String? name;

    ItemDiscounts({this.id, this.roomId, this.itemId, this.discountPercentage, this.startDate, this.endDate, this.originalPrice, this.discountedPrice, this.imageUrl, this.name});

    ItemDiscounts.fromJson(Map<String, dynamic> json) {
        id = json["id"];
        roomId = json["room_id"];
        itemId = json["item_id"];
        discountPercentage = json["discount_percentage"];
        startDate = json["start_date"];
        endDate = json["end_date"];
        originalPrice = json["original_price"];
        discountedPrice = json["discounted_price"];
        imageUrl = json["image_url"];
        name = json["name"];
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
        _data["name"] = name;
        return _data;
    }
}

class RoomDiscounts {
    int? id;
    int? roomId;
    int? itemId;
    String? discountPercentage;
    String? startDate;
    String? endDate;
    num? originalPrice;
    num? discountedPrice;
    String? imageUrl;
    String? name;

    RoomDiscounts({this.id, this.roomId, this.itemId, this.discountPercentage, this.startDate, this.endDate, this.originalPrice, this.discountedPrice, this.imageUrl, this.name});

    RoomDiscounts.fromJson(Map<String, dynamic> json) {
        id = json["id"];
        roomId = json["room_id"];
        itemId = json["item_id"];
        discountPercentage = json["discount_percentage"];
        startDate = json["start_date"];
        endDate = json["end_date"];
        originalPrice = json["original_price"];
        discountedPrice = json["discounted_price"];
        imageUrl = json["image_url"];
        name = json["name"];
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
        _data["name"] = name;
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
    String? time;
    num? price;
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
    int? likesCount;

    TrendingItems({this.id, this.roomId, this.name, this.time, this.price, this.imageUrl, this.description, this.woodColor, this.woodType, this.fabricType, this.fabricColor, this.count, this.countReserved, this.itemTypeId, this.createdAt, this.updatedAt, this.likesCount});

    TrendingItems.fromJson(Map<String, dynamic> json) {
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
        _data["wood_color"] = woodColor;
        _data["wood_type"] = woodType;
        _data["fabric_type"] = fabricType;
        _data["fabric_color"] = fabricColor;
        _data["count"] = count;
        _data["count_reserved"] = countReserved;
        _data["item_type_id"] = itemTypeId;
        _data["created_at"] = createdAt;
        _data["updated_at"] = updatedAt;
        _data["likes_count"] = likesCount;
        return _data;
    }
}