// @dart=2.9
import 'package:g_json/g_json.dart';

class LineEquipmentModel {
  String id;
  String equipmentType;
  String equipmentName;
  String nodeName;
  String code;
  String substationId;

  LineEquipmentModel(
      {this.id,
      this.equipmentType,
      this.equipmentName,
      this.nodeName,
      this.code,
      this.substationId});

  LineEquipmentModel.fromJson(JSON json) {
    id = json['id'].stringValue;
    equipmentType = json['equipmentType'].stringValue;
    equipmentName = json['equipmentName'].stringValue;
    nodeName = json['nodeName'].stringValue;
    code = json['code'].stringValue;
    substationId = json['substationId'].stringValue;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['equipmentType'] = equipmentType;
    data['equipmentName'] = equipmentName;
    data['nodeName'] = nodeName;
    data['code'] = code;
    data['substationId'] = substationId;
    return data;
  }
}

