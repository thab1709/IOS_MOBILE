// @dart=2.9
import 'package:g_json/g_json.dart';

import '../../../models/abnormal/abnormal_detail_model.dart';
import '../../../models/abnormal/abnormal_history_model.dart';
import '../../../models/abnormal/abnormal_info_model.dart';
import '../../../models/abnormal/abnormal_raw.dart';

class TAbnormalPopupResponse {
  TAbnormalPopupResponse.fromJson(JSON json) {
    if (json != null) {
      final data = json['data'].listObject;
      list = data?.map((e) => AbnormalRaw.fromJson(JSON(e)))?.toList();
    }
  }
  List<AbnormalRaw> list;
}

class TAbnormalResponse {
  TAbnormalResponse.fromJson(JSON json){
    if (json != null) {
      final data = json['data'].listObject;
      paging = Paging.fromJson(json['paging']);
      list = data?.map((e) => TAbnormalInfoModel.fromJson(JSON(e)))?.toList();
    }
  }
  List<TAbnormalInfoModel> list;
  Paging paging;
}
class TAbnormalDetailResponse {
  TAbnormalDetailResponse.fromJson(JSON json){
    if (json != null) {
      final data = json['data'].mapObject;
      model = TAbnormalDetailModel.fromJson(data);
    }
  }
  TAbnormalDetailModel model;
}
class TAbnormalHistoryResponse {
  TAbnormalHistoryResponse.fromJson(JSON json){
    if (json != null) {
      final data = json['data'].listObject;
      list = data?.map((e) => TAbnormalHistoryModel.fromJson(JSON(e)))?.toList();
    }
  }
  List<TAbnormalHistoryModel> list;
}

