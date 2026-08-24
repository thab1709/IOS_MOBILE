// @dart=2.9

import 'package:g_json/g_json.dart';

/// substationSituation : "oke"
/// solution : "oke"
/// dueDate : "2021-04-08T16:04:09.474"
/// updateBy : "Administrator"
/// updateDate : "2021-04-09T02:13:41.356Z"

class ResultModel {
  String substationSituation;
  String solution;
  String dueDate;
  String updateBy;
  String updateDate;
  String completionTime;
  List<String> missingEquipments;
  List<String> unAssignedEquipments;
  List<String> otherMissingEquipments;

  bool isAllowComplete;

  ResultModel({
       this.substationSituation,
  this.solution,
  this.dueDate,
  this.updateBy,
  this.isAllowComplete,
  this.updateDate});

  ResultModel.fromJson(JSON json) {
    substationSituation = json['substationSituation'].string ?? '';
    solution = json['solution'].string ?? '';
    dueDate = json['dueDate'].string;
    updateBy = json['updateBy'].string;
    updateDate = json['updateDate'].string;
    completionTime = json['completionTime'].string;
    isAllowComplete = json['isAllowComplete'].boolean;
    missingEquipments = json['missingEquipments']?.listObject?.cast<String>();
    unAssignedEquipments = json['unAssignedEquipments']?.listObject?.cast<String>();
    otherMissingEquipments = json['otherMissingEquipments']?.listObject?.cast<String>();

  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['substationSituation'] = substationSituation;
    map['solution'] = solution;
    map['dueDate'] = dueDate;
    map['updateBy'] = updateBy;
    map['updateDate'] = updateDate;
    map['completionTime'] = completionTime;
    map['isAllowComplete'] = isAllowComplete;
    return map;
  }

}

/// "settlementTime": "2021-05-05T09:23:48.003Z",
/// "informationUpdateTime": "string",
/// "updateInformationAt": "2021-05-05T09:23:48.003Z"

class LineResultModel {
  String settlementTime;
  String informationUpdateTime;
  String updateInformationAt;
  String updateDate;
  String updateBy;
  bool isUpdateOffline;
  LineResultModel({
    this.isUpdateOffline = false,
});


  LineResultModel.fromJson(JSON json) {
    settlementTime = json['settlementTime']?.string;
    informationUpdateTime = json['informationUpdateTime']?.string;
    updateInformationAt = json['updateInformationAt']?.string;
    updateDate = json['updateDate']?.string;
    updateBy = json['updateBy']?.string;
    isUpdateOffline = json['isUpdateOffline']?.boolean ?? false;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['settlementTime'] = settlementTime;
    map['informationUpdateTime'] = informationUpdateTime;
    map['updateInformationAt'] = updateInformationAt;
    map['updateBy'] = updateBy;
    map['isUpdateOffline'] = isUpdateOffline ?? false;
    return map;
  }
}
