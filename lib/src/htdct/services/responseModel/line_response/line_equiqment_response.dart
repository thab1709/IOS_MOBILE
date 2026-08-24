// @dart=2.9
import 'package:evnmobile/src/htdct/models/line/line_equipment_model.dart';
import 'package:evnmobile/src/htdct/models/work_model.dart';
import 'package:g_json/g_json.dart';

class LineEquipmentResponse {
  LineEquipmentResponse();
  LineEquipmentResponse.fromJson(JSON json) {
    if (json != null) {
      final data = json['data'].listObject;
      paging = Paging.fromJson(JSON(json['paging']));
      list = data?.map((e) => LineEquipmentModel.fromJson(JSON(e)))?.toList();
    }
  }
  List<LineEquipmentModel> list;
  Paging paging;
}

