// @dart=2.9
import 'package:evnmobile/src/htdct/models/equipment_model.dart';
import 'package:g_json/g_json.dart';

import '../../models/work_model.dart';

class EquipmentResponse {
  EquipmentResponse();

  EquipmentResponse.fromJson(JSON json) {
    if (json != null) {
      final data = json['data'].listObject;
      paging = Paging.fromJson(JSON(json['paging']));
      list = data?.map((e) => EquipmentModel.fromJson(JSON(e)))?.toList();
    }
  }

  List<EquipmentModel> list;
  Paging paging;
}

