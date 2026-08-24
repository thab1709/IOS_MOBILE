// @dart=2.9
import 'package:g_json/g_json.dart';

class LineNode {
  String id;
  String lineId;
  String lineName;
  String lineBranchId;
  String lineBranchName;
  dynamic lineChildId;
  dynamic lineChildName;
  List<Substations> substations;

  LineNode({
      this.id, 
      this.lineId, 
      this.lineName, 
      this.lineBranchId, 
      this.lineBranchName, 
      this.lineChildId, 
      this.lineChildName, 
      this.substations});

  LineNode.fromJson(JSON json) {
    id = json['id'].string;
    lineId = json['lineId'].string;
    lineName = json['lineName'].string;
    lineBranchId = json['lineBranchId'].string;
    lineBranchName = json['lineBranchName'].string;
    lineChildId = json['lineChildId'];
    lineChildName = json['lineChildName'];
    if (json['substations'] != null) {
      substations = [];
      json['substations'].list.forEach((v) {
        substations.add(Substations.fromJson(v));
      });
    }

  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['lineId'] = lineId;
    map['lineName'] = lineName;
    map['lineBranchId'] = lineBranchId;
    map['lineBranchName'] = lineBranchName;
    map['lineChildId'] = lineChildId;
    map['lineChildName'] = lineChildName;
    if (substations != null) {
      map['substations'] = substations.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Substations {
  String id;
  String name;
  String code;
  int position;

  Substations({
      this.id, 
      this.name, 
      this.code, 
      this.position});

  Substations.fromJson(JSON json) {
    id = json['id'].string;
    name = json['name'].string;
    code = json['code'].string;
    position = json['position'].integer;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['code'] = code;
    map['position'] = position;
    return map;
  }

}
