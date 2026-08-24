// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:g_json/g_json.dart';
import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';

class CertificateModel {
  CertificateModel({
    this.id,
    this.code,
    this.reportName,
    this.reportType,
    this.unitRequest,
    this.locationId,
    this.location,
    this.equipmentName,
    this.equipmentType,
    this.equipmentDetail,
    this.department,
    this.team,
    this.userImp,
    this.createdDate,
    this.status,
    this.statusName,
    this.isAllowSend,
    this.isAllowApprove,
    this.isAllowReject,
    this.isAllowReceive,
    this.isAllowAccept,
    this.isSelected = false,
    this.isAlowSign = false,
    this.certificateType,});

  CertificateModel.fromJson(JSON json) {
    id = json['id'].string;
    code = json['code'].string;
    reportName = json['reportName'].string;
    reportType = json['reportType'].string;
    unitRequest = json['unitRequest'].string;
    locationId = json['locationId'].string;
    location = json['location'].string;
    equipmentName = json['equipmentName'].string;
    equipmentType = json['equipmentType'].string;
    equipmentDetail = json['equipmentDetail'].string;
    department = json['department'].string;
    team = json['team'].string;
    userImp = json['userImp'].string;
    createdDate = json['createdDate'].string;
    status = json['status'].integer;
    statusName = json['statusName'].string;
    isAllowSend = json['isAllowSend'].boolean;
    isAllowApprove = json['isAllowApprove'].boolean;
    isAllowReject = json['isAllowReject'].boolean;
    isAllowReceive = json['isAllowReceive'].boolean;
    isAllowAccept = json['isAllowAccept'].boolean;
    isSelected = json['isSelected'].boolean ?? false;
    isAlowSign = json['isAllowSignal'].boolean ?? false;
    certificateType = json['certificateType'].string;
  }
  String id;
  String code;
  String reportName;
  String reportType;
  String unitRequest;
  String locationId;
  String location;
  String equipmentName;
  String equipmentType;
  String equipmentDetail;
  String department;
  String team;
  String userImp;
  String createdDate;
  int status;
  String statusName;
  bool isAllowSend;
  bool isAllowApprove;
  bool isAllowReject;
  bool isAllowReceive;
  bool isAllowAccept;
  bool isAlowSign;
  bool isSelected;
  String certificateType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['code'] = code;
    map['reportName'] = reportName;
    map['reportType'] = reportType;
    map['unitRequest'] = unitRequest;
    map['locationId'] = locationId;
    map['location'] = location;
    map['equipmentName'] = equipmentName;
    map['equipmentType'] = equipmentType;
    map['equipmentDetail'] = equipmentDetail;
    map['department'] = department;
    map['team'] = team;
    map['userImp'] = userImp;
    map['createdDate'] = createdDate;
    map['status'] = status;
    map['statusName'] = statusName;
    map['isAllowSend'] = isAllowSend;
    map['isAllowApprove'] = isAllowApprove;
    map['isAllowReject'] = isAllowReject;
    map['isAllowReceive'] = isAllowReceive;
    map['isAllowAccept'] = isAllowAccept;
    map['certificateType'] = certificateType;
    map['isSelected'] = isSelected ?? false;
    map['isAllowSignal'] = isAlowSign ?? false;
    return map;
  }


  String getCreateDate() {
    return createdDate?.fromFormatUtcToFormatLocal(RAppStrings.hhmmddMMyyyy) ?? '';
  }
}

