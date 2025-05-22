
class ItemDetails {
    Item? item;

    ItemDetails({this.item});

    ItemDetails.fromJson(Map<String, dynamic> json) {
        item = json["item"] == null ? null : Item.fromJson(json["item"]);
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        if(item != null) {
            _data["item"] = item?.toJson();
        }
        return _data;
    }
}

class Item {
    int? id;
    String? name;
    double? price;
    int? time;
    dynamic woodId;
    dynamic fabricId;
    dynamic woodLength;
    dynamic woodWidth;
    dynamic woodHeight;
    int? likesCount;
    num? averageRate;
    List<String>? feedbacks;
    String? image;

    Item({this.id, this.name, this.price, this.time, this.woodId, this.fabricId, this.woodLength, this.woodWidth, this.woodHeight, this.likesCount, this.averageRate, this.feedbacks, this.image});

    Item.fromJson(Map<String, dynamic> json) {
        id = json["id"];
        name = json["name"];
        price = json["price"];
        time = json["time"];
        woodId = json["wood_id"];
        fabricId = json["fabric_id"];
        woodLength = json["wood_length"];
        woodWidth = json["wood_width"];
        woodHeight = json["wood_height"];
        likesCount = json["likes_count"];
        averageRate = json["average_rate"];
        feedbacks = json["feedbacks"] == null ? null : List<String>.from(json["feedbacks"]);
        image = json["image"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["id"] = id;
        _data["name"] = name;
        _data["price"] = price;
        _data["time"] = time;
        _data["wood_id"] = woodId;
        _data["fabric_id"] = fabricId;
        _data["wood_length"] = woodLength;
        _data["wood_width"] = woodWidth;
        _data["wood_height"] = woodHeight;
        _data["likes_count"] = likesCount;
        _data["average_rate"] = averageRate;
        if(feedbacks != null) {
            _data["feedbacks"] = feedbacks;
        }
        _data["image"] = image;
        return _data;
    }
}