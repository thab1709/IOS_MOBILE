// @dart=2.9
import 'package:g_json/g_json.dart';

import 'user_location.dart';

class SubstationDetailLocation {
  String id;
  double substationLatitude;
  double substationLongitude;
  List<UserLocation> userLocations;

  SubstationDetailLocation({
      this.id, 
      this.substationLatitude, 
      this.substationLongitude, 
      this.userLocations});

  SubstationDetailLocation.fromJson(JSON json) {
    id = json['id'].string;
    substationLatitude = json['substationLatitude']?.string != null ? double.parse(json['substationLatitude'].string) : null;
    substationLongitude = json['substationLongitude']?.string != null ? double.parse(json['substationLongitude'].string) : null;
    userLocations = json['userLocations']?.list?.map((e) => UserLocation.fromJson(e))?.toList();
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['substationLatitude'] = substationLatitude;
    map['substationLongitude'] = substationLongitude;
    if (userLocations != null) {
      map['userLocations'] = userLocations.map((v) => v.toJson()).toList();
    }
    return map;
  }

}
