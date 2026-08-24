// @dart=2.9
import 'package:g_json/g_json.dart';

class ReportUserLocation {
  ReportUserLocation({
    this.code,
    this.departmentName,
    this.createdDate,
    this.id,
    this.name,
    this.longitude,
    this.latitude,});

  ReportUserLocation.fromJson(JSON json) {
    code = json['code'].string;
    departmentName = json['departmentName'].string;
    createdDate = json['createdDate'].string;
    name = json['name'].string;
    longitude = json['longitude'].string;
    latitude = json['latitude'].string;
    id = json['id'].string;
  }

  String id;
  String code;
  String departmentName;
  String createdDate;
  String name;
  String longitude;
  String latitude;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['departmentName'] = departmentName;
    map['createdDate'] = createdDate;
    map['id'] = id;
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
