// @dart=2.9
import 'package:evnmobile/src/htld/models/paging.dart';
import 'package:evnmobile/src/htld/models/work_model.dart';
import 'package:g_json/g_json.dart';

class WorkResponse {
  WorkResponse.fromJson(JSON json){
    if (json != null) {
      final data = json['data'].listObject;
      paging = Paging.fromJson(json['paging']);
      list = data?.map((e) => WorkModel.fromJson(JSON(e)))?.toList();
    }
  }
  List<WorkModel> list;
  Paging paging;
}
