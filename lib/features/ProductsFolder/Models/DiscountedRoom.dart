
class DiscountModel {
    String? discountPercentage;
    String? startDate;
    String? endDate;
    String? originalPrice;
    String? discountedPrice;
    int? roomId;
    String? roomName;
    String? roomImage;
    List<RoomItems>? roomItems;
    int? itemId;
    String? itemName;
    String? itemImage;

    DiscountModel({this.discountPercentage, this.startDate, this.endDate, this.originalPrice, this.discountedPrice, this.roomId, this.roomName, this.roomImage, this.roomItems, this.itemId, this.itemName, this.itemImage});

    DiscountModel.fromJson(Map<String, dynamic> json) {
        discountPercentage = json["discount_percentage"];
        startDate = json["start_date"];
        endDate = json["end_date"];
        originalPrice = json["original_price"];
        discountedPrice = json["discounted_price"];
        roomId = json["room_id"];
        roomName = json["room_name"];
        roomImage = json["room_image"];
        roomItems = json["room_items"] == null ? null : (json["room_items"] as List).map((e) => RoomItems.fromJson(e)).toList();
        itemId = json["item_id"];
        itemName = json["item_name"];
        itemImage = json["item_image"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["discount_percentage"] = discountPercentage;
        _data["start_date"] = startDate;
        _data["end_date"] = endDate;
        _data["original_price"] = originalPrice;
        _data["discounted_price"] = discountedPrice;
        _data["room_id"] = roomId;
        _data["room_name"] = roomName;
        _data["room_image"] = roomImage;
        if(roomItems != null) {
            _data["room_items"] = roomItems?.map((e) => e.toJson()).toList();
        }
        _data["item_id"] = itemId;
        _data["item_name"] = itemName;
        _data["item_image"] = itemImage;
        return _data;
    }
}

class RoomItems {
    int? id;
    String? name;
    String? price;
    String? imageUrl;

    RoomItems({this.id, this.name, this.price, this.imageUrl});

    RoomItems.fromJson(Map<String, dynamic> json) {
        id = json["id"];
        name = json["name"];
        price = json["price"];
        imageUrl = json["image_url"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["id"] = id;
        _data["name"] = name;
        _data["price"] = price;
        _data["image_url"] = imageUrl;
        return _data;
    }
}