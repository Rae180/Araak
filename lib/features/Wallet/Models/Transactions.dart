class Transactions {
  User? user;
  List<Operations>? operations;

  Transactions({this.user, this.operations});

  Transactions.fromJson(Map<String, dynamic> json) {
    user = json["user"] != null
        ? User.fromJson(json["user"] as Map<String, dynamic>)
        : null;
    operations = [];
    if (json["operations"] != null && json["operations"] is List) {
      for (final item in json["operations"] as List) {
        if (item != null) {
          operations!.add(Operations.fromJson(item as Map<String, dynamic>));
        }
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if (user != null) {
      _data["user"] = user?.toJson();
    }
    if (operations != null) {
      _data["operations"] = operations?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class Operations {
  String? title;
  String? description;
  String? type;
  String? amount;
  String? status;
  String? createdAt;
  Wallet? wallet;
  Stripe? stripe;

  Operations(
      {this.title,
      this.description,
      this.type,
      this.amount,
      this.status,
      this.createdAt,
      this.wallet,
      this.stripe});

  Operations.fromJson(Map<String, dynamic> json) {
    title = json["title"] as String?;
    description = json["description"] as String?;
    type = json["type"] as String?;
    amount = json["amount"] as String?;
    status = json["status"] as String?;
    createdAt = json["created_at"] as String?;
    wallet = json["wallet"] != null
        ? Wallet.fromJson(json["wallet"] as Map<String, dynamic>)
        : null;

    stripe = json["stripe"] != null
        ? Stripe.fromJson(json["stripe"] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["title"] = title;
    _data["description"] = description;
    _data["type"] = type;
    _data["amount"] = amount;
    _data["status"] = status;
    _data["created_at"] = createdAt;
    if (wallet != null) {
      _data["wallet"] = wallet?.toJson();
    }
    if (stripe != null) {
      _data["stripe"] = stripe?.toJson();
    }
    return _data;
  }
}

class Stripe {
  String? receiptUrl;

  Stripe({this.receiptUrl});

  Stripe.fromJson(Map<String, dynamic> json) {
    receiptUrl = json["receipt_url"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["receipt_url"] = receiptUrl;
    return _data;
  }
}

class Wallet {
  String? currency;
  String? walletType;

  Wallet({this.currency, this.walletType});

  Wallet.fromJson(Map<String, dynamic> json) {
    currency = json["currency"];
    walletType = json["wallet_type"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["currency"] = currency;
    _data["wallet_type"] = walletType;
    return _data;
  }
}

class User {
  int? id;
  String? name;
  String? email;

  User({this.id, this.name, this.email});

  User.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    email = json["email"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["email"] = email;
    return _data;
  }
}
