// @dart=2.9
import 'package:evnmobile/src/htdct/models/day_night/tba_group_model.dart';
import 'package:g_json/g_json.dart';

class TBAGroupCheckResponse {
  TBAGroupCheckResponse.fromJson(JSON json) {
    if (json != null) {
      tbaGroupCheckModel = TBAGroupCheckModel.fromJson(json['data']);
    }
  }
  TBAGroupCheckModel tbaGroupCheckModel;
}

