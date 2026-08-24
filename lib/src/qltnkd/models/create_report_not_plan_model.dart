// @dart=2.9
import 'package:g_json/g_json.dart';

class EquipmentDetails {
  String id;
  String name;
  List<Forms>forms;

  EquipmentDetails({this.id, this.name,this.forms});

  EquipmentDetails.fromJson(JSON json) {
    id = json['id'].string;
    name = json['name'].string;
    forms = json['forms']?.listObject?.map((e) => Forms.fromJson(JSON(e)))?.toList();
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    if (forms != null) {
      map['forms'] = forms?.map((e) => e?.toJson())?.toList();
    }
    return map;
  }
}

class EquipmentTypes {
  String id;
  String name;
  List<EquipmentDetails> equipmentDetails;

  EquipmentTypes({this.id, this.name, this.equipmentDetails});

  EquipmentTypes.fromJson(JSON json) {
    id = json['id'].string;
    name = json['name'].string;
    equipmentDetails = json['equipmentDetails']?.listObject?.map((e) => EquipmentDetails.fromJson(JSON(e)))?.toList();
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    if(equipmentDetails != null){
      map['equipmentDetails'] = equipmentDetails?.map((e) => e?.toJson())?.toList();
    }
    return map;
  }
}

class Unit {
  String id, name;

  Unit({this.id, this.name});

  Unit.fromJson(JSON json) {
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
class ReportTyped{
  String key,label;

  ReportTyped({this.key, this.label});

  ReportTyped.fromJson(JSON json) {
    key = json['key'].string;
    label = json['label'].string;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['key'] = key;
    map['label'] = label;
    return map;
  }
}

class Forms {
  String id, name;
  int type;

  Forms({this.id, this.name, this.type});

  Forms.fromJson(JSON json) {
    id = json['id'].string;
    name = json['name'].string;
    type = json['type'].integer;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['type'] = type;
    return map;
  }
}

class UnscheduledReport {
  List<Unit>units;
  List<ReportTyped>reportTyped;
  List<EquipmentTypes>equipmentTypes;

  UnscheduledReport({this.units, this.reportTyped, this.equipmentTypes});

  UnscheduledReport.fromJson(JSON json) {
    units = json['units']?.listObject?.map((e) => Unit.fromJson(JSON(e)))?.toList();
    reportTyped = json['reportTypes']?.listObject?.map((e) => ReportTyped.fromJson(JSON(e)))?.toList();
    equipmentTypes = json['equipmentTypes']?.listObject?.map((e) => EquipmentTypes.fromJson(JSON(e)))?.toList();
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (units != null) {
      map['units'] = units?.map((e) => e?.toJson())?.toList();
    }
    if (reportTyped != null) {
      map['reportTypes'] = reportTyped?.map((e) => e?.toJson())?.toList();
    }
    if (equipmentTypes != null) {
      map['equipmentTypes'] = equipmentTypes?.map((e) => e?.toJson())?.toList();
    }
    return map;
  }
}


