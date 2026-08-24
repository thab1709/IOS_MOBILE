// @dart=2.9
import 'package:g_json/g_json.dart';

class FormInfo {
  String id;
  String reportType;
  String equipmentDetailName;
  String name;

  FormInfo({this.id, this.reportType, this.equipmentDetailName, this.name});

  FormInfo.fromJson(JSON json) {
    id = json['id'].string;
    reportType = json['reportType'].string;
    equipmentDetailName = json['equipmentDetailName'].string;
    name = json['name'].string;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['reportType'] = reportType;
    map['equipmentDetailName'] = equipmentDetailName;
    map['name'] = name;
    return map;
  }
}

