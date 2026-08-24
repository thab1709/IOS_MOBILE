// @dart=2.9
import 'package:evnmobile/src/htdct/models/line/line_general_info_model.dart';
import 'package:g_json/g_json.dart';

class LineGeneralInfoResponse {
  LineGeneralInfoResponse.fromJson(JSON json) {
    if (json != null) {
      lineGeneralInfoModel = LineGeneralInfoModel.fromJson(json['data']);
    }
  }
  LineGeneralInfoModel lineGeneralInfoModel;
}

