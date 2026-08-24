// @dart=2.9
import 'package:g_json/g_json.dart';

class DepartmentModel {
  String code;
  String id;
  bool isExistUser;
  String name;
  List<Team> teams;

  DepartmentModel(
      {this.code, this.id, this.isExistUser, this.name, this.teams});

  DepartmentModel.fromJson(JSON json) {
    code = json['code'].string;
    id = json['id'].string;
    isExistUser = json['isExistUser'].boolean;
    name = json['name'].string;
    teams =
        json['teams'].listObject?.map((e) => Team.fromJson(JSON(e)))?.toList();
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['id'] = id;
    map['isExistUser'] = isExistUser;
    map['name'] = name;
    if (teams != null) {
      map['teams'] = teams?.map((v) => v?.toJson())?.toList();
    }
    return map;
  }
}

class Team {
  String id;
  String name;

  Team({this.id, this.name});

  Team.fromJson(JSON json) {
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

