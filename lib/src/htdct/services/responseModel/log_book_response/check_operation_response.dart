// @dart=2.9
import 'package:evnmobile/src/htdct/models/log_book/group_note_model.dart';
import 'package:g_json/g_json.dart';

import '../../../models/log_book/group_note_info_model.dart';
import '../../../models/log_book/operation_model.dart';
import '../../../models/log_book/total_check_model.dart';


class CheckOperationResponse {
  CheckOperationResponse.fromJson(JSON json){
    if (json != null) {
      final data = json['data'].listObject;
      list = data?.map((e) => OperationModel.fromJson(JSON(e)))?.toList();
    }
  }
  List<OperationModel> list;
}
class GroupCheckNoteResponse {
  GroupCheckNoteResponse.fromJson(JSON json){
    if (json != null) {
      final data = json['data'].listObject;
      list = data?.map((e) => GroupCheckNoteInfoModel.fromJson(JSON(e)))?.toList();
    }
  }
  List<GroupCheckNoteInfoModel> list;
}
class CheckOperationModelResponse {
  CheckOperationModelResponse.fromJson(JSON json){
    if (json != null) {
      model = OperationModel.fromJson(json['data']);
    }
  }
  OperationModel model;
}
class CheckCheckNoteModelResponse {
  CheckCheckNoteModelResponse.fromJson(JSON json){
    if (json != null) {
      model = GroupCheckNoteModel.fromJson(json['data']);
    }
  }
  GroupCheckNoteModel model;
}
class TotalCheckResponse {
  TotalCheckResponse.fromJson(JSON json){
    if (json != null) {
      model = TotalCheckModel.fromJson(json['data']);
    }
  }
  TotalCheckModel model;
}
