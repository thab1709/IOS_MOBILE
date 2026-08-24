// @dart=2.9
import 'package:g_json/g_json.dart';

class GroupInUnitModel {
  String id;
  String name;
  String unitId;
  String unitName;
  int indexId;

  GroupInUnitModel(
      {this.id, this.name, this.unitId, this.unitName, this.indexId});

  GroupInUnitModel.fromJson(JSON json) {
    id = json['id'].string;
    name = json['name'].string;
    unitId = json['unitId'].string;
    unitName = json['unitName'].string;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['unitId'] = unitId;
    map['unitName'] = unitName;
    return map;
  }

}
