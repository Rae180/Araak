
class NearBranch {
    Branch? branch;

    NearBranch({this.branch});

    NearBranch.fromJson(Map<String, dynamic> json) {
        branch = json["branch"] == null ? null : Branch.fromJson(json["branch"]);
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        if(branch != null) {
            _data["branch"] = branch?.toJson();
        }
        return _data;
    }
}

class Branch {
    int? id;
    String? address;
    String? latitude;
    String? longitude;
    double? distanceKm;

    Branch({this.id, this.address, this.latitude, this.longitude, this.distanceKm});

    Branch.fromJson(Map<String, dynamic> json) {
        id = json["id"];
        address = json["address"];
        latitude = json["latitude"];
        longitude = json["longitude"];
        distanceKm = json["distance_km"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["id"] = id;
        _data["address"] = address;
        _data["latitude"] = latitude;
        _data["longitude"] = longitude;
        _data["distance_km"] = distanceKm;
        return _data;
    }
}