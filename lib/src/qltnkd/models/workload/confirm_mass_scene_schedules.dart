// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';
import 'package:flutter/material.dart';
import 'package:g_json/g_json.dart';

import '../../common/constance/report_work_status_type.dart';
import '../../common/constance/strings.dart';

class ConfirmMassSceneSchedules {

  ConfirmMassSceneSchedules.fromJson(JSON json) {
    id = json['id'].string;
    substationName = json['substationName'].string;
    constructionName = json['constructionName'].string;
    users = json['users'] != null
        ? json['users']?.list?.map((e) => JSON(e).string)?.toList()
        : [];
    equipmentType = json['equipmentType'].string;
    equipmentDetail = json['equipmentDetail'].string;
    status = json['status'].integer;
    statusName = json['statusName'].string;
    equipmentName = json['equipmentName'].string;
    scheduleType = json['scheduleType'].string;
    reason = json['reason'].string;
    note = json['note'].string;
    equipmentTypeId = json['equipmentTypeId'].string;
    equipmentDetailId = json['equipmentDetailId'].string;
    fromDate = json['startDate'].string;
    toDate = json['endDate'].string;
    formId = json['endDate'].string;
    periodicType = json['periodicType'].integer;
    isConfirmComplete = json['isConfirmComplete'].boolean;
    isChecked = json['isChecked'].boolean;
    isMeter = json['isMeter'].boolean;
  }

  String id;
  String fromDate;
  String toDate;
  String substationName;
  String constructionName;
  List<String> users;
  String equipmentType;
  String equipmentTypeId;
  int periodicType;
  String equipmentDetailId;
  String equipmentDetail;
  String equipmentName;
  int status;
  String statusName;
  String scheduleType;
  String reason;
  String formId;
  String note;
  bool isConfirmComplete;
  bool isChecked;
  bool isMeter;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['substationName'] = substationName;
    map['constructionName'] = constructionName;
    map['users'] = users;
    map['equipmentType'] = equipmentType;
    map['periodicType'] = periodicType;
    map['equipmentDetail'] = equipmentDetail;
    map['equipmentName'] = equipmentName;
    map['scheduleType'] = scheduleType;
    map['status'] = status;
    map['statusName'] = statusName;
    map['equipmentTypeId'] = equipmentTypeId;
    map['equipmentDetailId'] = equipmentDetailId;
    map['isConfirmComplete'] = isConfirmComplete;
    map['reason'] = reason;
    map['note'] = note;
    map['isChecked'] = isChecked;
    map['isMeter'] = isMeter;
    map['formId'] = formId;
    return map;
  }

  String getFromDateToDate() {
    return '${fromDate?.fromFormatUtcToFormatLocalNotZ(RAppStrings.ddmmyyyyHHmm) ?? ''} - ${toDate?.fromFormatUtcToFormatLocalNotZ(RAppStrings.ddmmyyyyHHmm) ?? ''}';
  }

  Color getItemColorStatus() {
    if (status == null) {
      return Colors.white;
    }

    if (status ==  ReportWorkStatusType.unfulfilled) {
      if (reason?.isNotEmpty == true) {
        return const Color(0xffeab6ba);
      } else {
        return const Color(0xffded09f);
      }
    } else {
      return const Color(0xffc1d9b2);
    }
  }

  String get usersPerform => users?.map((e) => e)?.join(', ');
}

