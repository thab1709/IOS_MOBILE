// @dart=2.9
import 'package:g_json/g_json.dart';

class LineNodeModel {
  String id;
  String name;
  String code;
  bool isSelected;
  bool isAllowEdit;

  LineNodeModel({this.id, this.name, this.code, this.isSelected, this.isAllowEdit});

  LineNodeModel.fromJson(JSON json) {
    id = json['id'].stringValue;
    name = json['name'].stringValue;
    code = json['code'].stringValue;
    isSelected = json['isSelected'].boolean;
    isAllowEdit = json['isAllowEdit'].boolean;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['isSelected'] = isSelected;
    data['isAllowEdit'] = isAllowEdit;
    return data;
  }
}

