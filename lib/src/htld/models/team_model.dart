// @dart=2.9
import 'package:g_json/g_json.dart';

class GroupModel {
  String id;
  String name;
  int color;

  GroupModel({
      this.id, 
      this.name, 
      this.color});

  GroupModel.fromJson(JSON json) {
    id = json['id'].string;
    name = json['name'].string;
    color = json['color'].integer;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['color'] = color;
    return map;
  }

}
