// @dart=2.9
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/qltnkd/common/components/report_status_icon.dart';
import 'package:flutter/material.dart';
import 'package:evnmobile/src/qltnkd/common/constance/r_user_role_type.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';
import 'package:g_json/g_json.dart';

class ListReportModel {
  String content;
  String createdBy;
  String createdByName;
  String createdDate;
  String department;
  String departmentId;
  String equipmentDetail;
  String equipmentDetailId;
  String formName;
  String id;
  bool isAllowAccept;
  bool isAllowApprove;
  bool isAllowDelete;
  bool isAllowEditing;
  bool isAllowReceive;
  bool isAllowReject;
  bool isAllowSend;
  String location;
  String reportNumber;
  String reportTypeName;
  int reportType;
  String scheduleType;
  String team;
  String teamId;
  String updateBy;
  String updateByName;
  String userImp;
  String userImpId;
  int workingStatus;
  String workingStatusName;
  String workId;
  bool isSelected;
  bool isSync;
  bool isMonitor;
  bool isApprover;
  bool isAlowSign;
  String equipmentTypeId;
  bool isExistLocation;
  bool exportCertificateAccreditation;
  bool exportCertificateTest;
  String unitId;
  bool isCbm;

  ListReportModel(
      {this.content,
      this.createdBy,
      this.createdByName,
      this.createdDate,
      this.department,
      this.departmentId,
      this.equipmentDetail,
      this.equipmentDetailId,
      this.formName,
      this.id,
      this.isApprover,
      this.isAllowAccept,
      this.isAllowApprove,
      this.isAllowDelete,
      this.isAllowEditing,
      this.isAllowReceive,
      this.isAllowReject,
      this.isAllowSend,
      this.isExistLocation,
      this.location,
      this.reportNumber,
      this.reportTypeName,
      this.reportType,
      this.team,
      this.scheduleType,
      this.teamId,
      this.isMonitor,
      this.updateBy,
      this.workId,
      this.updateByName,
      this.userImp,
      this.userImpId,
      this.workingStatus,
      this.workingStatusName,
      this.isSync,
      this.equipmentTypeId,
      this.isSelected,
      this.isAlowSign,
      this.exportCertificateAccreditation = false,
      this.exportCertificateTest = false,
      this.unitId});

  ListReportModel.fromJson(JSON json) {
    content = json['content'].string;
    workId = json['workId'].string;
    isSelected = false;
    createdBy = json['createdBy'].string;
    createdByName = json['createdByName'].string;
    createdDate = json['createdDate'].string;
    department = json['department'].string;
    departmentId = json['departmentId'].string;
    equipmentDetail = json['equipmentDetail'].string;
    equipmentDetailId = json['equipmentDetailId'].string;
    formName = json['formName'].string;
    scheduleType = json['scheduleType'].string;
    id = json['id'].string;
    isAllowAccept = json['isAllowAccept'].boolean;
    isAllowApprove = json['isAllowApprove'].boolean;
    isAllowDelete = json['isAllowDelete'].boolean;
    isApprover = json['isApprover'].boolean;
    isAllowEditing = json['isAllowEditing'].boolean;
    isAllowReceive = json['isAllowReceive'].boolean;
    isExistLocation = json['isExistLocation'].boolean;
    isMonitor = json['isMonitor'].boolean;
    isAllowReject = json['isAllowReject'].boolean;
    isAllowSend = json['isAllowSend'].boolean;
    location = json['location'].string;
    reportNumber = json['reportNumber'].string;
    reportTypeName = json['reportTypeName'].string;
    reportType = json ['reportType'].integer;
    team = json['team'].string;
    teamId = json['teamId'].string;
    updateBy = json['updateBy'].string;
    updateByName = json['updateByName'].string;
    userImp = json['userImp'].string;
    userImpId = json['userImpId'].string;
    workingStatus = json['workingStatus'].integer;
    workingStatusName = json['workingStatusName'].string;
    isSync = json['isSync']?.boolean;
    exportCertificateTest = json['exportCertificateTest']?.boolean;
    exportCertificateAccreditation = json['exportCertificateAccreditation']?.boolean;
    equipmentTypeId = json['equipmentTypeId'].string;
    unitId = json ['unitId'].string;
    isAlowSign = json ['isAlowSign'].boolean ?? false;
    isCbm = json['isCbm'].boolean ?? false;
  }

  Map<String ,dynamic> toJson(){
    final map = <String, dynamic>{};
    map['content'] = content;
    map['workId'] = workId;
    isSelected = false;
    map['createdBy'] = createdBy;
    map['createdByName'] = createdByName;
    map['createdDate'] = createdDate;
    map['department'] = department;
    map['departmentId'] = departmentId;
    map['equipmentDetail'] = equipmentDetail;
    map['equipmentDetailId'] = equipmentDetailId;
    map['formName'] = formName;
    map['isApprover'] = isApprover;
    map['id'] = id;
    map['isAllowAccept'] = isAllowAccept;
    map['isAllowApprove'] = isAllowApprove;
    map['isAllowDelete'] = isAllowDelete;
    map['isAllowEditing'] = isAllowEditing;
    map['isExistLocation'] = isExistLocation;
    map['isAllowReceive'] = isAllowReceive;
    map['isAllowReject'] = isAllowReject;
    map['isAllowSend'] = isAllowSend;
    map['location'] = location;
    map['reportNumber'] = reportNumber;
    map['reportTypeName'] = reportTypeName;
    map['reportType'] = reportType;
    map['team'] = team;
    map['isMonitor'] = isMonitor;
    map['teamId'] = teamId;
    map['scheduleType'] = scheduleType;
    map['updateBy'] = updateBy;
    map['updateByName'] = updateByName;
    map['userImp'] = userImp;
    map['userImpId'] = userImpId;
    map['workingStatus'] = workingStatus;
    map['workingStatusName'] = workingStatusName;
    map['isSync'] = isSync;
    map['equipmentTypeId'] = equipmentTypeId;
    map['unitId'] = unitId;
    map['exportCertificateAccreditation'] = exportCertificateAccreditation;
    map['exportCertificateTest'] = exportCertificateTest;
    map['isAlowSign'] = isAlowSign ?? false;
    return map;
  }

  String getCreateDate() {
    return createdDate?.fromFormatUtcToFormatLocal(RAppStrings.hhmmddMMyyyy) ?? '';
  }

  bool isShowButtonExportAccreditation() {

    return exportCertificateAccreditation && AppShared.instance.getUserProfile().isHasCreateFormReport();
  }

  bool isShowButtonExportTest() {

    return exportCertificateTest && AppShared.instance.getUserProfile().isHasCreateFormReport();
  }

  bool isEdit() {

    return AppShared.instance.getUserProfile().id == userImpId;
  }

  Widget getStatusIconWidget() {
    return ReportStatusIcon.build(
      status: workingStatus,
      statusText: workingStatusName,
      rightPadding: 8,
    );
  }
}

