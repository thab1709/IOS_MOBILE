// @dart=2.9
import 'package:evnmobile/src/htld/models/equipment_model.dart';
import 'package:evnmobile/src/htld/models/paging.dart';
import 'package:g_json/g_json.dart';

class LineNodesResponse {
  LineNodesResponse.fromJson(JSON json){
    if (json != null) {
      final data = json['data'].listObject;
      paging = Paging.fromJson(json['paging']);
      list = data?.map((e) => EquipmentModel.fromJson(JSON(e)))?.toList();
    }
  }
  List<EquipmentModel> list;
  Paging paging;
}
