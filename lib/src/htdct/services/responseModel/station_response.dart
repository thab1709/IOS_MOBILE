// @dart=2.9
import 'package:evnmobile/src/htdct/models/station.dart';
import 'package:g_json/g_json.dart';

class StationResponse {
  StationResponse.fromJson(JSON json) {
    if (json != null) {
      final data = json['data'].listObject;
      list = data?.map((e) => StationModel.fromJson(JSON(e)))?.toList();
    }
  }
  List<StationModel> list = [];
}

