// @dart=2.9
import 'package:evnmobile/src/htld/models/paging.dart';
import 'package:evnmobile/src/qltnkd/models/work_merge_model.dart';
import 'package:g_json/g_json.dart';

class MergeReportResponse{
  List<WorkMergeModel> listReport;
  Paging paging;
  MergeReportResponse.fromJson(JSON json){
    if (json != null) {
      final data = json['data'].listObject;
      paging = Paging.fromJson(json['paging']);
      listReport = data?.map((e) => WorkMergeModel.fromJson(JSON(e)))?.toList();
    }
  }
}
