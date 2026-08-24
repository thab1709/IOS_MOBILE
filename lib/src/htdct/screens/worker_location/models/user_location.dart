// @dart=2.9
import 'package:g_json/g_json.dart';

class Location {
  double latitude;
  double longitude;
  String timeLog;

  Location({
    this.latitude,
    this.longitude
});

  Location.fromJson(JSON json) {
    final latValue = json['latitude'].string;
    timeLog = json['timeLog'].string;
    if (latValue != null) {
      latitude = double.parse(latValue);
    }
    final longValue = json['longitude'].string;
    if (latValue != null) {
      longitude = double.parse(longValue);
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    return map;
  }
}
class UserLocation {
  String userId;
  String name;
  String code;
  String userGroup;
  String timeLog;
  List<Location> locations;

  UserLocation({
      this.userId, 
      this.name, 
      this.code,
      this.timeLog,
      this.userGroup,});

  UserLocation.fromJson(JSON json) {
    userId = json['userId'].string;
    name = json['name'].string;
    code = json['code'].string;
    timeLog = json['timeLog'].string;
    userGroup = json['userGroup'].string;
    locations = json['locations']?.list?.map((e) => Location.fromJson(e))?.toList();
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userId'] = userId;
    map['name'] = name;
    map['code'] = code;
    map['userGroup'] = userGroup;
    return map;
  }

}
