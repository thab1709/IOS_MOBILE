// @dart=2.9
import 'package:evnmobile/src/htld/screens/worker_location/models/user_location.dart';
import 'package:g_json/g_json.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationLineDetail {
  List<SubstationLocations> substationLocations;
  List<UserLocation> userLocations;

  LocationLineDetail({
      this.substationLocations, 
      this.userLocations});

  LocationLineDetail.fromJson(JSON json) {
    if (json["substationLocations"].list != null) {
      substationLocations = json['substationLocations'].list.map((e) => SubstationLocations.fromJson(e)).toList();
    }

    if (json["userLocations"].list != null) {
      userLocations = json['userLocations'].list.map((e) => UserLocation.fromJson(e)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (substationLocations != null) {
      map["substationLocations"] = substationLocations.map((v) => v.toJson()).toList();
    }
    if (userLocations != null) {
      map["userLocations"] = userLocations.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class SubstationLocations {
  String code;
  String name;
  double latitude;
  double longitude;

  SubstationLocations({
      this.code, 
      this.name, 
      this.latitude, 
      this.longitude});

  SubstationLocations.fromJson(JSON json) {
    code = json["code"].string;
    name = json["name"].string;

    final latValue = json["latitude"].string;
    if (latValue?.isNotEmpty == true) {
      latitude = double.parse(latValue);
    }
    final longValue = json["longitude"].string;
    if (latValue?.isNotEmpty == true) {
      longitude = double.parse(longValue);
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["code"] = code;
    map["name"] = name;
    map["latitude"] = latitude;
    map["longitude"] = longitude;
    return map;
  }

  LatLng getLatLng() {
    return LatLng(latitude, longitude);
  }
}
