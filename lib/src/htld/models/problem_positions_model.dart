// @dart=2.9
import 'package:g_json/g_json.dart';

class ProblemPositions {
  int fieldValue;
  int problemValue;
  String positionId;
  String title;
  String groupId;
  bool isAbnormal;
  String note;
  ProblemPositions({
    this.fieldValue,
    this.problemValue,
    this.title,
    this.positionId,
    this.groupId,
    this.isAbnormal,
    this.note,
  });

  ProblemPositions.fromJson(JSON json) {
    fieldValue = json['fieldValue'].integer;
    problemValue = json['problemValue'].integer;
    positionId = json['positionId'].string;
    groupId = json['group'].string;
    isAbnormal = json['isAbnormal'].boolean;
    note = json['note'].string ?? "";
    title = json['fieldTitle'].string;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['fieldValue'] = fieldValue;
    map['problemValue'] = problemValue;
    map['positionId'] = positionId;
    map['fieldTitle'] = title;
    map['group'] = groupId;
    map['isAbnormal'] = isAbnormal;
    map['note'] = note;
    return map;
  }
}

