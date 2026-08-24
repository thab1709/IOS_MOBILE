// @dart=2.9
import 'package:g_json/g_json.dart';

import '../../models/day_night/popups/images_model.dart';

class ImagesGroupResponse {
  ImagesGroupResponse.fromJson(JSON json) {
    if (json != null) {
      final data = json['data'].listObject;
      list = data?.map((e) => Images.fromJsonGroup(JSON(e)))?.toList();
    }
  }
  List<Images> list;
}

