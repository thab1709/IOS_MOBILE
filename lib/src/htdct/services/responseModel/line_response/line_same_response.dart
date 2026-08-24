// @dart=2.9
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:g_json/g_json.dart';

import '../../../models/line/line_same_model.dart';

class LineSameResponse {
  LineSameResponse.fromJson(JSON json) {
    if (json != null) {
      model = LineSameModel.fromJson(json['data']);
    }
  }
  LineSameModel model;
}

