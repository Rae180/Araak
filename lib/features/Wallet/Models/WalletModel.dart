
class WalletModel {
    String? message;
    String? balance;
    String? currency;

    WalletModel({this.message, this.balance, this.currency});

    WalletModel.fromJson(Map<String, dynamic> json) {
        message = json["message"];
        balance = json["balance"];
        currency = json["currency"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["message"] = message;
        _data["balance"] = balance;
        _data["currency"] = currency;
        return _data;
    }
}