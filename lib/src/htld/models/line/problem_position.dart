// @dart=2.9
import 'package:g_json/g_json.dart';

class ProblemPositions {
  int fieldValue;
  int problemValue;
  String positionId;

  ProblemPositions({
    this.fieldValue,
    this.problemValue,
    this.positionId});

  ProblemPositions.fromJson(JSON json) {
    fieldValue = json['fieldValue'].integer;
    problemValue = json['problemValue'].integer;
    positionId = json['positionId'].string;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['fieldValue'] = fieldValue;
    map['problemValue'] = problemValue;
    map['positionId'] = positionId;
    return map;
  }

}

