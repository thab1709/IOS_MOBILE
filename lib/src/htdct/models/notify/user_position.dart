// @dart=2.9
import 'package:g_json/g_json.dart';

class UserPositionModel {
  UserPositionModel({
    this.id,
    this.userName,
    this.name,
    this.position,
    this.positionName,
  });

  UserPositionModel.fromJson(JSON json) {
    id = json['id'].string;
    userName = json['userName'].string;
    name = json['name'].string;
    position = json['position'].integer;
    positionName = json['positionName'].string;
  }

  String id;
  String userName;
  String name;
  int position;
  String positionName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['userName'] = userName;
    map['name'] = name;
    map['position'] = position;
    map['positionName'] = positionName;
    return map;
  }
}

