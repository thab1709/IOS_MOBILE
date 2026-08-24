// @dart=2.9
import 'package:g_json/g_json.dart';

import '../../../models/notify/notify_detail_model.dart';
import '../../../models/notify/notify_model.dart';

class NotifyResponse {
  NotifyResponse.fromJson(JSON json){
    if (json != null) {
      final data = json['data'].listObject;
      paging = Paging.fromJson(json['paging']);
      list = data?.map((e) => NotifyModel.fromJson(JSON(e)))?.toList();
    }
  }
  List<NotifyModel> list;
  Paging paging;
}

class NotifyDetailResponse {
  NotifyDetailResponse.fromJson(JSON json){
    if (json != null) {
      final data = json['data'];
      model = NotifyDetailModel.fromJson(JSON(data));
    }
  }
  NotifyDetailModel model;
}

