// @dart=2.9
import 'package:g_json/g_json.dart';

class TBAGeneralInfoModel {
  String id;
  String code;
  int type;
  String typeName;
  String substationName;
  String cbm;
  String ward;
  String district;
  String province;
  String wattage;
  String operation;
  String firstPoint;
  String operateDate;
  String createdDate;
  String lastestDate;
  String operationStatus;
  String longitude;
  String latitude;
  int totalEquipment;
  double distance;
  String temperature;
  String humidity;

  TBAGeneralInfoModel(
      {this.id,
      this.code,
      this.type,
      this.typeName,
      this.substationName,
      this.cbm,
      this.ward,
      this.district,
      this.province,
      this.wattage,
      this.operation,
      this.firstPoint,
      this.operateDate,
      this.createdDate,
      this.lastestDate,
      this.operationStatus,
      this.totalEquipment=0,
      this.distance =500.0,
      this.temperature,
      this.humidity});

  TBAGeneralInfoModel.fromJson(JSON json) {
    id = json['id'].stringValue;
    code = json['code'].stringValue;
    type = json['type'].integer;
    typeName = json['typeName'].stringValue;
    substationName = json['substationName'].stringValue;
    cbm = json['cbm'].stringValue;
    ward = json['ward'].stringValue;
    district = json['district'].stringValue;
    province = json['province'].stringValue;
    wattage = json['wattage'].stringValue;
    operation = json['operation'].stringValue;
    firstPoint = json['firstPoint'].stringValue;
    operateDate = json['operateDate'].stringValue;
    createdDate = json['createdDate'].stringValue;
    lastestDate = json['lastestDate'].stringValue;
    operationStatus = json['operationStatus'].stringValue;
    longitude = json['longitude'].stringValue;
    latitude = json['latitude'].stringValue;
    totalEquipment = json['totalEquipment'].integer;
    distance  = json['distance'].ddouble;
    temperature  = json['temperature'].string;
    humidity  = json['humidity'].string;
  }
}

