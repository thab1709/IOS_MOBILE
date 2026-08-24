// @dart=2.9
import 'package:g_json/g_json.dart';

class UnitModel {
  String id;
  String code;
  String name;
  bool hasDepartment;
  int indexId;

  UnitModel({
      this.id, 
      this.code, 
      this.name, 
      this.hasDepartment, this.indexId});

  UnitModel.fromJson(JSON json) {
    id = json['id'].string;
    code = json['code'].string;
    name = json['name'].string;
    hasDepartment = json['hasDepartment'].boolean;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['code'] = code;
    map['name'] = name;
    map['hasDepartment'] = hasDepartment;
    return map;
  }

}
