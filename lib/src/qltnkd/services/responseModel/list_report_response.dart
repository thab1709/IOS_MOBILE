// @dart=2.9
import 'package:evnmobile/src/htld/models/paging.dart';
import 'package:evnmobile/src/qltnkd/models/list_report_model.dart';
import 'package:g_json/g_json.dart';

class ListReportResponse{
  List<ListReportModel> listReport;
  Paging paging;
  ListReportResponse.fromJson(JSON json){
    if (json != null) {
      final data = json['data'].listObject;
      paging = Paging.fromJson(json['paging']);
      listReport = data?.map((e) => ListReportModel.fromJson(JSON(e)))?.toList();
    }
  }
}
