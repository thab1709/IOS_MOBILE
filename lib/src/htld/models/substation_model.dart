// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:g_json/g_json.dart';

class SubstationModel {
  SubstationModel({
    @required this.id,
     this.code,
     this.name,
    this.lineId,
    this.lineName,
    this.latestInspectTime,
    this.assetManagementUnit,
    this.assetManagementUnitName,
    this.latestAbnormalPhenomenon,
    this.substationKind,
  });

  String id;
  String code;
  String name;
  String lineId;
  String lineName;
  String latestInspectTime;
  int assetManagementUnit;
  String assetManagementUnitName;
  String latestAbnormalPhenomenon;
  String substationKind ;

  factory SubstationModel.fromJson(JSON json) {
    return SubstationModel(
        id: json['id'].string,
        code: json['code'].string,
        name: json['name'].string,
        lineId: json['lineId']?.string,
        lineName: json['lineName']?.string,
        assetManagementUnitName: json['assetManagementUnitName']?.string,
        assetManagementUnit: json['assetManagementUnit']?.integer,
        latestInspectTime: json['latestInspectTime']?.string,
        substationKind: json['substationKind']?.string,
        latestAbnormalPhenomenon: json['latestAbnormalPhenomenon']?.string);
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'id': id,
      'code': code,
      'name': name,
      'lineId': lineId,
      'lineName': lineName,
      'latestInspectTime': latestInspectTime,
      'assetManagementUnit': assetManagementUnit,
      'assetManagementUnitName': assetManagementUnitName,
      'latestAbnormalPhenomenon': latestAbnormalPhenomenon,
      'substationKind': substationKind,
    } as Map<String, dynamic>;
  }
}

