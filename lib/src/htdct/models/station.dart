// @dart=2.9
import 'package:g_json/g_json.dart';

class StationModel {
  String id;
  String name;

  StationModel({this.id, this.name});

  StationModel.fromJson(JSON json) {
    id = json['id'].string;
    name = json['name'].string;
  }

  Map toJson() {
    final map = {};
    map['id'] = id;
    map['name'] = name;
    return map;
  }
}

