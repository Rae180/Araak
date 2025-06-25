
class ItemDetails {
    Item? item;
    List<ItemDetails1>? itemDetails;
    num? averageRating;
    List<Ratings>? ratings;
    bool? isLiked;
    bool? isFavorite;
    num? likeCounts;

    ItemDetails({this.item, this.itemDetails, this.averageRating, this.ratings, this.isLiked, this.isFavorite, this.likeCounts});

    ItemDetails.fromJson(Map<String, dynamic> json) {
        item = json["item"] == null ? null : Item.fromJson(json["item"]);
        itemDetails = json["item_details"] == null ? null : (json["item_details"] as List).map((e) => ItemDetails1.fromJson(e)).toList();
        averageRating = json["average_rating"];
        ratings = json["ratings"] == null ? null : (json["ratings"] as List).map((e) => Ratings.fromJson(e)).toList();
        isLiked = json["is_liked"];
        isFavorite = json["is_favorite"];
        likeCounts = json["like_counts"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        if(item != null) {
            _data["item"] = item?.toJson();
        }
        if(itemDetails != null) {
            _data["item_details"] = itemDetails?.map((e) => e.toJson()).toList();
        }
        _data["average_rating"] = averageRating;
        if(ratings != null) {
            _data["ratings"] = ratings?.map((e) => e.toJson()).toList();
        }
        _data["is_liked"] = isLiked;
        _data["is_favorite"] = isFavorite;
        _data["like_counts"] = likeCounts;
        return _data;
    }
}

class Ratings {
    String? feedback;
    num? rate;
    Customer? customer;

    Ratings({this.feedback, this.rate, this.customer});

    Ratings.fromJson(Map<String, dynamic> json) {
        feedback = json["feedback"];
        rate = json["rate"];
        customer = json["customer"] == null ? null : Customer.fromJson(json["customer"]);
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["feedback"] = feedback;
        _data["rate"] = rate;
        if(customer != null) {
            _data["customer"] = customer?.toJson();
        }
        return _data;
    }
}

class Customer {
    int? id;
    String? name;
    String? imageUrl;

    Customer({this.id, this.name, this.imageUrl});

    Customer.fromJson(Map<String, dynamic> json) {
        id = json["id"];
        name = json["name"];
        imageUrl = json["image_url"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["id"] = id;
        _data["name"] = name;
        _data["image_url"] = imageUrl;
        return _data;
    }
}

class ItemDetails1 {
    int? id;
    int? itemId;
    num? woodLength;
    num? woodWidth;
    num? woodHeight;
    num? fabricDimension;
    String? createdAt;
    String? updatedAt;
    List<ItemWoods>? itemWoods;
    List<ItemFabrics>? itemFabrics;

    ItemDetails1({this.id, this.itemId, this.woodLength, this.woodWidth, this.woodHeight, this.fabricDimension, this.createdAt, this.updatedAt, this.itemWoods, this.itemFabrics});

    ItemDetails1.fromJson(Map<String, dynamic> json) {
        id = json["id"];
        itemId = json["item_id"];
        woodLength = json["wood_length"];
        woodWidth = json["wood_width"];
        woodHeight = json["wood_height"];
        fabricDimension = json["fabric_dimension"];
        createdAt = json["created_at"];
        updatedAt = json["updated_at"];
        itemWoods = json["item_woods"] == null ? null : (json["item_woods"] as List).map((e) => ItemWoods.fromJson(e)).toList();
        itemFabrics = json["item_fabrics"] == null ? null : (json["item_fabrics"] as List).map((e) => ItemFabrics.fromJson(e)).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["id"] = id;
        _data["item_id"] = itemId;
        _data["wood_length"] = woodLength;
        _data["wood_width"] = woodWidth;
        _data["wood_height"] = woodHeight;
        _data["fabric_dimension"] = fabricDimension;
        _data["created_at"] = createdAt;
        _data["updated_at"] = updatedAt;
        if(itemWoods != null) {
            _data["item_woods"] = itemWoods?.map((e) => e.toJson()).toList();
        }
        if(itemFabrics != null) {
            _data["item_fabrics"] = itemFabrics?.map((e) => e.toJson()).toList();
        }
        return _data;
    }
}

class ItemFabrics {
    int? id;
    int? itemDetailId;
    List<dynamic>? fabric;

    ItemFabrics({this.id, this.itemDetailId, this.fabric});

    ItemFabrics.fromJson(Map<String, dynamic> json) {
        id = json["id"];
        itemDetailId = json["item_detail_id"];
        fabric = json["fabric"] ?? [];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["id"] = id;
        _data["item_detail_id"] = itemDetailId;
        if(fabric != null) {
            _data["fabric"] = fabric;
        }
        return _data;
    }
}

class ItemWoods {
    int? id;
    int? itemDetailId;
    List<dynamic>? wood;

    ItemWoods({this.id, this.itemDetailId, this.wood});

    ItemWoods.fromJson(Map<String, dynamic> json) {
        id = json["id"];
        itemDetailId = json["item_detail_id"];
        wood = json["wood"] ?? [];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["id"] = id;
        _data["item_detail_id"] = itemDetailId;
        if(wood != null) {
            _data["wood"] = wood;
        }
        return _data;
    }
}

class Item {
    int? id;
    String? name;
    String? imageUrl;
    String? description;
    num? price;
    int? time;
    int? count;
    int? countReserved;
    String? woodColor;
    String? woodType;
    String? fabricColor;
    String? fabricType;

    Item({this.id, this.name, this.imageUrl, this.description, this.price, this.time, this.count, this.countReserved, this.woodColor, this.woodType, this.fabricColor, this.fabricType});

    Item.fromJson(Map<String, dynamic> json) {
        id = json["id"];
        name = json["name"];
        imageUrl = json["image_url"];
        description = json["description"];
        price = json["price"];
        time = json["time"];
        count = json["count"];
        countReserved = json["count_reserved"];
        woodColor = json["wood_color"];
        woodType = json["wood_type"];
        fabricColor = json["fabric_color"];
        fabricType = json["fabric_type"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["id"] = id;
        _data["name"] = name;
        _data["image_url"] = imageUrl;
        _data["description"] = description;
        _data["price"] = price;
        _data["time"] = time;
        _data["count"] = count;
        _data["count_reserved"] = countReserved;
        _data["wood_color"] = woodColor;
        _data["wood_type"] = woodType;
        _data["fabric_color"] = fabricColor;
        _data["fabric_type"] = fabricType;
        return _data;
    }
}