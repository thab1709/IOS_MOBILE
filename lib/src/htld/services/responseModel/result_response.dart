// @dart=2.9
import 'package:evnmobile/src/htld/models/result_model.dart';
import 'package:g_json/g_json.dart';

import '../server_response.dart';

class ResultResponse extends ServerResponse {
  ResultResponse.fromJson(JSON json) : super.fromJson(json) {
    resultModel = ResultModel.fromJson(json['data']);
  }

  ResultModel resultModel;
}

class LineResultResponse extends ServerResponse {
  LineResultResponse.fromJson(JSON json) : super.fromJson(json) {
    resultModel = LineResultModel.fromJson(json['data']);
  }

  LineResultModel resultModel;
}


