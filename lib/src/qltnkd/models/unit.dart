// @dart=2.9
import 'package:g_json/g_json.dart';

class UnitReport {
  String id;
  String code;
  String name;
  bool hasDepartment;

  UnitReport({
      this.id, 
      this.code, 
      this.name, 
      this.hasDepartment});

  UnitReport.fromJson(JSON json) {
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

class ReportType{
  int id;
  String name;

  ReportType({
    this.id,
    this.name,
    });

  ReportType.fromJson(JSON json) {
    id = json['id'].integer;
    name = json['name'].string;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }
}
