// @dart=2.9
import 'package:g_json/g_json.dart';

class LineGeneralInfoModel {
  String id;
  String code;
  String lineWithPole;
  int type;
  String typeName;
  String lineName;
  String regions;
  double totalLength;
  String circuitNumber;
  String designVoltage;
  String operationDate;
  String createdDate;
  String lastestDate;
  String operationStatus;
  int totalEquipment;

  LineGeneralInfoModel(
      {this.id = '',
      this.code = '',
      this.lineWithPole = '',
      this.type = 0,
      this.typeName = '',
      this.lineName = '',
      this.regions = '',
      this.totalLength = 0,
      this.circuitNumber = '',
      this.designVoltage = '',
      this.operationDate = '',
      this.createdDate = '',
      this.lastestDate = '',
      this.operationStatus = '',
      this.totalEquipment=0});

  LineGeneralInfoModel.fromJson(JSON json) {
    id = json['id'].string;
    code = json['code'].string;
    lineWithPole = json['lineWithPole'].string;
    type = json['type'].integer;
    typeName = json['typeName'].string;
    lineName = json['lineName'].string;
    regions = json['regions'].string;
    totalLength = json['totalLength'].ddouble;
    circuitNumber = json['circuitNumber'].string;
    designVoltage = json['designVoltage'].string;
    operationDate = json['operationDate'].string;
    createdDate = json['createdDate'].string;
    lastestDate = json['lastestDate'].string;
    operationStatus = json['operationStatus'].string;
    totalEquipment = json['totalEquipment'].integer;
  }
}

