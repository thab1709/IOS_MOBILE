// @dart=2.9
import 'package:evnmobile/src/htdct/models/feed_back.dart';
import 'package:evnmobile/src/htdct/models/feedback_detail_model.dart';
import 'package:g_json/g_json.dart';

import '../../models/work_model.dart';

class FeedBackResponse {
  FeedBackResponse.fromJson(JSON json) {
    if (json != null) {
      final data = json['data'].listObject;
      paging = Paging.fromJson(JSON(json['paging']));
      list = data?.map((e) => FeedBack.fromJson(JSON(e)))?.toList();
    }
  }

  List<FeedBack> list;
  Paging paging;
}

class FeedBackDetailResponse {
  FeedBackDetailResponse.fromJson(JSON json) {
    if (json != null) {
      final data = json['data'].mapObject;
      model = FeedbackDetailModel.fromJson(data);
    }
  }

  FeedbackDetailModel model;
}
