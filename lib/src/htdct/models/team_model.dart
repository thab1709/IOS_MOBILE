// @dart=2.9
import 'package:g_json/g_json.dart';

class TeamModel {
  String id;
  String name;
  String nameUnsigned;
  String unitId;
  String unitName;
  String userGroupId;
  String userGroupName;
  int totalRows;

  TeamModel(
      {this.id,
        this.name,
        this.nameUnsigned,
        this.unitId,
        this.unitName,
        this.userGroupId,
        this.userGroupName,
        this.totalRows});

  TeamModel.fromJson(JSON json) {
    id = json['id'].string;
    name = json['name'].string;
    nameUnsigned = json['nameUnsigned'].string;
    unitId = json['unitId'].string;
    unitName = json['unitName'].string;
    userGroupId = json['userGroupId'].string;
    userGroupName = json['userGroupName'].string;
    totalRows = json['totalRows'].integer;
  }

  Map toJson() {
    final map = {};
    map['id'] = id;
    map['name'] = name;
    map['nameUnsigned'] = nameUnsigned;
    map['unitName'] = unitName;
    map['unitId'] = unitId;
    map['userGroupId'] = userGroupId;
    map['userGroupName'] = userGroupName;
    map['totalRows'] = totalRows;
    return map;
  }

}
