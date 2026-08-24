// @dart=2.9
import 'package:evnmobile/src/htld/models/paging.dart';
import 'package:evnmobile/src/qltnkd/models/report_work.dart';
import 'package:g_json/g_json.dart';

import '../../models/form_report_copy_model.dart';

class FormReportCopyResponseModel {
  FormReportCopyResponseModel.fromJson(JSON json) {
    if (json != null) {
      final data = json['data'].listObject;
      paging = Paging.fromJson(json['paging']);
      list = data?.map((e) => FormReportCopyModel.fromJson(JSON(e)))?.toList();
    }
  }

  List<FormReportCopyModel> list = <FormReportCopyModel>[];
  Paging paging;
}

