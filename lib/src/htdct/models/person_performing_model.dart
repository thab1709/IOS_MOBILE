// @dart=2.9
import 'package:g_json/g_json.dart';

/// id : "69bd714f-9576-45ba-b5b7-f00649be00de"
/// name : "Administrator"
/// nameUnsigned : "administrator"
/// position : null
/// level : 0
/// atLevel : null

class PersonPerformingModel {
  String userId;
  String name;
  String nameUnsigned;
  String position;
  int level;
  String atLevel;
  bool isSaved;
  String groupId;
  String groupName;

  PersonPerformingModel({
    this.userId,
    this.name,
    this.nameUnsigned,
    this.position,
    this.level,
    this.atLevel,
    this.isSaved,
    this.groupId,
    this.groupName
  });
  PersonPerformingModel.fromJson(JSON json) {
    userId = json['userId'].string;
    name = json['name'].string;
    nameUnsigned = json['nameUnsigned'].string;
    position = json['position'].string;
    level = json['level'].integer;
    atLevel = json['atLevel'].string;
    groupId = json['groupId'].string;
    groupName = json['groupName'].string;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userId'] = userId;
    map['name'] = name;
    map['nameUnsigned'] = nameUnsigned;
    map['position'] = position;
    map['level'] = level;
    map['atLevel'] = atLevel;
    map['groupId'] = groupId;
    map['groupName'] = groupName;
    return map;
  }
}

