// @dart=2.9
import 'package:evnmobile/src/htld/models/line/line_model.dart';
import 'package:g_json/g_json.dart';

class LineResponse {
  List<LineModel> lines;

  LineResponse.fromJson(JSON json) {
    lines = json['data']?.list?.map((e) => LineModel.fromJson(e))?.toList();
  }
}
