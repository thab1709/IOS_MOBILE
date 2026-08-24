// @dart=2.9
import 'package:g_json/g_json.dart';

import '../../../htdct/models/abnormal/abnormal_info_model.dart';
import '../../models/report_meter_model.dart';

class ReportMeterResponse{
  List<ReportMeterModel> listReport;
  Paging paging;
  ReportMeterResponse.fromJson(JSON json){
    if (json != null) {
      final data = json['data'].listObject;
      paging = Paging.fromJson(json['paging']);
      listReport = data?.map((e) => ReportMeterModel.fromJson(JSON(e)))?.toList();
    }
  }
}
