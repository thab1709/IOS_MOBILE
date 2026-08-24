// @dart=2.9
import 'package:g_json/g_json.dart';

class SubReportMeterModel {
  String id;
  String code;
  String scheduleId;
  String customerName;
  String customerCode;
  String meterNumber;
  String workingStatus;
  String address;
  bool isAllowEditing;

  SubReportMeterModel(
      {this.id,
        this.code,
        this.scheduleId,
        this.customerName,
        this.customerCode,
        this.meterNumber,
        this.workingStatus,
        this.address,
        this.isAllowEditing});

  SubReportMeterModel.fromJson(JSON json) {
    id = json['id'].string;
    code = json['code'].string;
    scheduleId = json['scheduleId'].string;
    customerName = json['customerName'].string;
    customerCode = json['customerCode'].string;
    meterNumber = json['meterNumber'].string;
    workingStatus = json['workingStatus'].string;
    address = json['address'].string;
    isAllowEditing = json['isAllowEditing'].boolean;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['scheduleId'] = scheduleId;
    data['customerName'] = customerName;
    data['customerCode'] = customerCode;
    data['meterNumber'] = meterNumber;
    data['workingStatus'] = workingStatus;
    data['address'] = address;
    data['isAllowEditing'] = isAllowEditing;
    return data;
  }
}
