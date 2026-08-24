// @dart=2.9
import 'package:g_json/g_json.dart';

import '../../models/work_current_user_model.dart';
import '../../models/work_model.dart';

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

class WorkCurrentUserResponse {
  WorkCurrentUserResponse.fromJson(JSON json){
    if (json != null) {
      final data = json['data'].listObject;
      list = data?.map((e) => WorkCurrentUserModel.fromJson(JSON(e)))?.toList();
    }
  }
  List<WorkCurrentUserModel> list;
}
class WorkCurrentUserIntResponse {
  WorkCurrentUserIntResponse.fromJson(JSON json){
    if (json != null) {
      final data = json['data'].listObject;
      list = data?.map((e) => WorkCurrentUserIntModel.fromJson(JSON(e)))?.toList();
    }
  }
  List<WorkCurrentUserIntModel> list;
}
