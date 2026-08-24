// @dart=2.9
import 'package:evnmobile/src/htld/common/constance/work_status_type.dart';
import 'package:evnmobile/src/htld/models/line/line_model.dart';
import 'package:evnmobile/src/htld/models/person_performing_model.dart';
import 'package:evnmobile/src/htld/models/substation_model.dart';
import 'package:g_json/g_json.dart';

import 'team_model.dart';

class WorkModel {
  String workId;
  String pmisId;
  int highlight;
  String entityId;
  SubstationModel substationModel;
  LineModel line;
  String description;
  String lastStartDate;
  String lastCompleteDate;
  String planDate;
  int workStatus;
  int totalAbnormal;
  String workStatusName;
  String frequency;
  List<GroupModel> groups;
  bool isExpand = false;
  bool isCreateOffline = false;
  bool isHasDataUpdateOffline;
  bool isAllowEdit;
  List<PersonPerformingModel> users;
  WorkModel({
      this.workId,
      this.pmisId,
      this.highlight = 0,
      this.description,
      this.lastStartDate,
      this.lastCompleteDate,
      this.planDate,
      this.workStatus,
      this.workStatusName,
      this.users,
      this.isCreateOffline = false,
      this.isHasDataUpdateOffline = false,
  });

  WorkModel.fromJson(JSON json) {
    workId = json['workId'].string;
    pmisId = json['pmsId'].string;
    highlight = json['highlight'].integer;
    entityId = json['entityId'].string;
    groups = json['userGroup']?.list?.map((e) => GroupModel.fromJson(JSON(e)))?.toList();
    substationModel = SubstationModel.fromJson(json['entity']);
    line = LineModel.fromJson(json['line']);
    isCreateOffline = json['isCreateOffline']?.boolean ?? false;
    isHasDataUpdateOffline = json['isHasDataUpdateOffline']?.boolean ?? false;
    description = json['description'].string;
    frequency = json['frequency'].string;
    lastStartDate = json['planDate'].string;
    lastCompleteDate = json['lastCompleteDate'].string;
    planDate = json['planDate'].string;
    totalAbnormal = json['totalAbnormal'].integer;
    workStatus = json['workStatus'].integer;
    workStatusName = getWorkStatusName();
    isAllowEdit = json['isAllowEdit'].boolean ?? true;
    users = json['users']?.listObject?.map((e) => PersonPerformingModel.fromJson(JSON(e)))?.toList();
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['workId'] = workId;
    map['pmsId'] = pmisId;
    map['highlight'] = highlight ?? 0;
    map['description'] = description;
    map['planDate'] = lastStartDate;
    map['lastCompleteDate'] = lastCompleteDate;
    map['planDate'] = planDate;
    map['workStatus'] = workStatus;
    map['workStatusName'] = workStatusName;
    map['entity'] = substationModel.toMap();
    map['line'] = line.toMap();
    map['entityId'] = entityId;
    map['isCreateOffline'] = isCreateOffline ?? false;
    map['isHasDataUpdateOffline'] = isHasDataUpdateOffline ?? false;
    map['frequency'] = frequency;
    map['users'] = users.map((e) => e.toJson()).toList();
    map['userGroup'] = groups.map((e) => e.toJson()).toList();
    return map;
  }

  String getWorkStatusName() {
    switch(workStatus) {
      case WorkStatusType.New:
        return 'Chưa thực hiện';
      case WorkStatusType.Inprogress:
        return 'Đang thực hiện';
      case WorkStatusType.Done:
        return 'Đã thực hiện';
      default:
        return '';
    }
  }
}
