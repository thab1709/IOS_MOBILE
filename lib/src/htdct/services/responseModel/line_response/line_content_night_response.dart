// @dart=2.9
import 'package:g_json/g_json.dart';

import '../../../models/line/line_content_night_time_model.dart';

class LineContentNightResponse{
  LineContentNightResponse.fromJson(JSON json) {
    if (json != null) {
      model = ContentNightTimeModel.fromJson(json['data']);
    }
  }
  ContentNightTimeModel model;
}
