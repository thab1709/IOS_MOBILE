// @dart=2.9
import 'package:evnmobile/src/htdct/models/day_night/popups/images_model.dart';
import 'package:g_json/g_json.dart';

class TBAGroupCheckModel {
  String id;
  String updatedTime;
  List<Groups> groups;

  TBAGroupCheckModel({
    this.id = '',
    this.updatedTime = '',
    this.groups = const <Groups>[],
  });

  TBAGroupCheckModel.fromJson(JSON json) {
    if(json.value == null) return;
    id = json['id'].stringValue;
    updatedTime = json['updatedTime'].stringValue;
    if (json['groups'] != null) {
      groups = <Groups>[];
      json['groups'].list.forEach((v) {
        groups.add(Groups.fromJson(v));
      });
    }
  }
}

class Groups {
  String idImage;
  String userId;
  String name;
  String position;
  int level;
  String atLevel;
  List<Images> images = const <Images>[];

  Groups(
      {this.userId,
      this.name,
      this.position,
      this.level,
      this.atLevel,
      this.images = const <Images>[]});

  Groups.fromJson(JSON json) {
    idImage = json['id'].stringValue;
    userId = json['userId'].stringValue;
    name = json['name'].stringValue;
    position = json['position'].stringValue;
    level = json['level'].integer;
    atLevel = json['atLevel'].stringValue;
  }
}

