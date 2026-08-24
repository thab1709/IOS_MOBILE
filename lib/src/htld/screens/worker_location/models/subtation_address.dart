// @dart=2.9
import 'package:g_json/g_json.dart';

class SubstationAddress {
  String id;
  String code;
  String name;
  String nameUnsigned;
  List<String> userGroups;
  List<String> users;
  dynamic date;
  double latitude;
  double longitude;
  String lineName;
  String lineCode;
  bool isExpand = false;
  String timeLog;

  SubstationAddress({
      this.id, 
      this.code, 
      this.name, 
      this.nameUnsigned, 
      this.userGroups, 
      this.users, 
      this.date, 
      this.latitude,
      this.timeLog,
      this.longitude});

  SubstationAddress.fromJson(JSON json) {
    id = json["id"].string;
    code = json["code"].string;
    lineCode = json["lineCode"].string;
    lineName = json["lineName"].string;
    name = json["name"].string;
    nameUnsigned = json["nameUnsigned"].string;
    userGroups = json["userGroups"].listObject.map((e) => e as String).toList();
    users = json["users"].listObject.map((e) => e as String).toList();
    date = json["date"].string;
    if (json["latitude"]?.string != null) {
      latitude = double?.parse(json["latitude"]?.string);
    }

    if (json["longitude"]?.string != null) {
      longitude = double?.parse(json["longitude"]?.string);
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["code"] = code;
    map["name"] = name;
    map["nameUnsigned"] = nameUnsigned;
    map["userGroups"] = userGroups;
    map["users"] = users;
    map["date"] = date;
    map["latitude"] = latitude;
    map["longitude"] = longitude;
    return map;
  }

}
