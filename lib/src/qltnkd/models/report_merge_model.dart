// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/components/report_status_icon.dart';
import 'package:flutter/material.dart';
import 'package:g_json/g_json.dart';

import '../../app_common/shared/app_shared.dart';

class ReportMergeModel {
  ReportMergeModel({
    this.id,
    this.reportNumber,
    this.stampNumber,
    this.status,
    this.isAllowSyncToCmis,
    this.isMonitor,
    this.isAllowSign,
    this.isAllowEditing,
    this.isAllowSend,
    this.isAllowDelete,
    this.isAllowApprove,
    this.isAllowReject,
    this.isAllowReceive,
    this.isAllowAccept,
    this.isAllowSyncToPmis,
    this.isExistLocation,
    this.isSendOTP,
    this.isConfirmOTP,
    this.isConfirmChangeDate,
    this.exportCertificateAccreditation,
    this.exportCertificateTest,
    this.certificateIsAllowSend,
    this.certificateIsAllowApprove,
    this.certificateIsAllowReject,
    this.certificateIsAllowReceive,
    this.certificateIsAllowAccept,
    this.type,
    this.isAllowSignal,
    this.reportType,
    this.formType,
    this.workingStatus,
    this.unitId,
    this.createdBy,
    this.teamId,
    this.departmentId,
    this.userImps,
    this.scheduleId,
  });

  ReportMergeModel.fromJson(JSON json) {
    id = json['id'].string;
    isCbm = json['isCbm'].boolean ?? false;
    refId = json['refId'].string;
    reportNumber = json['reportNumber'].string;
    stampNumber =
        json['stampNumber']?.listObject?.map((e) => e.toString())?.toList() ??
            [];
    status = json['status'].string;
    isAllowSyncToCmis = json['isAllowSyncToCmis'].boolean;
    isMonitor = json['isMonitor'].boolean;
    isAllowSign = json['isAllowSign'].boolean;
    isAllowEditing = json['isAllowEditing'].boolean;
    isAllowSend = json['isAllowSend'].boolean;
    isAllowDelete = json['isAllowDelete'].boolean;
    isAllowApprove = json['isAllowApprove'].boolean;
    isAllowReject = json['isAllowReject'].boolean;
    isAllowReceive = json['isAllowReceive'].boolean;
    isAllowAccept = json['isAllowAccept'].boolean;
    isAllowSyncToPmis = json['isAllowSyncToPmis'].boolean;
    isExistLocation = json['isExistLocation'].boolean;
    isSendOTP = json['isSendOTP'].boolean;
    isConfirmOTP = json['isConfirmOTP'].boolean;
    isConfirmChangeDate = json['isConfirmChangeDate'].boolean;
    exportCertificateAccreditation =
        json['exportCertificateAccreditation'].boolean;
    exportCertificateTest = json['exportCertificateTest'].boolean;
    certificateIsAllowSend = json['certificateIsAllowSend'].boolean;
    certificateIsAllowApprove = json['certificateIsAllowApprove'].boolean;
    certificateIsAllowReject = json['certificateIsAllowReject'].boolean;
    certificateIsAllowReceive = json['certificateIsAllowReceive'].boolean;
    certificateIsAllowAccept = json['certificateIsAllowAccept'].boolean;
    type = json['type'].string;
    isAllowSignal = json['isAllowSignal'].boolean;
    reportType = json['reportType'].integer;
    formType = json['formType'].integer;
    workingStatus = json['workingStatus'].integer;
    unitId = json['unitId'].string;
    createdBy = json['createdBy'].string;
    teamId = json['teamId'].string;
    departmentId = json['departmentId'].string;
    userImps =
        json['userImps']?.listObject?.map((e) => e.toString())?.toList() ?? [];
    scheduleId = json['scheduleId'].string;
    isSelected = false;
  }

  String id;
  bool isCbm;
  String refId;
  String reportNumber;
  List<String> stampNumber;
  String status;
  bool isAllowSyncToCmis;
  bool isMonitor;
  bool isAllowSign;
  bool isAllowEditing;
  bool isAllowSend;
  bool isAllowDelete;
  bool isAllowApprove;
  bool isAllowReject;
  bool isAllowReceive;
  bool isAllowAccept;
  bool isAllowSyncToPmis;
  bool isExistLocation;
  bool isSendOTP;
  bool isConfirmOTP;
  bool isConfirmChangeDate;
  bool exportCertificateAccreditation;
  bool exportCertificateTest;
  bool certificateIsAllowSend;
  bool certificateIsAllowApprove;
  bool certificateIsAllowReject;
  bool certificateIsAllowReceive;
  bool certificateIsAllowAccept;
  String type;
  bool isAllowSignal;
  int reportType;
  int formType;
  int workingStatus;
  String unitId;
  String createdBy;
  String teamId;
  String departmentId;
  List<String> userImps;
  String scheduleId;
  bool isSelected;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['reportNumber'] = reportNumber;
    map['stampNumber'] = stampNumber;
    map['status'] = status;
    map['isAllowSyncToCmis'] = isAllowSyncToCmis;
    map['isMonitor'] = isMonitor;
    map['isAllowSign'] = isAllowSign;
    map['isAllowEditing'] = isAllowEditing;
    map['isAllowSend'] = isAllowSend;
    map['isAllowDelete'] = isAllowDelete;
    map['isAllowApprove'] = isAllowApprove;
    map['isAllowReject'] = isAllowReject;
    map['isAllowReceive'] = isAllowReceive;
    map['isAllowAccept'] = isAllowAccept;
    map['isAllowSyncToPmis'] = isAllowSyncToPmis;
    map['isExistLocation'] = isExistLocation;
    map['isSendOTP'] = isSendOTP;
    map['isConfirmOTP'] = isConfirmOTP;
    map['isConfirmChangeDate'] = isConfirmChangeDate;
    map['exportCertificateAccreditation'] = exportCertificateAccreditation;
    map['exportCertificateTest'] = exportCertificateTest;
    map['certificateIsAllowSend'] = certificateIsAllowSend;
    map['certificateIsAllowApprove'] = certificateIsAllowApprove;
    map['certificateIsAllowReject'] = certificateIsAllowReject;
    map['certificateIsAllowReceive'] = certificateIsAllowReceive;
    map['certificateIsAllowAccept'] = certificateIsAllowAccept;
    map['type'] = type;
    map['isAllowSignal'] = isAllowSignal;
    map['reportType'] = reportType;
    map['formType'] = formType;
    map['workingStatus'] = workingStatus;
    map['unitId'] = unitId;
    map['createdBy'] = createdBy;
    map['teamId'] = teamId;
    map['departmentId'] = departmentId;
    map['userImps'] = userImps;
    map['scheduleId'] = scheduleId;
    return map;
  }

  bool isShowIconMore() {
    return (exportCertificateTest || exportCertificateAccreditation) &&
        AppShared.instance.getUserProfile().isHasCreateFormReport();
  }

  String getTemNumber() {
    return stampNumber?.map((e) => e)?.join(', ')?.toString() ?? '';
  }

  // Hàm trả về icon theo trạng thái dựa trên workingStatus (int) hoặc status (string)
  Widget getStatusIconWidget() {
    return ReportStatusIcon.build(
      status: workingStatus,
      statusText: status,
      size: 18,
    );
  }
}

