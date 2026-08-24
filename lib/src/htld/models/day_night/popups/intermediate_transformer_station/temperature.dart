// @dart=2.9
import 'package:g_json/g_json.dart';

class Temperature {
  String equipmentId;
  String equipmentName;
  String temperature;
  int coolingStatus;

  Temperature({
      this.equipmentId, 
      this.equipmentName, 
      this.temperature, 
      this.coolingStatus});

  Temperature.fromJson(JSON json) {
    equipmentId = json['equipmentId'].string;
    equipmentName = json['equipmentName'].string;
    temperature = json['temperature'].string;
    coolingStatus = json['coolingStatus'].integer;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['equipmentId'] = equipmentId;
    map['equipmentName'] = equipmentName;
    map['temperature'] = temperature;
    map['coolingStatus'] = coolingStatus;
    return map;
  }

}
