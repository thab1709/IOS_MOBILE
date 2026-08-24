// @dart=2.9
import 'package:g_json/g_json.dart';

import '../../models/unit_model.dart';
import '../../models/work_current_user_model.dart';

class LogBookResponse {
  LogBookResponse.fromJson(JSON json){
    if (json != null) {
      final data = json['data'].listObject;
      list = data?.map((e) => EquipmentModel.fromJson(JSON(e)))?.toList();
    }
  }
  List<EquipmentModel> list;
}

class EquipmentModel {
  String id;
  String name;
  String wattage;


  EquipmentModel(
      {this.id,
        this.name,
        this.wattage
      });

  EquipmentModel.fromJson(JSON json) {
    id = json['id'].string;
    name = json['name'].string;
    wattage = json['wattage'].string;

  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['wattage'] = wattage;
    return data;
  }
}

class UnitResponse {
  UnitResponse.fromJson(JSON json){
    if (json != null) {
      final data = json['data'].listObject;
      list = data?.map((e) => UnitModel.fromJson(JSON(e)))?.toList();
    }
  }
  List<UnitModel> list;
}
