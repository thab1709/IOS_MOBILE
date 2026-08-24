// @dart=2.9
import 'package:g_json/g_json.dart';

class ResultModel {
  String substationSituation;
  String solution;
  bool isAllowComplete;
  String dueDate;
  String updateBy;
  String updateDate;
  String completionTime;
  String updatedTime;
  String settlementTime;
  String lineStatus;
  String suggestionSolution;
  bool isAbnormal;
  String voltageCabinetsResult;
  String sign;
  String userComplete;

  ResultModel(
      {this.substationSituation,
      this.solution,
      this.isAllowComplete,
      this.dueDate,
      this.updateBy,
      this.sign,
      this.updateDate,
      this.completionTime,
      this.settlementTime,
      this.updatedTime,
      this.isAbnormal,
      this.userComplete,
      this.voltageCabinetsResult});

  ResultModel.fromJson(JSON json) {
    substationSituation = json['substationSituation'].stringValue;
    solution = json['solution'].stringValue;
    isAllowComplete = json['isAllowComplete'].boolean;
    dueDate = json['dueDate'].stringValue;
    updateBy = json['updateBy'].stringValue;
    updateDate = json['updateDate'].stringValue;
    completionTime = json['completionTime'].stringValue;
    updatedTime = json['updatedTime'].stringValue;
    settlementTime = json['settlementTime'].stringValue;
    lineStatus = json['lineStatus'].stringValue;
    suggestionSolution = json['suggestionSolution'].stringValue;
    sign = json['sign'].stringValue;
    userComplete = json['userComplete'].stringValue;
    isAbnormal = json['isAbnormal'].boolean;
    voltageCabinetsResult = (json['voltageCabinetsResult'].stringValue??'').replaceAll('\n ', '\n');
  }
}

