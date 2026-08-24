// @dart=2.9
import 'package:evnmobile/src/htdct/models/day_night/tba_content_check.dart';
import 'package:g_json/g_json.dart';

import '../../models/day_night/tba_content_night_time.dart';

class ContentCheckResponse {
  ContentCheckResponse.fromJson(JSON json) {
    if (json != null) {
      tbaContentCheckModel = ContentCheckModel.fromJson(json['data']);
    }
  }
  ContentCheckModel tbaContentCheckModel;
}
class NightContentCheckResponse {
  NightContentCheckResponse.fromJson(JSON json) {
    if (json != null) {
      transformerNightTime = TransformerNightTime.fromJson(json['data']);
    }
  }
  TransformerNightTime transformerNightTime;
}
