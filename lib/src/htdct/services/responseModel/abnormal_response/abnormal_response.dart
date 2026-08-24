// @dart=2.9
import 'package:g_json/g_json.dart';

import '../../../models/abnormal/abnormal_detail_model.dart';
import '../../../models/abnormal/abnormal_history_model.dart';
import '../../../models/abnormal/abnormal_info_model.dart';
import '../../../models/option_model.dart';

class StringOptionsResponse {
  StringOptionsResponse.fromJson(JSON json) {
    if (json != null) {
      final data = json['data'].listObject;
      list = data?.map((e) => OptionModelString(e['name'],e['id']))?.toList();
    }
  }
  List<OptionModelString> list;
}

class AbnormalResponse {
  AbnormalResponse.fromJson(JSON json){
    if (json != null) {
      final data = json['data'].listObject;
      paging = Paging.fromJson(json['paging']);
      list = data?.map((e) => AbnormalInfoModel.fromJson(JSON(e)))?.toList();
    }
  }
  List<AbnormalInfoModel> list;
  Paging paging;
}
class AbnormalDetailResponse {
  AbnormalDetailResponse.fromJson(JSON json){
    if (json != null) {
      final data = json['data'].mapObject;
      model = AbnormalDetailModel.fromJson(data);
    }
  }
  AbnormalDetailModel model;
}
class AbnormalHistoryResponse {
  AbnormalHistoryResponse.fromJson(JSON json){
    if (json != null) {
      final data = json['data'].listObject;
      list = data?.map((e) => AbnormalHistoryModel.fromJson(JSON(e)))?.toList();
    }
  }
  List<AbnormalHistoryModel> list;
}

