// @dart=2.9
import 'package:g_json/g_json.dart';

class RequestModel {
  RequestModel({
    this.id,
    this.code,
    this.type,
    this.typeName,
    this.status,
    this.content,
    this.unitId,
    this.unitName,
    this.location,
    this.requestType,
    this.statusName,
  });

  RequestModel.fromJson(JSON json) {
    id = json['id'].string;
    code = json['code'].string;
    type = json['type'].integer;
    typeName = json['typeName'].string;
    status = json['status'].integer;
    content = json['content'].string;
    unitId = json['unitId'].string;
    unitName = json['unitName'].string;
    location = json['location'].string;
    requestType = json['requestType'].integer;
    statusName = json['statusName'].string;
    userName = json['createdByName'].string;
    userPosition = json['position'].string;
  }

  String id;
  String code;
  int type;
  int status;
  String typeName;
  String content;
  String unitId;
  String unitName;
  String location;
  int requestType;
  String statusName;
  String userName;
  String userPosition;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['code'] = code;
    map['type'] = type;
    map['typeName'] = typeName;
    map['status'] = status;
    map['content'] = content;
    map['unitId'] = unitId;
    map['unitName'] = unitName;
    map['location'] = location;
    map['requestType'] = requestType;
    map['statusName'] = statusName;
    map['createdByName'] = userName;
    map['position'] = userPosition;
    return map;
  }
}

