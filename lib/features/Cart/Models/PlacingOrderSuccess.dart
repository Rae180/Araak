
class PlacingOrderResponse {
    String? message;
    Order? order;
    PriceDetails? priceDetails;
    NearestBranch? nearestBranch;

    PlacingOrderResponse({this.message, this.order, this.priceDetails, this.nearestBranch});

    PlacingOrderResponse.fromJson(Map<String, dynamic> json) {
        message = json["message"];
        order = json["order"] == null ? null : Order.fromJson(json["order"]);
        priceDetails = json["price_details"] == null ? null : PriceDetails.fromJson(json["price_details"]);
        nearestBranch = json["nearest_branch"] == null ? null : NearestBranch.fromJson(json["nearest_branch"]);
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["message"] = message;
        if(order != null) {
            _data["order"] = order?.toJson();
        }
        if(priceDetails != null) {
            _data["price_details"] = priceDetails?.toJson();
        }
        if(nearestBranch != null) {
            _data["nearest_branch"] = nearestBranch?.toJson();
        }
        return _data;
    }
}

class NearestBranch {
    int? id;
    String? name;
    String? address;
    double? latitude;
    double? longitude;
    String? phone;
    String? workingHours;
    List<String>? images;

    NearestBranch({this.id, this.name, this.address, this.latitude, this.longitude, this.phone, this.workingHours, this.images});

    NearestBranch.fromJson(Map<String, dynamic> json) {
        id = json["id"];
        name = json["name"];
        address = json["address"];
        latitude = json["latitude"];
        longitude = json["longitude"];
        phone = json["phone"];
        workingHours = json["working_hours"];
        images = json["images"] == null ? null : List<String>.from(json["images"]);
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["id"] = id;
        _data["name"] = name;
        _data["address"] = address;
        _data["latitude"] = latitude;
        _data["longitude"] = longitude;
        _data["phone"] = phone;
        _data["working_hours"] = workingHours;
        if(images != null) {
            _data["images"] = images;
        }
        return _data;
    }
}

class PriceDetails {
    int? totalPrice;
    int? rabbon;
    int? priceAfterRabbon;
    int? deliveryPrice;
    dynamic priceAfterRabbonWithDelivery;
    int? remainingAmount;
    dynamic remainingAmountWithDelivery;

    PriceDetails({this.totalPrice, this.rabbon, this.priceAfterRabbon, this.deliveryPrice, this.priceAfterRabbonWithDelivery, this.remainingAmount, this.remainingAmountWithDelivery});

    PriceDetails.fromJson(Map<String, dynamic> json) {
        totalPrice = json["total_price"];
        rabbon = json["rabbon"];
        priceAfterRabbon = json["price_after_rabbon"];
        deliveryPrice = json["delivery_price"];
        priceAfterRabbonWithDelivery = json["price_after_rabbon_with_delivery"];
        remainingAmount = json["remaining_amount"];
        remainingAmountWithDelivery = json["remaining_amount_with_delivery"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["total_price"] = totalPrice;
        _data["rabbon"] = rabbon;
        _data["price_after_rabbon"] = priceAfterRabbon;
        _data["delivery_price"] = deliveryPrice;
        _data["price_after_rabbon_with_delivery"] = priceAfterRabbonWithDelivery;
        _data["remaining_amount"] = remainingAmount;
        _data["remaining_amount_with_delivery"] = remainingAmountWithDelivery;
        return _data;
    }
}

class Order {
    int? id;
    int? customerId;
    String? status;
    String? deliveryStatus;
    String? wantDelivery;
    String? isPaid;
    int? totalPrice;
    String? reciveDate;
    double? latitude;
    double? longitude;
    dynamic address;
    int? deliveryPrice;
    int? rabbon;
    int? priceAfterRabbon;
    dynamic priceAfterRabbonWithDelivery;
    dynamic remainingAmountWithDelivery;
    int? branchId;
    String? createdAt;
    String? updatedAt;
    Customer? customer;
    List<RoomOrders>? roomOrders;
    List<OrderItem>? item;

    Order({this.id, this.customerId, this.status, this.deliveryStatus, this.wantDelivery, this.isPaid, this.totalPrice, this.reciveDate, this.latitude, this.longitude, this.address, this.deliveryPrice, this.rabbon, this.priceAfterRabbon, this.priceAfterRabbonWithDelivery, this.remainingAmountWithDelivery, this.branchId, this.createdAt, this.updatedAt, this.customer, this.roomOrders, this.item});

