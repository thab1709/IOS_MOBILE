// @dart=2.9
import 'package:g_json/g_json.dart';

class WorkloadModel {
  WorkloadModel({
    this.id,
    this.code,
    this.createdByName,
    this.unitName,
    this.requestType,
    this.status,
    this.statusName,
    this.createdDate,
    this.signDate,
    this.date,
    this.isSelected = false,
    this.confirmedDate,});

  WorkloadModel.fromJson(JSON json) {
    id = json['id'].string;
    code = json['code'].string;
    requestCode = json['requestCode'].string;
    statusName = json['statusName'].string;
    createdByName = json['createdByName'].string;
    unitName = json['unitName'].string;
    requestType = json['requestType'].string;
    date = json['date'].string;
    status = json['status'].integer;
    createdDate = json['createdDate'].string;
    confirmedDate = json['confirmedDate'].string;
    signDate = json['signDate'].string;
    consultantsImage = json['ConsultantsImage'].string;
    isAllowConfirm = json['isAllowConfirm'].boolean;
    isAllowSend = json['isAllowSend'].boolean;
  }
  
  String id;
  String code;
  String createdByName;
  String unitName;
  String requestType;
  String requestCode;
  int status;
  String statusName;
  String date;
  String createdDate;
  String confirmedDate;
  String signDate;
  String consultantsImage;
  bool isAllowConfirm;
  bool isAllowSend;
  bool isSelected;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['code'] = code;
    map['date'] = date;
    map['createdByName'] = createdByName;
    map['unitName'] = unitName;
    map['requestType'] = requestType;
    map['status'] = status;
    map['statusName'] = statusName;
    map['createdDate'] = createdDate;
    map['confirmedDate'] = confirmedDate;
    map['signDate'] = signDate;
    map['ConsultantsImage'] = consultantsImage;
    map['isAllowConfirm'] = isAllowConfirm;
    map['requestCode'] = requestCode;
    map['isAllowSend'] = isAllowSend;
    return map;
  }
}

