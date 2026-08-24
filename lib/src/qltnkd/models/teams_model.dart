// @dart=2.9
import 'package:g_json/g_json.dart';

class TeamsModel {
  String id;
  String name;

  TeamsModel({this.id, this.name});

  TeamsModel.fromJson(JSON json) {
    id = json['id'].string;
    name = json['name'].string;
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }
}

class UserModel {
  String id;
  String name;

  UserModel({this.id, this.name});

  UserModel.fromJson(JSON json) {
    id = json['id'].string;
    name = json['name'].string;
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }
}