    Order.fromJson(Map<String, dynamic> json) {
        id = json["id"];
        customerId = json["customer_id"];
        status = json["status"];
        deliveryStatus = json["delivery_status"];
        wantDelivery = json["want_delivery"];
        isPaid = json["is_paid"];
        totalPrice = json["total_price"];
        reciveDate = json["recive_date"];
        latitude = json["latitude"];
        longitude = json["longitude"];
        address = json["address"];
        deliveryPrice = json["delivery_price"];
        rabbon = json["rabbon"];
        priceAfterRabbon = json["price_after_rabbon"];
        priceAfterRabbonWithDelivery = json["price_after_rabbon_with_delivery"];
        remainingAmountWithDelivery = json["remaining_amount_with_delivery"];
        branchId = json["branch_id"];
        createdAt = json["created_at"];
        updatedAt = json["updated_at"];
        customer = json["customer"] == null ? null : Customer.fromJson(json["customer"]);
        roomOrders = json["roomOrders"] == null ? null : (json["roomOrders"] as List).map((e) => RoomOrders.fromJson(e)).toList();
        item = json["item"] == null ? null : (json["item"] as List).map((e) => OrderItem.fromJson(e)).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["id"] = id;
        _data["customer_id"] = customerId;
        _data["status"] = status;
        _data["delivery_status"] = deliveryStatus;
        _data["want_delivery"] = wantDelivery;
        _data["is_paid"] = isPaid;
        _data["total_price"] = totalPrice;
        _data["recive_date"] = reciveDate;
        _data["latitude"] = latitude;
        _data["longitude"] = longitude;
        _data["address"] = address;
        _data["delivery_price"] = deliveryPrice;
        _data["rabbon"] = rabbon;
        _data["price_after_rabbon"] = priceAfterRabbon;
        _data["price_after_rabbon_with_delivery"] = priceAfterRabbonWithDelivery;
        _data["remaining_amount_with_delivery"] = remainingAmountWithDelivery;
        _data["branch_id"] = branchId;
        _data["created_at"] = createdAt;
        _data["updated_at"] = updatedAt;
        if(customer != null) {
            _data["customer"] = customer?.toJson();
        }
        if(roomOrders != null) {
            _data["roomOrders"] = roomOrders?.map((e) => e.toJson()).toList();
        }
        if(item != null) {
            _data["item"] = item?.map((e) => e.toJson()).toList();
        }
        return _data;
    }
}

class OrderItem {
    int? id;
    String? name;
    String? description;
    int? price;
    int? count;

    OrderItem({this.id, this.name, this.description, this.price, this.count});

    OrderItem.fromJson(Map<String, dynamic> json) {
        id = json["id"];
        name = json["name"];
        description = json["description"];
        price = json["price"];
        count = json["count"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["id"] = id;
        _data["name"] = name;
        _data["description"] = description;
        _data["price"] = price;
        _data["count"] = count;
        return _data;
    }
}

class RoomOrders {
    int? id;
    int? roomId;
    String? roomName;
    String? roomImage;
    int? count;
    int? depositePrice;
    int? depositeTime;
    int? countReserved;
    List<Items>? items;

    RoomOrders({this.id, this.roomId, this.roomName, this.roomImage, this.count, this.depositePrice, this.depositeTime, this.countReserved, this.items});

    RoomOrders.fromJson(Map<String, dynamic> json) {
        id = json["id"];
        roomId = json["room_id"];
        roomName = json["room_name"];
        roomImage = json["room_image"];
        count = json["count"];
        depositePrice = json["deposite_price"];
        depositeTime = json["deposite_time"];
        countReserved = json["count_reserved"];
        items = json["items"] == null ? null : (json["items"] as List).map((e) => Items.fromJson(e)).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["id"] = id;
        _data["room_id"] = roomId;
        _data["room_name"] = roomName;
        _data["room_image"] = roomImage;
        _data["count"] = count;
        _data["deposite_price"] = depositePrice;
        _data["deposite_time"] = depositeTime;
        _data["count_reserved"] = countReserved;
        if(items != null) {
            _data["items"] = items?.map((e) => e.toJson()).toList();
        }
        return _data;
    }
}

class Items {
    int? id;
    String? name;
    String? description;
    int? price;
    int? countReserved;

    Items({this.id, this.name, this.description, this.price, this.countReserved});

    Items.fromJson(Map<String, dynamic> json) {
        id = json["id"];
        name = json["name"];
        description = json["description"];
        price = json["price"];
        countReserved = json["count_reserved"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["id"] = id;
        _data["name"] = name;
        _data["description"] = description;
        _data["price"] = price;
        _data["count_reserved"] = countReserved;
        return _data;
    }
}

class Customer {
    int? id;
    String? name;
    String? email;
    String? phone;

    Customer({this.id, this.name, this.email, this.phone});

    Customer.fromJson(Map<String, dynamic> json) {
        id = json["id"];
        name = json["name"];
        email = json["email"];
        phone = json["phone"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["id"] = id;
        _data["name"] = name;
        _data["email"] = email;
        _data["phone"] = phone;
        return _data;
    }
}