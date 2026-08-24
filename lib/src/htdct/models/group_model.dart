// @dart=2.9
import 'package:g_json/g_json.dart';

class GroupModel {
  String id;
  String name;
  String unitId;
  String unitName;

  GroupModel({this.id, this.name, this.unitId, this.unitName});

  GroupModel.fromJson(JSON json) {
    id = json['id'].string;
    name = json['name'].string;
    unitId = json['unitId'].string;
    unitName = json['unitName'].string;
  }

  Map toJson() {
    final map = {};
    map['id'] = id;
    map['name'] = name;
    map['unitId'] = unitId;
    map['unitName'] = unitName;
    return map;
  }
}
