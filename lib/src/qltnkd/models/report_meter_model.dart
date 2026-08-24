// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/constance/r_user_role_type.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/models/report_work.dart';
import 'package:evnmobile/src/qltnkd/models/sub_report_meter_model.dart';
import 'package:flutter/material.dart';
import 'package:g_json/g_json.dart';

class ReportMeterModel {
  ReportMeterModel({
    this.id,
    this.formReportId,
    this.location,
    this.unitId,
    this.unitRequest,
    this.jobProgress,
    this.equipmentTypeName,
    this.createdDate,
    this.userImp,
    this.equipmentName,
    this.workType,
    this.isSync,
    this.isAllowEditing,
    this.isAllowRecall,
  });

  ReportMeterModel.fromJson(JSON json) {
    id = json['id'].string;
    formReportId = json['meterFormReportId'].string;
    location = json['location'].string;
    unitId = json['unitId'].string;
    unitRequest = json['unitRequest'].string;
    jobProgress = json['jobProgress'].string;
    equipmentTypeName = json['equipmentTypeName'].string;
    createdDate = json['createdDate'].string;
    userImp = json['userImp']?.listObject?.map((e) => UserImp.fromJson(JSON(e)))?.toList();

    reportMergeModels = json['reportMergeModels']
        ?.listObject
        ?.map((e) => SubReportMeterModel.fromJson(JSON(e)))
        ?.toList();
    isExpand = false;
    isSelected = false;
    equipmentName = json['equipmentName'].string;
    workType = json['workType'].string;
    isAllowSend = json['isAllowSend'].boolean;
    isAllowApprovedOrRejected = json['isAllowApprovedOrRejected'].boolean;
    isAllowEditing = json['isAllowEditing'].boolean;
    isExistLocation = json['isExistLocation'].boolean;
    equipmentTypeId = json['equipmentTypeId'].string;
    equipmentDetailId = json['equipmentDetailId'].string;
    isAllowRecall = json['isAllowRecall'].boolean;
    isAllowDelete = json['isAllowDelete'].boolean;
    isMeter = json['isMeter'].boolean;
    isSync = json['isSync'].boolean ?? true;
  }

  String id;
  String formReportId;
  String location;
  String unitId;
  String unitRequest;
  String jobProgress;
  String equipmentTypeName;
  String createdDate;
  List<UserImp> userImp;
  String equipmentName;
  String workType;
  List<SubReportMeterModel> reportMergeModels;
  bool isExpand;
  bool isSelected;
  bool isAllowSend;
  bool isAllowApprovedOrRejected;
  bool isAllowEditing;
  bool isExistLocation;
  bool isSync;
  bool isAllowRecall;
  bool isAllowDelete;
  bool isMeter;
  String equipmentTypeId;
  String equipmentDetailId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['meterFormReportId'] = formReportId;
    map['location'] = location;
    map['unitId'] = unitId;
    map['unitRequest'] = unitRequest;
    map['jobProgress'] = jobProgress;
    map['equipmentTypeName'] = equipmentTypeName;
    map['createdDate'] = createdDate;
    map['isExistLocation'] = isExistLocation;
    map['equipmentTypeId'] = equipmentTypeId;
    map['equipmentDetailId'] = equipmentDetailId;
    if (reportMergeModels != null) {
      map['reportMergeModels'] = reportMergeModels.map((v) => v.toJson()).toList();
    }
    if (userImp != null) {
      map['userImp'] = userImp.map((v) => v.toJson()).toList();
    }
    map['equipmentName'] = equipmentName;
    map['workType'] = workType;
    map['isAllowSend'] = isAllowSend;
    map['isAllowDelete'] = isAllowDelete;
    map['isMeter'] = isMeter;
    map['isAllowApprovedOrRejected'] = isAllowApprovedOrRejected;
    map['isAllowEditing'] = isAllowEditing;
    map['isSync'] = isSync;
    return map;
  }

  Widget getListNameUserImp() {
    return RichText(
        text: TextSpan(
            children: userImp
                .mapIndexed((e, i) => TextSpan(
                text: i != userImp.length - 1 ? '${e.name}, ' : e.name,
                style: TextStyle(
                    color: e.isUserCreated ? RAppColor.highlightColor70 : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)))
                .toList()));
  }

  String getDate() {
    return '${createdDate?.fromFormatUtcToFormatLocal(RAppStrings.ddMMyyyy) ?? ''}';
  }

  bool isHasPermissionViewLocation() {
    return !RUserRole.isWorker && isExistLocation == true;
  }
}

