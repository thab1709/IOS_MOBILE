// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/constance/r_user_role_type.dart';
import 'package:evnmobile/src/qltnkd/common/constance/report_work_status_type.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';
import 'package:evnmobile/src/qltnkd/common/components/report_status_icon.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/models/report_work.dart';
import 'package:flutter/material.dart';
import 'package:g_json/g_json.dart';

import 'report_merge_model.dart';

class WorkMergeModel {
  WorkMergeModel({
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
    this.isPaperReport,
  });

  WorkMergeModel.fromJson(JSON json) {
    id = json['id'].string;
    formReportId = json['formReportId'].string;
    location = json['location'].string;
    substationId = json['substationId'].string;
    unitId = json['unitId'].string;
    unitRequest = json['unitRequest'].string;
    jobProgress = json['jobProgress'].string.isNotEmpty 
        ? json['jobProgress'].string 
        : json['status'].string;
    equipmentTypeName = json['equipmentTypeName'].string;
    createdDate = json['createdDate'].string;
    userImp = json['userImp']?.listObject?.map((e) => UserImp.fromJson(JSON(e)))?.toList();

    reportMergeModels = json['reportMergeModels']
        ?.listObject
        ?.map((e) => ReportMergeModel.fromJson(JSON(e)))
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
    equipmentDetailName = json['equipmentDetailName'].string;
    requestCode = json['requestCode'].string;
    equipmentCode = json['equipmentCode'].string;
    isAllowRecall = json['isAllowRecall'].boolean;
    isAllowCancel = json['isAllowCancel'].boolean;
    isMonitoring = json['isMonitoring'].boolean;
    isPaperReport = json['isPaperFormReport'].boolean;
    isHasRejected = json['isHasRejected'].boolean ?? false;
    isSync = json['isSync'].boolean ?? true;
    workingStatus = json['workingStatus'].integer ?? 0;
    
    // Nếu BE trả về false ở cấp ngoài nhưng có biên bản con là CBM thì vẫn coi là CBM
    final rootIsCbm = json['isCbm'].boolean ?? false;
    final childIsCbm = reportMergeModels?.any((element) => element.isCbm == true) ?? false;
    isCbm = rootIsCbm || childIsCbm;
  }

  String id;
  String formReportId;
  String location;
  String substationId;
  String unitId;
  String unitRequest;
  String jobProgress;
  String equipmentTypeName;
  String equipmentCode;
  String requestCode;
  String createdDate;
  List<UserImp> userImp;
  String equipmentName;
  String workType;
  List<ReportMergeModel> reportMergeModels;
  bool isExpand;
  bool isSelected;
  bool isAllowSend;
  bool isAllowApprovedOrRejected;
  bool isAllowEditing;
  bool isExistLocation;
  bool isSync;
  bool isMonitoring;
  bool isAllowRecall;
  bool isAllowCancel;
  bool isPaperReport;
  bool isHasRejected;
  bool isCbm;
  int workingStatus;
  String equipmentTypeId;
  String equipmentDetailId;
  String equipmentDetailName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['formReportId'] = formReportId;
    map['location'] = location;
    map['unitId'] = unitId;
    map['unitRequest'] = unitRequest;
    map['jobProgress'] = jobProgress;
    map['equipmentTypeName'] = equipmentTypeName;
    map['createdDate'] = createdDate;
    map['isExistLocation'] = isExistLocation;
    map['equipmentTypeId'] = equipmentTypeId;
    map['equipmentDetailId'] = equipmentDetailId;
    map['equipmentCode'] = equipmentCode;
    map['substationId'] = substationId;
    map['isMonitoring'] = isMonitoring;
    map['isPaperFormReport'] = isPaperReport;
    map['isCbm'] = isCbm;
    if (reportMergeModels != null) {
      map['reportMergeModels'] = reportMergeModels.map((v) => v.toJson()).toList();
    }
    if (userImp != null) {
      map['userImp'] = userImp.map((v) => v.toJson()).toList();
    }
    map['equipmentName'] = equipmentName;
    map['workType'] = workType;
    map['isAllowSend'] = isAllowSend;
    map['isAllowCancel'] = isAllowCancel;
    map['isAllowApprovedOrRejected'] = isAllowApprovedOrRejected;
    map['isAllowEditing'] = isAllowEditing;
    map['equipmentDetailName'] = equipmentDetailName;
    map['requestCode'] = requestCode;
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

  String getListNameUser() {
    return userImp.map((e) => e.name).join(', ');
  }

  String getDate() {
    return '${createdDate?.fromFormatUtcToFormatLocal(RAppStrings.ddMMyyyy) ?? ''}';
  }

  bool isHasPermissionViewLocation() {
    return !RUserRole.isWorker && (isExistLocation ?? false);
  }

  bool hasRejectedReport() {
    if (reportMergeModels != null) {
      return reportMergeModels.any(
          (r) => r.workingStatus == ReportStatusType.Rejected);
    }
    return isHasRejected ?? false;
  }

  // Hàm trả về icon theo trạng thái dựa trên workingStatus (int) hoặc jobProgress (string)
  Widget getStatusIconWidget() {
    return ReportStatusIcon.build(
      status: workingStatus,
      statusText: jobProgress,
      isRejected: hasRejectedReport(),
    );
  }
}

