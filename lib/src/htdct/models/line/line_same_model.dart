// @dart=2.9
import 'package:g_json/g_json.dart';

class LineSameModel {
  String equipmentId ;
  String lineInspectId ;


  LineSameModel(
      {this.equipmentId,
      this.lineInspectId,
});

  LineSameModel.fromJson(JSON json) {
    equipmentId = json['equipmentId'].stringValue;
    lineInspectId = json['lineInspectId'].stringValue;

  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['equipmentId'] = equipmentId;
    data['lineInspectId'] = lineInspectId;
    return data;
  }
}

