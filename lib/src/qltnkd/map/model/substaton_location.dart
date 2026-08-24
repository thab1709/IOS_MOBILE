// @dart=2.9
import 'package:g_json/g_json.dart';

class ReportSubstationLocation {
  ReportSubstationLocation({
    this.equipmentName,
    this.name,
    this.longitude,
    this.latitude,});

  ReportSubstationLocation.fromJson(JSON json) {
    equipmentName = json['equipmentName'].string;
    name = json['name'].string;
    longitude = json['longitude'].string;
    latitude = json['latitude'].string;
  }
  String equipmentName;
  String name;
  String longitude;
  String latitude;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['equipmentName'] = equipmentName;
    map['name'] = name;
    map['longitude'] = longitude;
    map['latitude'] = latitude;
    return map;
  }
  double getLongitude(){
    return double.parse(longitude);
  }
  double getLatitude(){
    return double.parse(latitude);
  }
}
