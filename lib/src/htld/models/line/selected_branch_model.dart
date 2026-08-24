// @dart=2.9
import 'package:g_json/g_json.dart';

import 'line_model.dart';

class SelectedBranchModel {
  String id;
  String name;

  SelectedBranchModel.fromJson(JSON json) {
    id = json['id'].string;
    name = json['name'].string;
  }

  SelectedBranchModel.fromLineModel(LineModel model) {
    id = model.id;
    name = model.name;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }
}
