// @dart=2.9
import 'package:g_json/g_json.dart';

import '../../../models/line/popups/violate_inspection_model.dart';
import '../../../models/work_model.dart';

class LineViolateInspectionResponse {
  LineViolateInspectionResponse.fromJson(JSON json) {
    if (json != null) {
      final data = json['data'].listObject;
      paging = Paging.fromJson(json['paging']);
      list = data?.map((e) => ViolateModel.fromJson(JSON(e)))?.toList();
    }
  }
  List<ViolateModel> list;
  Paging paging;
}
class ViolateInspectionResponse{
  ViolateInspectionResponse.fromJson(JSON json) {
    if (json != null) {
      model = ViolateModel.fromJson(json['data']);
    }
  }
  ViolateModel model;
}
