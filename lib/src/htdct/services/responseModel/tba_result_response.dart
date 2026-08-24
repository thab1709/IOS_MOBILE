// @dart=2.9
import 'package:evnmobile/src/htdct/models/result_model.dart';
import 'package:g_json/g_json.dart';

class TBAResultResponse {
  TBAResultResponse.fromJson(JSON json) {
    if (json != null) {
      resultModel = ResultModel.fromJson(json['data']);
    }
  }
  ResultModel resultModel;
}

