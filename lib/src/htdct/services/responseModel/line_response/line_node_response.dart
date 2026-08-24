// @dart=2.9
import 'package:evnmobile/src/htdct/models/line/line_node_model.dart';
import 'package:g_json/g_json.dart';

class LineNodesResponse {
  LineNodesResponse.fromJson(JSON json) {
    if (json != null) {
      final data = json['data'].listObject;
      list = data?.map((e) => LineNodeModel.fromJson(JSON(e)))?.toList();
    }
  }
  List<LineNodeModel> list;
}

