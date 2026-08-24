// @dart=2.9
import 'package:g_json/g_json.dart';

class AbnormalPhenomenonResponse {
  AbnormalPhenomenonResponse.fromJson(JSON json) {
    if (json != null) {
      final data = json['data']?.listObject;
      list = data?.map((e) => JSON(e).stringValue)?.toList();
    }
  }
  List<String> list;
}

