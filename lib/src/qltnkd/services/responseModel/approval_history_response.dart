// @dart=2.9
import 'package:evnmobile/src/htld/models/paging.dart';
import 'package:evnmobile/src/qltnkd/models/report_approval_history_model.dart';
import 'package:g_json/g_json.dart';

class ApprovalHistoryResponse {
  List<ApprovalHistoryModel> listHistory;
  Paging paging;

  ApprovalHistoryResponse.fromJson(JSON json){
    if(json!=null){
      final data = json['data'].listObject;
      paging = Paging.fromJson(json['paging']);
      listHistory = data?.map((e) => ApprovalHistoryModel.fromJson(JSON(e)))?.toList();
    }
  }
}

